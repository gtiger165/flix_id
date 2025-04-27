import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loading_request_provider.g.dart';

@riverpod
class LoadingRequest extends _$LoadingRequest {
  @override
  Future<bool> build() async => false;

  void showLoading({String message = "Loading..."}) {
    EasyLoading.show(status: message);
  }

  void dismissLoading() => EasyLoading.dismiss();
}
