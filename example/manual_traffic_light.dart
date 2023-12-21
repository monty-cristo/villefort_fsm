import 'package:villefort_fsm/villefort_fsm.dart';

typedef LightInterpeter = Interpeter<LightState, LightEvent>;

enum LightEvent {
  red,
  yellow,
  green,
}

sealed class LightState implements Transitionable<LightState, LightEvent> {
  const LightState();
}

final class RedState extends LightState {
  const RedState();

  @override
  LightState transition(LightEvent event) {
    return switch (event) {
      LightEvent.green => GreenState(),
      _ => throw InvalidTransitionError(),
    };
  }
}

final class YellowState extends LightState {
  const YellowState();

  @override
  LightState transition(LightEvent event) {
    return switch (event) {
      LightEvent.red => RedState(),
      _ => throw InvalidTransitionError(),
    };
  }
}

final class GreenState extends LightState {
  const GreenState();

  @override
  LightState transition(LightEvent event) {
    return switch (event) {
      LightEvent.yellow => YellowState(),
      _ => throw InvalidTransitionError(),
    };
  }
}
