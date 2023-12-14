import 'dart:async';

import 'package:villefort_fsm/villefort_fsm.dart';

typedef LightInterpeter = Interpeter<LightState, NextEvent>;

final class NextEvent {
  const NextEvent();
}

sealed class LightState implements Transitionable<LightState, NextEvent>, Exit {
  final Timer timer;

  LightState({required LightInterpeter interpeter, required int seconds}) : timer = Timer(Duration(seconds: seconds), () => interpeter.send(NextEvent()));

  @override
  void exit() {
    timer.cancel();
  }
}

final class RedState extends LightState {
  RedState({required super.interpeter}) : super(seconds: 5);

  @override
  LightState transition(LightInterpeter interpeter, NextEvent event) {
    return GreenState(interpeter: interpeter);
  }
}

final class YellowState extends LightState {
  YellowState({required super.interpeter}) : super(seconds: 2);

  @override
  LightState transition(LightInterpeter interpeter, NextEvent event) {
    return RedState(interpeter: interpeter);
  }
}

final class GreenState extends LightState {
  GreenState({required super.interpeter}) : super(seconds: 3);

  @override
  LightState transition(LightInterpeter interpeter, NextEvent event) {
    return YellowState(interpeter: interpeter);
  }
}

void main() {
  final interpeter = LightInterpeter.controller();

  interpeter.updates.listen(print);

  interpeter.start(GreenState(interpeter: interpeter));
}
