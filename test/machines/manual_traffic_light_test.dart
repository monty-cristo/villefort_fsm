import 'package:test/test.dart';
import 'package:villefort_fsm/villefort_fsm.dart';

import '../../example/manual_traffic_light.dart';

void main() {
  group('Manual traffic light manual', () {
    late LightInterpeter interpeter;

    setUp(() {
      interpeter = LightInterpeter.synchronous();
    });

    test('Transitions', () {
      interpeter.start(const RedState());

      expect(interpeter.current, isA<RedState>());

      interpeter.send(const GreenEvent());

      print(interpeter.current);

      expect(interpeter.current, isA<GreenState>());

      interpeter.send(const YellowEvent());

      expect(interpeter.current, isA<YellowState>());

      interpeter.send(const RedEvent());

      expect(interpeter.current, isA<RedState>());
    });

    test('Invalid transitions', () {
      interpeter.start(const RedState());

      expect(() => interpeter.send(const YellowEvent()), throwsA(isA<InvalidTransitionException>()));
      expect(() => interpeter.send(const RedEvent()), throwsA(isA<InvalidTransitionException>()));
    });
  });
}
