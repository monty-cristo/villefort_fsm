import 'package:test/test.dart';

import '../../example/hierarchical/light.dart';
import '../../example/hierarchical/pedestrian.dart';

void main() {
  late LightInterpeter interpeter;

  setUp(() {
    interpeter = LightInterpeter.controller();
  });

  test('Valid transitions', () async {
    interpeter.start(const GreenState());

    interpeter.send(LightEvent.timer);
    interpeter.send(LightEvent.timer);

    expect(
      interpeter.updates,
      emitsInOrder([
        isA<YellowState>(),
        isA<RedState>(),
      ]),
    );

    final red = interpeter.current as RedState;

    red.pedestrian.send(CountDown());
    red.pedestrian.send(CountDown());

    expect(
      red.pedestrian.updates,
      emitsInOrder([
        isA<WaitState>(),
        isA<StopState>(),
      ]),
    );
  });
}
