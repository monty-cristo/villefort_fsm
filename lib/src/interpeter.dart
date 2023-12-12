import 'dart:async';

import 'state.dart';

final class Interpeter<S extends Transitionable<S, E>, E extends Object> {
  late S _current;

  final StreamController<E> eventsController;
  final StreamController<S> updatesController;

  S get current => _current;

  Stream<E> get events => eventsController.stream;
  Stream<S> get updates => updatesController.stream;

  Interpeter({required this.eventsController, required this.updatesController});

  factory Interpeter.synchronous() {
    final eventsController = StreamController<E>(sync: true);
    final updatesController = StreamController<S>(sync: true);

    return Interpeter(eventsController: eventsController, updatesController: updatesController);
  }

  factory Interpeter.controller() {
    final eventsController = StreamController<E>();
    final updatesController = StreamController<S>();

    return Interpeter(eventsController: eventsController, updatesController: updatesController);
  }

  void start(S initial) {
    _current = initial;

    if (current is Enter) {
      (current as Enter).enter();
    }
  }

  void stop() {
    if (current is Exit) {
      (current as Exit).exit();
    }

    eventsController.close();
    updatesController.close();
  }

  void send(E event) {
    eventsController.add(event);

    final next = current.transition(this, event);

    if (current is Exit) {
      (current as Exit).exit();
    }

    updatesController.add(_current = next);

    if (current is Enter) {
      (current as Enter).enter();
    }
  }
}
