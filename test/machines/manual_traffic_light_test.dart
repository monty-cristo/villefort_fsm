import 'package:test/test.dart';
import 'package:villefort_fsm/villefort_fsm.dart';

import '../../example/manual_traffic_light.dart';

void main() {
  late LightInterpeter interpeter;

  setUp(() {
    interpeter = LightInterpeter.controller();
  });

  test('Valid transitions', () {
    interpeter.start(const RedState());

    interpeter.send(LightEvent.green);
    interpeter.send(LightEvent.yellow);
    interpeter.send(LightEvent.red);

    expect(
      interpeter.updates,
      emitsInOrder([
        isA<GreenState>(),
        isA<YellowState>(),
        isA<RedState>(),
      ]),
    );
  });

  test('Invalid transitions', () {
    interpeter.start(const RedState());

    expect(() => interpeter.send(LightEvent.yellow), throwsA(isA<InvalidTransitionError>()));
    expect(() => interpeter.send(LightEvent.red), throwsA(isA<InvalidTransitionError>()));
  });
}
