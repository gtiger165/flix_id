import 'package:flix_id/data/dummies/dummy_authentication.dart';
import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DummyAuthentication', () {
    late DummyAuthentication dummyAuthentication;

    setUp(() {
      dummyAuthentication = DummyAuthentication();
    });

    test('login returns success with user ID', () async {
      final result = await dummyAuthentication.login(
        email: 'test@example.com',
        password: 'password',
      );

      expect(result, isA<Result<String>>());
      expect(result.resultValue, 'ID-12345');
    });

    // Write tests for other methods (getLoggedInUserId, logout, register)
    // once you implement them.

    test('getLoggedInUserId throws UnimplementedError', () {
      expect(() => dummyAuthentication.getLoggedInUserId(),
          throwsA(isA<UnimplementedError>()));
    });

    test('logout throws UnimplementedError', () {
      expect(() => dummyAuthentication.logout(),
          throwsA(isA<UnimplementedError>()));
    });

    test('register throws UnimplementedError', () {
      expect(() => dummyAuthentication.register(email: "any", password: "any"),
          throwsA(isA<UnimplementedError>()));
    });
  });
}
