import 'dart:async';

import 'state.dart';

final class Interpeter<S extends Transitionable<S, E>, E extends Object> {
  late S current;

  final StreamController<S> controller;

  Stream<S> get updates => controller.stream;

  Interpeter({required this.controller});

  factory Interpeter.synchronous() {
    final controller = StreamController<S>(sync: true);

    return Interpeter(controller: controller);
  }

  factory Interpeter.controller() {
    final controller = StreamController<S>();

    return Interpeter(controller: controller);
  }

  factory Interpeter.broadcast() {
    final controller = StreamController<S>.broadcast();

    return Interpeter(controller: controller);
  }

  void start(S initial) {
    current = initial;

    if (current is Enter) {
      (current as Enter).enter();
    }
  }

  void stop() {
    if (current is Exit) {
      (current as Exit).exit();
    }

    controller.close();
  }

  void send(E event) {
    final next = current.transition(this, event);

    if (current is Exit) {
      (current as Exit).exit();
    }

    controller.add(current = next);

    if (current is Enter) {
      (current as Enter).enter();
    }
  }
}
