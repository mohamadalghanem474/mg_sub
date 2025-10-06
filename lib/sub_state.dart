import 'package:freezed_annotation/freezed_annotation.dart';
part 'sub_state.freezed.dart';
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
