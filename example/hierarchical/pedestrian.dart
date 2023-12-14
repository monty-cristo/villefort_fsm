import 'package:villefort_fsm/villefort_fsm.dart';

typedef PedestrianInterpeter = Interpeter<PedestrianState, CountDown>;

final class CountDown {
  const CountDown();
}

sealed class PedestrianState implements Transitionable<PedestrianState, CountDown> {
  const PedestrianState();
}

final class WalkState extends PedestrianState {
  const WalkState();

  @override
  PedestrianState transition(PedestrianInterpeter interpeter, CountDown event) {
    return switch (event) {
      CountDown() => const WaitState(),
    };
  }
}

final class WaitState extends PedestrianState {
  const WaitState();

  @override
  PedestrianState transition(PedestrianInterpeter interpeter, CountDown event) {
    return switch (event) {
      CountDown() => const StopState(),
    };
  }
}

final class StopState extends PedestrianState {
  const StopState();

  @override
  PedestrianState transition(PedestrianInterpeter interpeter, CountDown event) {
    throw InvalidTransitionError();
  }
}

final class BlinkingState extends PedestrianState {
  const BlinkingState();

  @override
  PedestrianState transition(PedestrianInterpeter interpeter, CountDown event) {
    throw InvalidTransitionError();
  }
}
