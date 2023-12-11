import 'package:test/test.dart';
import 'package:villefort_fsm/villefort_fsm.dart';

void main() {
  group('Manual traffic light manual', () {
    test('Transitions', () {
      final invoker = Invoker<String>.create(
        provider: () async => 'hello',
        success: (value) => expect(value, 'hello'),
        error: (e, stack) => print('doaizjd'),
      );

      invoker.enter();
    });
  });
}
