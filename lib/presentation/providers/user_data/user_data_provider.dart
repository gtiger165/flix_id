import 'dart:io';

import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flix_id/domain/entities/user/user.dart';
import 'package:flix_id/domain/usecases/get_logged_in_user/get_logged_in_user.dart';
import 'package:flix_id/domain/usecases/login/login.dart';
import 'package:flix_id/domain/usecases/register/register.dart';
import 'package:flix_id/domain/usecases/register/register_param.dart';
import 'package:flix_id/domain/usecases/top_up/top_up.dart';
import 'package:flix_id/domain/usecases/top_up/top_up_param.dart';
import 'package:flix_id/domain/usecases/upload_profile_picture/upload_profile_picture.dart';
import 'package:flix_id/domain/usecases/upload_profile_picture/upload_profile_picture_param.dart';
import 'package:flix_id/presentation/providers/movie/now_playing_provider.dart';
import 'package:flix_id/presentation/providers/movie/upcoming_provider.dart';
import 'package:flix_id/presentation/providers/transaction_data/transaction_data_provider.dart';
import 'package:flix_id/presentation/providers/usecases/get_logged_in_user_provider.dart';
import 'package:flix_id/presentation/providers/usecases/login_provider.dart';
import 'package:flix_id/presentation/providers/usecases/logout_provider.dart';
import 'package:flix_id/presentation/providers/usecases/register_provider.dart';
import 'package:flix_id/presentation/providers/usecases/top_up_provider.dart';
import 'package:flix_id/presentation/providers/usecases/upload_profile_picture_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data_provider.g.dart';

@Riverpod(keepAlive: true)
class UserData extends _$UserData {
  @override
  Future<User?> build() async {
    GetLoggedInUser getLoggedInUser = ref.read(getLoggedInUserProvider);
    final userResult = await getLoggedInUser(null);

    switch (userResult) {
      case Success(value: final user):
        _getMovies();
        return user;
      case Failed(message: _):
        return null;
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();

    Login login = ref.read(loginProvider);
    final loginResult = await login(
      LoginParams(
        email: email,
        password: password,
      ),
    );

    switch (loginResult) {
      case Success(value: final user):
        _getMovies();
        state = AsyncData(user);
      case Failed(:final message):
        state = AsyncError(FlutterError(message), StackTrace.current);
        state = const AsyncData(null);
    }
  }

  Future<void> register(
      {required String email,
      required String password,
      required String name,
      String? imageUrl,
      String? bio}) async {
    state = const AsyncLoading();

    Register register = ref.read(registerProvider);
    final result = await register(
      RegisterParam(
        email: email,
        password: password,
        name: name,
        photoUrl: imageUrl,
      ),
    );

    switch (result) {
      case Success(value: final user):
        _getMovies();
        state = AsyncData(user);
      case Failed(:final message):
        state = AsyncError(FlutterError(message), StackTrace.current);
        state = const AsyncData(null);
    }
  }

  Future<void> refreshUserData() async {
    GetLoggedInUser getLoggedInUser = ref.read(getLoggedInUserProvider);

    var result = await getLoggedInUser(null);

    if (result case Success(value: final user)) {
      state = AsyncData(user);
    }
  }

  Future<void> logout() async {
    final logout = ref.read(logoutProvider);
    final result = await logout(null);

    switch (result) {
      case Success(value: _):
        state = const AsyncData(null);
      case Failed(:final message):
        state = AsyncError(FlutterError(message), StackTrace.current);
        state = AsyncData(state.valueOrNull);
    }
  }

  Future<void> topUp(int amount) async {
    state = const AsyncValue.loading();
    TopUp topUp = ref.read(topUpProvider);

    String? userId = state.valueOrNull?.uid;

    if (userId != null) {
      final result = await topUp(TopUpParam(amount: amount, userId: userId));

      if (!result.isSuccess) {
        state =
            AsyncValue.error(FlutterError("Gagal Top Up"), StackTrace.current);
        return;
      }

      refreshUserData();
      ref.read(transactionDataProvider.notifier).refreshTransactionData();
    }
  }

  Future<void> uploadProfilePicture({
    required User user,
    required File imageFile,
  }) async {
    UploadProfilePicture uploadProfilePicture =
        ref.read(uploadProfilePictureProvider);

    final result = await uploadProfilePicture(
        UploadProfilePictureParam(imageFile: imageFile, user: user));

    if (result case Success(value: final user)) {
      state = AsyncData(user);
    }
  }

  void _getMovies() {
    ref.read(nowPlayingProvider.notifier).getMovies();
    ref.read(upcomingProvider.notifier).getMovies();
  }
}
