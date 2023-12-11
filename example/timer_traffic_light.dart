import 'dart:async';

import 'package:villefort_fsm/villefort_fsm.dart';

typedef LightInterpeter = Interpeter<LightState, NextEvent>;

final class NextEvent {
  const NextEvent();
}

sealed class LightState implements Transitionable<LightState, NextEvent> {
  const LightState();
}

final class RedState extends LightState implements Exit {
  final Timer timer;

  const RedState({required this.timer});

  factory RedState.timer({required LightInterpeter interpeter}) {
    return RedState(timer: Timer(const Duration(seconds: 5), () => interpeter.send(NextEvent())));
  }

  @override
  LightState transition(LightInterpeter interpeter, NextEvent event) {
    return GreenState.timer(interpeter: interpeter);
  }

  @override
  void exit() {
    timer.cancel();
  }
}

final class YellowState extends LightState implements Exit {
  final Timer timer;

  const YellowState({required this.timer});

  factory YellowState.timer({required LightInterpeter interpeter}) {
    return YellowState(timer: Timer(const Duration(seconds: 1), () => interpeter.send(NextEvent())));
  }

  @override
  LightState transition(LightInterpeter interpeter, NextEvent event) {
    return RedState.timer(interpeter: interpeter);
  }

  @override
  void exit() {
    timer.cancel();
  }
}

final class GreenState extends LightState implements Exit {
  final Timer timer;

  const GreenState({required this.timer});

  factory GreenState.timer({required LightInterpeter interpeter}) {
    return GreenState(timer: Timer(const Duration(seconds: 2), () => interpeter.send(NextEvent())));
  }

  @override
  LightState transition(LightInterpeter interpeter, NextEvent event) {
    return YellowState.timer(interpeter: interpeter);
  }

  @override
  void exit() {
    timer.cancel();
  }
}

void main() {
  final interpeter = LightInterpeter.controller();

  interpeter.updates.listen(print);

  interpeter.start(GreenState.timer(interpeter: interpeter));
}
