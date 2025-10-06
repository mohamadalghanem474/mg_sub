// lib/mg_sub.dart
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:collection';

part 'mg_sub.freezed.dart';

/// Global registry of all Sub controllers
final HashMap<String, Sub> _sub = HashMap(
  equals: (name, otherName) => name == otherName,
);

/// Base Sub Controller
abstract class Sub<S> {
  final String _id;
  String get id => _id;
  late S _prevState;
  late final BehaviorSubject<S> _stateController;

  Sub(S _state, this._id) {
    _prevState = _state;
    _sub.putIfAbsent(_id, () => this);
    _stateController = BehaviorSubject<S>.seeded(_prevState);
  }

  /// Global observer for Sub events
  static SubObserver observer = const _DefaultSubObserver();

  /// Retrieve existing Sub controller or create via GetIt
  static T of<T extends Sub>(String id) {
    if (_sub.containsKey(id)) {
      return _sub[id] as T;
    } else {
      final controller = GetIt.I<T>(param1: id);
      observer.onCreate(controller);
      return controller;
    }
  }

  /// For testing: all controllers of a type
  static List<T> ofAll<T extends Sub>() => _sub.values.whereType<T>().toList();

  /// For testing: all controllers
  static Map<String, Sub> all() => _sub;

  /// Clear all controllers
  static void clear() => _sub.clear();

  /// Stream of state updates
  Stream<S> get stateStream => _stateController.stream;

  /// Emit a new state
  void emit(S state) => _addState(state);

  /// Internal method to update state and notify observer
  void _addState(S newState) {
    final oldState = _stateController.value;
    _prevState = oldState;
    _stateController.add(newState);
    observer.onChange(this, oldState, newState);
  }

  /// Previous state
  S get prevState => _prevState;

  /// Current state
  S get currentState => _stateController.value;

  /// Whether the controller is closed
  bool get isClosed => _stateController.isClosed;

  /// Dispose controller
  void dispose() {
    if (!_stateController.isClosed) _stateController.close();
    _sub.remove(_id);
    observer.onClose(this);
  }
}

/// Widget to listen and rebuild on Sub state changes
class SubBuilder<T extends Sub<S>, S> extends StatefulWidget {
  final Widget Function(BuildContext context, S state) builder;
  final String? id;
  final bool close;

  const SubBuilder({
    super.key,
    required this.builder,
    this.id,
    this.close = true, // dispose controller when leaving page
  });

  @override
  State<SubBuilder<T, S>> createState() => _SubBuilderState<T, S>();
}

class _SubBuilderState<T extends Sub<S>, S> extends State<SubBuilder<T, S>> {
  late T controller;

  @override
  void initState() {
    super.initState();
    final name = widget.id ?? T.toString();

    if (_sub.containsKey(name)) {
      controller = _sub[name] as T;
    } else {
      controller = GetIt.I<T>(param1: name);
      Sub.observer.onCreate(controller);
    }
  }

  @override
  void dispose() {
    if (widget.close) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      initialData: controller.currentState,
      stream: controller.stateStream.distinct(),
      builder: (context, snapshot) {
        final state = snapshot.data!;
        return widget.builder(context, state);
      },
    );
  }
}

/// Observer interface
abstract class SubObserver {
  const SubObserver();

  @protected
  @mustCallSuper
  void onCreate(Sub<dynamic> sub) {}

  @protected
  @mustCallSuper
  void onChange(Sub<dynamic> sub, dynamic prev, dynamic next) {}

  @protected
  @mustCallSuper
  void onClose(Sub<dynamic> sub) {}
}

/// Default no-op observer
class _DefaultSubObserver extends SubObserver {
  const _DefaultSubObserver();
}

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
