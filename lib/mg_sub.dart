// lib/mg_sub.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:collection';

part 'mg_sub.freezed.dart';

/// Global registry of all Sub controllers
HashMap<String, Sub> _sub = HashMap(
  equals: (name, otherName) => name == otherName,
);

/// Base Sub Controller
abstract class Sub<TSuccess> {
  String instanceName;
  SubState<TSuccess> _prevState = const SubState.initial(); // previous state

  Sub(this.instanceName) {
    _sub.putIfAbsent(instanceName, () => this);
  }

  static SubObserver observer = const _DefaultSubObserver();

  /// Retrieve existing Sub controller or create via GetIt
  static T of<T extends Sub>(String instanceName) {
    if (_sub.containsKey(instanceName)) {
      return _sub[instanceName] as T;
    } else {
      final controller = GetIt.I<T>(param1: instanceName);
      observer.onCreate(controller);
      return controller;
    }
  }

  /// For testing: all controllers of a type
  static List<T> ofAll<T extends Sub>() => _sub.values.whereType<T>().toList();
  static List<Sub> all() => _sub.values.toList();
  static Map<String, Sub> map() => _sub;

  final _stateController =
      BehaviorSubject<SubState<TSuccess>>()..sink.add(const SubState.initial());

  Stream<SubState<TSuccess>> get stateStream => _stateController.stream;

  /// Emit states
  void emitInitial() => _addState(const SubState.initial());
  void emitLoading() => _addState(const SubState.loading());
  void emitSuccess(TSuccess data) => _addState(SubState.success(data));
  void emitFailure(String error) => _addState(SubState.failure(error));

  /// Internal method to handle prevState and notify observer
  void _addState(SubState<TSuccess> newState) {
    final oldState = _stateController.value;
    _prevState = oldState;
    _stateController.add(newState);
    observer.onChange(this, _prevState, newState);
  }

  /// Get previous state
  SubState<TSuccess> get prevState => _prevState;

  /// Current state
  SubState<TSuccess> get currentState => _stateController.value;

  bool get isClosed => _stateController.isClosed;
  TSuccess? get subState => _stateController.value.dataOrNull;

  /// Dispose controller
  void dispose() {
    _stateController.close();
    _sub.remove(instanceName);
    observer.onClose(this);
  }
}

/// Widget to listen and rebuild on Sub state changes
class SubBuilder<T extends Sub<S>, S> extends StatefulWidget {
  final Widget Function(BuildContext context, SubState<S> state) builder;
  final String? instanceName;
  final bool autoDispose;

  const SubBuilder({
    super.key,
    required this.builder,
    this.instanceName,
    this.autoDispose = false,
  });

  @override
  State<SubBuilder<T, S>> createState() => _SubBuilderState<T, S>();
}

class _SubBuilderState<T extends Sub<S>, S> extends State<SubBuilder<T, S>> {
  late T controller;

  @override
  void initState() {
    super.initState();
    final name = widget.instanceName ?? T.toString();

    if (_sub.containsKey(name)) {
      controller = _sub[name] as T;
    } else {
      controller = GetIt.I<T>(param1: name);
      Sub.observer.onCreate(controller);
    }
  }

  @override
  void dispose() {
    if (widget.autoDispose) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SubState<S>>(
      initialData: controller.currentState,
      stream: controller.stateStream.distinct(),
      builder: (context, snapshot) {
        final state = snapshot.data!;
        return widget.builder(context, state);
      },
    );
  }
}

/// Freezed states for Sub
@freezed
class SubState<TSuccess> with _$SubState<TSuccess> {
  const SubState._();
  const factory SubState.initial() = _SubInitial;
  const factory SubState.loading() = _SubLoading;
  const factory SubState.success(TSuccess data) = _SubSuccess;
  const factory SubState.failure(String error) = _SubFailure;

  bool get isInitial => this is _SubInitial;
  bool get isLoading => this is _SubLoading;
  bool get isSuccess => this is _SubSuccess;
  bool get isFailure => this is _SubFailure;

  TSuccess? get dataOrNull => whenOrNull(success: (data) => data);
  String? get errorOrNull => whenOrNull(failure: (err) => err);

  @override
  String toString() => when(
        success: (_) => 'Success',
        loading: () => 'Loading',
        failure: (_) => 'Failure',
        initial: () => 'Initial',
      );
}

/// Observer interface
abstract class SubObserver {
  const SubObserver();

  @protected
  @mustCallSuper
  void onCreate(Sub<dynamic> sub) {}

  @protected
  @mustCallSuper
  void onChange(Sub<dynamic> sub, SubState<dynamic> prev, SubState<dynamic> next) {}

  @protected
  @mustCallSuper
  void onClose(Sub<dynamic> sub) {}
}

/// Default no-op observer
class _DefaultSubObserver extends SubObserver {
  const _DefaultSubObserver();
}
