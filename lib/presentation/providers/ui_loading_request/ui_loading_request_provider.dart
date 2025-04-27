import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_loading_request_provider.g.dart';

@riverpod
class UiLoadingRequest extends _$UiLoadingRequest {
  @override
  bool build() => false;

  void startLoading() {
    state = true;
  }

  void dismissLoading() {
    state = false;
  }
}
