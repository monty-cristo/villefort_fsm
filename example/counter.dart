import 'package:villefort_fsm/villefort_fsm.dart';

typedef CounterInterpeter = Interpeter<CounterState, CounterEvent>;

sealed class CounterEvent {
  const CounterEvent();
}

final class IncrementEvent extends CounterEvent {
  final int amount;

  const IncrementEvent({required this.amount});
}

final class DecrementEvent extends CounterEvent {
  final int amount;

  const DecrementEvent({required this.amount});
}

final class CounterState implements Transitionable<CounterState, CounterEvent> {
  final int amount;

  const CounterState({required this.amount});

  @override
  CounterState transition(Interpeter<CounterState, CounterEvent> interpeter, CounterEvent event) {
    return switch (event) {
      IncrementEvent(amount: final amount) => CounterState(amount: this.amount + amount),
      DecrementEvent(amount: final amount) => CounterState(amount: this.amount - amount),
    };
  }
}

void main() {
  final interpeter = CounterInterpeter.synchronous();

  final subscription = interpeter.updates.listen((state) => print(state.amount));

  interpeter.start(CounterState(amount: 0));

  interpeter.send(IncrementEvent(amount: 10));
  interpeter.send(DecrementEvent(amount: 15));
  interpeter.send(IncrementEvent(amount: 33));

  subscription.cancel();

  interpeter.stop();
}
