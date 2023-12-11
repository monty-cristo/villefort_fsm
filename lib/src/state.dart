import 'interpeter.dart';

abstract interface class Enter {
  void enter();
}

abstract interface class Exit {
  void exit();
}

abstract interface class Transitionable<S extends Transitionable<S, E>, E extends Object> {
  S transition(Interpeter<S, E> interpeter, E event);
}

final class InvalidTransitionException implements Exception {}
