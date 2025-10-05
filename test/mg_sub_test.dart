import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_sub/mg_sub.dart';

/// A mock controller that extends Sub
class TestController extends Sub<String> {
  TestController(super.instanceName);

  void simulateSuccess(String data) => emitSuccess(data);
  void simulateFailure(String error) => emitFailure(error);
}

void main() {
  final sl = GetIt.instance;

  setUp(() {
    sl.reset();
  });

  group('Sub', () {
    test('emits correct states in order', () async {
      final controller = TestController('test');
      final states = <SubState<String>>[];

      controller.stateStream.listen(states.add);

      controller.emitInitial();
      controller.emitLoading();
      controller.emitSuccess('done');
      controller.emitFailure('error');

      await Future.delayed(const Duration(milliseconds: 10));

      expect(states.length, equals(5)); // includes initial state
      expect(states.last.isFailure, isTrue);
      expect(states.last.errorOrNull, equals('error'));
    });

    test('controller is stored and retrieved from global map', () {
      final controllerA = TestController('myKey');
      final controllerB = Sub.of<TestController>('myKey');

      expect(controllerA, equals(controllerB));
      expect(Sub.map().containsKey('myKey'), isTrue);
    });

    test('controller.dispose() removes from registry', () {
      final controller = TestController('toDispose');
      expect(Sub.map().containsKey('toDispose'), isTrue);

      controller.dispose();
      expect(Sub.map().containsKey('toDispose'), isFalse);
    });

    test('of() creates new controller via GetIt when not exists', () {
      sl.registerFactoryParam<TestController, String, void>(
        (name, _) => TestController(name),
      );

      final controller = Sub.of<TestController>('created');
      expect(controller.instanceName, equals('created'));
      expect(Sub.map().containsKey('created'), isTrue);
    });
  });

  group('SubState', () {
    test('state properties work correctly', () {
      SubState<String> state1 = SubState<String>.initial();
      SubState<String> state2 = SubState<String>.loading();
      SubState<String> state3 = SubState<String>.success('hi');
      SubState<String> state4 = SubState<String>.failure('error');

      expect(state1.isInitial, isTrue);
      expect(state2.isLoading, isTrue);
      expect(state3.isSuccess, isTrue);
      expect(state4.isFailure, isTrue);
      expect(state3.dataOrNull, equals('hi'));
      expect(state4.errorOrNull, equals('error'));
    });
  });
}
