import 'package:villefort_fsm/villefort_fsm.dart';

typedef LightInterpeter = Interpeter<LightState, LightEvent>;

sealed class LightEvent {
  const LightEvent();
}

final class RedEvent extends LightEvent {
  const RedEvent();
}

final class YellowEvent extends LightEvent {
  const YellowEvent();
}

final class GreenEvent extends LightEvent {
  const GreenEvent();
}

sealed class LightState implements Transitionable<LightState, LightEvent> {
  const LightState();
}

final class RedState extends LightState {
  const RedState();

  @override
  LightState transition(LightInterpeter interpeter, LightEvent event) {
    return switch (event) {
      GreenEvent() => GreenState(),
      _ => throw InvalidTransitionException(),
    };
  }
}

final class YellowState extends LightState {
  const YellowState();

  @override
  LightState transition(LightInterpeter interpeter, LightEvent event) {
    return switch (event) {
      RedEvent() => RedState(),
      _ => throw InvalidTransitionException(),
    };
  }
}

final class GreenState extends LightState {
  const GreenState();

  @override
  LightState transition(LightInterpeter interpeter, LightEvent event) {
    return switch (event) {
      YellowEvent() => YellowState(),
      _ => throw InvalidTransitionException(),
    };
  }
}
