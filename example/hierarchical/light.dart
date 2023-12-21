import 'package:villefort_fsm/villefort_fsm.dart';

import 'pedestrian.dart';

typedef LightInterpeter = Interpeter<LightState, LightEvent>;

enum LightEvent {
  outage,
  restored,
  timer,
}

sealed class LightState implements Transitionable<LightState, LightEvent> {
  const LightState();
}

final class RedState extends LightState implements Enter, Exit {
  final PedestrianState initial;

  final PedestrianInterpeter pedestrian;

  const RedState({required this.initial, required this.pedestrian});

  factory RedState.walk() {
    return RedState(initial: const WalkState(), pedestrian: PedestrianInterpeter.controller());
  }

  factory RedState.blinking() {
    return RedState(initial: const BlinkingState(), pedestrian: PedestrianInterpeter.controller());
  }

  @override
  LightState transition(LightEvent event) {
    return switch (event) {
      LightEvent.timer => const GreenState(),
      LightEvent.outage => RedState(initial: const BlinkingState(), pedestrian: pedestrian),
      LightEvent.restored => RedState(initial: const WalkState(), pedestrian: pedestrian),
    };
  }

  @override
  void enter() {
    pedestrian.start(initial);
  }

  @override
  void exit() {
    pedestrian.stop();
  }
}

final class YellowState extends LightState {
  const YellowState();

  @override
  LightState transition(LightEvent event) {
    return switch (event) {
      LightEvent.timer => RedState.walk(),
      LightEvent.outage => RedState.blinking(),
      _ => throw InvalidTransitionError(),
    };
  }
}

final class GreenState extends LightState {
  const GreenState();

  @override
  LightState transition(LightEvent event) {
    return switch (event) {
      LightEvent.timer => const YellowState(),
      LightEvent.outage => RedState.blinking(),
      _ => throw InvalidTransitionError(),
    };
  }
}
