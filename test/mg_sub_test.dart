// test/mg_sub_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_sub/mg_sub.dart';

// Mock Observer
class MockObserver extends SubObserver {
  final _onCreate = <Sub>[];
  final _onChange = <Map<String, dynamic>>[];
  final _onClose = <Sub>[];

  @override
  void onCreate(Sub<dynamic> sub) {
    _onCreate.add(sub);
    super.onCreate(sub);
  }

  @override
  void onChange(Sub<dynamic> sub, prev, next) {
    _onChange.add({'sub': sub, 'prev': prev, 'next': next});
    super.onChange(sub, prev, next);
  }

  @override
  void onClose(Sub<dynamic> sub) {
    _onClose.add(sub);
    super.onClose(sub);
  }

  List<Sub> get created => _onCreate;
  List<Map<String, dynamic>> get changed => _onChange;
  List<Sub> get closed => _onClose;
}

// Simple Sub implementation for testing
class CounterSub extends Sub<int> {
  CounterSub(String name) : super(0, name);
  void increment() => emit(currentState + 1);
}

void main() {
  setUp(() {
    GetIt.I.reset();
    Sub.clear();
  });

  group('Sub core functionality', () {
    test('create and retrieve Sub instance', () {
      final counter = CounterSub('counter1');
      expect(Sub.of<CounterSub>('counter1'), counter);
      expect(Sub.ofAll<CounterSub>().length, 1);
    });

    test('emit updates and track previous/current state', () {
      final counter = CounterSub('counter2');
      expect(counter.currentState, 0);
      counter.increment();
      expect(counter.currentState, 1);
      expect(counter.prevState, 0);
    });

    test('observer callbacks are triggered', () {
      final observer = MockObserver();
      Sub.observer = observer;

      final counter = CounterSub('counter3');
      expect(observer.created.contains(counter), true);

      counter.increment();
      expect(observer.changed.any((c) => c['sub'] == counter && c['prev'] == 0 && c['next'] == 1), true);

      counter.dispose();
      expect(observer.closed.contains(counter), true);
    });

    test('dispose removes instance from registry', () {
      final counter = CounterSub('counter4');
      expect(Sub.all().containsKey('counter4'), true);
      counter.dispose();
      expect(Sub.all().containsKey('counter4'), false);
    });
  });

  group('SubBuilder widget', () {
    testWidgets('rebuilds on state changes', (tester) async {
      final counter = CounterSub('counterWidget');

      await tester.pumpWidget(
        MaterialApp(
          home: SubBuilder<CounterSub, int>(
            instanceName: 'counterWidget',
            builder: (context, state) => Text('Value: $state', textDirection: TextDirection.ltr),
          ),
        ),
      );

      expect(find.text('Value: 0'), findsOneWidget);

      counter.increment();
      await tester.pump();
      expect(find.text('Value: 1'), findsOneWidget);
    });

    testWidgets('disposes controller if close is true', (tester) async {
      final counter = CounterSub('counterDispose');
      await tester.pumpWidget(
        MaterialApp(
          home: SubBuilder<CounterSub, int>(
            instanceName: 'counterDispose',
            builder: (context, state) => Container(),
          ),
        ),
      );

      await tester.pumpWidget(Container());
      expect(counter.isClosed, true);
      expect(Sub.all().containsKey('counterDispose'), false);
    });
  });
}
