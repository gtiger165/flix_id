import 'dart:io';

import 'package:flix_id/data/dummies/dummy_user_repository.dart';
import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flix_id/domain/entities/user/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DummyUserRepository', () {
    late DummyUserRepository dummyUserRepository;

    setUp(() {
      dummyUserRepository = DummyUserRepository();
    });

    test('getUser returns success with User object', () async {
      final result = await dummyUserRepository.getUser(uid: 'testUid');

      expect(result, isA<Result<User>>());
      expect(result.resultValue!.uid, 'testUid');
      expect(result.resultValue!.email, 'dummy@dummy.com');
      expect(result.resultValue!.name, 'dummy');
    });

    test('createUser throws UnimplementedError', () async {
      expect(
          () => dummyUserRepository.createUser(
              uid: "any", email: "any", name: "any"),
          throwsA(isA<UnimplementedError>()));
    });

    test('getUserBalance throws UnimplementedError', () async {
      expect(() => dummyUserRepository.getUserBalance(uid: "any"),
          throwsA(isA<UnimplementedError>()));
    });

    test('updateUser throws UnimplementedError', () async {
      expect(
          () => dummyUserRepository.updateUser(
              user: User(uid: "any", email: "any", name: "any")),
          throwsA(isA<UnimplementedError>()));
    });

    test('updateUserBalance throws UnimplementedError', () async {
      expect(
          () => dummyUserRepository.updateUserBalance(uid: "any", balance: 100),
          throwsA(isA<UnimplementedError>()));
    });

    test('uploadProfilePicture throws UnimplementedError', () async {
      expect(
          () => dummyUserRepository.uploadProfilePicture(
              user: User(uid: "any", email: "any", name: "any"),
              imageFile: File("any")),
          throwsA(isA<UnimplementedError>()));
    });
  });
}
