import 'package:test/test.dart';

import '../../example/counter.dart';

void main() {
  late CounterInterpeter interpeter;

  setUp(() {
    interpeter = CounterInterpeter.controller();
  });

  test('Valid transitions', () {
    interpeter.start(const CounterState(amount: 0));

    interpeter.send(IncrementEvent(amount: 10));
    interpeter.send(DecrementEvent(amount: 15));
    interpeter.send(IncrementEvent(amount: 33));

    expect(
      interpeter.updates,
      emitsInOrder([
        predicate<CounterState>((state) => state.amount == 10),
        predicate<CounterState>((state) => state.amount == -5),
        predicate<CounterState>((state) => state.amount == 28),
      ]),
    );
  });
}
