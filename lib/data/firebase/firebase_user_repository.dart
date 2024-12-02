import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flix_id/data/repositories/user_repository.dart';
import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flix_id/domain/entities/user/user.dart';
import 'package:path/path.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore _firebaseFirestore;

  FirebaseUserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<Result<User>> createUser(
      {required String uid,
      required String email,
      required String name,
      String? photoUrl,
      int balance = 0}) async {
    CollectionReference<Map<String, dynamic>> users =
        _firebaseFirestore.collection('users');

    await users.doc(uid).set({
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'balance': balance,
    });

    DocumentSnapshot<Map<String, dynamic>> result = await users.doc(uid).get();

    return switch (result.exists) {
      true => Result.success(User.fromJson(result.data()!)),
      false => Result.failed("Failed to create user")
    };
  }

  @override
  Future<Result<User>> getUser({required String uid}) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        _firebaseFirestore.doc('users/$uid');

    DocumentSnapshot<Map<String, dynamic>> result =
        await documentReference.get();

    return switch (result.exists) {
      true => Result.success(User.fromJson(result.data()!)),
      false => Result.failed("User not found")
    };
  }

  @override
  Future<Result<int>> getUserBalance({required String uid}) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        _firebaseFirestore.doc('users/$uid');
    DocumentSnapshot<Map<String, dynamic>> result =
        await documentReference.get();

    return switch (result.exists) {
      true => Result.success(result.data()!["balance"]),
      false => Result.failed("User not found")
    };
  }

  @override
  Future<Result<User>> updateUser({required User user}) async {
    try {
      DocumentReference<Map<String, dynamic>> documentReference =
          _firebaseFirestore.doc('users/${user.uid}');

      await documentReference.update(user.toJson());

      DocumentSnapshot<Map<String, dynamic>> result =
          await documentReference.get();

      if (!result.exists) return Result.failed("Failed to update user data");

      User updatedUser = User.fromJson(result.data()!);

      return switch (updatedUser == user) {
        true => Result.success(updatedUser),
        false => Result.failed("Failed to update user data")
      };
    } on FirebaseException {
      return Result.failed("Failed to update user data");
    }
  }

  @override
  Future<Result<User>> updateUserBalance(
      {required String uid, required int balance}) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        _firebaseFirestore.doc('users/$uid');
    DocumentSnapshot<Map<String, dynamic>> result =
        await documentReference.get();

    if (!result.exists) return Result.failed("User not found");

    await documentReference.update({'balance': balance});

    final updatedResult = await documentReference.get();

    if (!updatedResult.exists) {
      return Result.failed("Failed to retrieve updated user balance");
    }

    final updatedUser = User.fromJson(updatedResult.data()!);

    return switch (updatedUser.balance == balance) {
      true => Result.success(updatedUser),
      false => Result.failed("User not found")
    };
  }

  @override
  Future<Result<User>> uploadProfilePicture(
      {required User user, required File imageFile}) async {
    final filename = basename(imageFile.path);

    Reference reference = FirebaseStorage.instance.ref().child(filename);

    try {
      await reference.putFile(imageFile);

      final downloadUrl = await reference.getDownloadURL();

      final updatedResult =
          await updateUser(user: user.copyWith(photoUrl: downloadUrl));

      return switch (updatedResult.isSuccess) {
        true => Result.success(updatedResult.resultValue!),
        false => Result.failed(updatedResult.errorMessage!)
      };
    } catch (e) {
      return Result.failed("Failed to upload profile picture");
    }
  }
}
