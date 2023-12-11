import 'dart:async';

import 'interpeter.dart';
import 'state.dart';

typedef AsyncInterpeter<T> = Interpeter<AsyncState<T>, AsyncEvent>;
typedef FutureProvider<T> = Future<T> Function();

sealed class AsyncState<T> implements Transitionable<AsyncState<T>, AsyncEvent> {
  const AsyncState();
}

final class AsyncLoading<T> extends AsyncState<T> implements Enter {
  final FutureProvider<T> provider;

  final AsyncInterpeter interpeter;

  const AsyncLoading({required this.provider, required this.interpeter});

  @override
  AsyncState<T> transition(AsyncInterpeter interpeter, AsyncEvent event) {
    return switch (event) {
      AsyncSuccessEvent(value: final value) => AsyncSuccess(value: value),
      AsyncErrorEvent(exception: final exception, stackTrace: final stackTrace) => AsyncError(exception: exception, stackTrace: stackTrace),
    };
  }

  @override
  void enter() {
    provider().then((value) => interpeter.send(AsyncSuccessEvent(value: value)));
  }
}

final class AsyncSuccess<T> extends AsyncState<T> {
  final T value;

  const AsyncSuccess({required this.value});

  @override
  AsyncState<T> transition(AsyncInterpeter interpeter, AsyncEvent event) {
    throw Exception();
  }
}

final class AsyncError<T> extends AsyncState<T> {
  final Object exception;
  final StackTrace stackTrace;

  const AsyncError({required this.exception, required this.stackTrace});

  @override
  AsyncState<T> transition(AsyncInterpeter interpeter, AsyncEvent event) {
    throw Exception();
  }
}

sealed class AsyncEvent {
  const AsyncEvent();
}

final class AsyncSuccessEvent<T> extends AsyncEvent {
  final T value;

  const AsyncSuccessEvent({required this.value});
}

final class AsyncErrorEvent extends AsyncEvent {
  final Object exception;
  final StackTrace stackTrace;

  const AsyncErrorEvent({required this.exception, required this.stackTrace});
}

final class Invoker<T> implements Enter, Exit {
  final FutureProvider<T> provider;

  final AsyncInterpeter<T> interpeter;

  final StreamSubscription<AsyncState<T>> subscription;

  const Invoker({required this.provider, required this.interpeter, required this.subscription});

  factory Invoker.create({
    required FutureProvider<T> provider,
    required void Function(T value) success,
    required void Function(Object error, StackTrace stackTrace) error,
  }) {
    final interpeter = AsyncInterpeter<T>.synchronous();

    final subscription = interpeter.updates.listen((state) {
      print(state);

      switch (state) {
        case AsyncSuccess<T>(value: final value):
          success(value);
        case AsyncError(exception: final exception, stackTrace: final stackTrace):
          error(exception, stackTrace);
        case AsyncLoading<T>():
          throw Exception();
      }
    });

    return Invoker(provider: provider, interpeter: interpeter, subscription: subscription);
  }

  @override
  void enter() {
    interpeter.start(AsyncLoading(provider: provider, interpeter: interpeter));
  }

  @override
  void exit() {
    subscription.cancel();

    interpeter.stop();
  }
}
