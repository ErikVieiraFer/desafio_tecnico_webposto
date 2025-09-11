import 'package:desafio_tecnico/src/features/auth/presentation/stores/auth_store.dart';
import 'package:desafio_tecnico/src/repositories/auth_exception.dart';
import 'package:desafio_tecnico/src/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockUser extends Mock implements User {}

void main() {
  late AuthStore authStore;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    when(() => mockAuthRepository.authStateChanges).thenAnswer((_) => Stream.value(null));
    authStore = AuthStore(mockAuthRepository);
  });

  tearDown(() {
    reset(mockAuthRepository);
  });

  group('AuthStore', () {
    test('initial values are correct', () {
      expect(authStore.user, isNull);
      expect(authStore.isLoading, isFalse);
      expect(authStore.error, isNull);
      expect(authStore.email, '');
      expect(authStore.password, '');
      expect(authStore.confirmPassword, '');
      expect(authStore.name, '');
    });

    test('setEmail updates email', () {
      authStore.setEmail('test@example.com');
      expect(authStore.email, 'test@example.com');
    });

    test('setPassword updates password', () {
      authStore.setPassword('password123');
      expect(authStore.password, 'password123');
    });

    test('setConfirmPassword updates confirmPassword', () {
      authStore.setConfirmPassword('password123');
      expect(authStore.confirmPassword, 'password123');
    });

    test('setName updates name', () {
      authStore.setName('Test User');
      expect(authStore.name, 'Test User');
    });

    group('signInWithEmailAndPassword', () {
      test('sets isLoading to true then false on success', () async {
        authStore.setEmail('test@example.com');
        authStore.setPassword('password123');
        when(() => mockAuthRepository.signInWithEmailAndPassword(
              email: 'test@example.com',
              password: 'password123',
            )).thenAnswer((_) async {});

        final future = authStore.signInWithEmailAndPassword();
        expect(authStore.isLoading, isTrue);
        await future;
        expect(authStore.isLoading, isFalse);
        expect(authStore.error, isNull);
      });

      test('sets error on AuthException', () async {
        authStore.setEmail('test@example.com');
        authStore.setPassword('wrongpassword');
        when(() => mockAuthRepository.signInWithEmailAndPassword(
              email: 'test@example.com',
              password: 'wrongpassword',
            )).thenThrow(AuthException('Invalid credentials'));

        await authStore.signInWithEmailAndPassword();
        expect(authStore.isLoading, isFalse);
        expect(authStore.error, 'Invalid credentials');
      });

      test('sets error on generic Exception', () async {
        authStore.setEmail('test@example.com');
        authStore.setPassword('password123');
        when(() => mockAuthRepository.signInWithEmailAndPassword(
              email: 'test@example.com',
              password: 'password123',
            )).thenThrow(Exception('Something went wrong'));

        await authStore.signInWithEmailAndPassword();
        expect(authStore.isLoading, isFalse);
        expect(authStore.error, contains('Erro desconhecido'));
      });

      test('does nothing if form is invalid', () async {
        authStore.setEmail('');
        authStore.setPassword('');
        await authStore.signInWithEmailAndPassword();
        expect(authStore.isLoading, isFalse);
        verifyNever(() => mockAuthRepository.signInWithEmailAndPassword(email: any(named: 'email'), password: any(named: 'password')));
      });
    });

    group('createUserWithEmailAndPassword', () {
      test('sets isLoading to true then false on success', () async {
        authStore.setEmail('newuser@example.com');
        authStore.setPassword('newpassword123');
        authStore.setConfirmPassword('newpassword123');
        authStore.setName('New User');
        when(() => mockAuthRepository.createUserWithEmailAndPassword(
              email: 'newuser@example.com',
              password: 'newpassword123',
              name: 'New User',
            )).thenAnswer((_) async {});

        final future = authStore.createUserWithEmailAndPassword();
        expect(authStore.isLoading, isTrue);
        await future;
        expect(authStore.isLoading, isFalse);
        expect(authStore.error, isNull);
      });

      test('sets error on AuthException', () async {
        authStore.setEmail('newuser@example.com');
        authStore.setPassword('newpassword123');
        authStore.setConfirmPassword('newpassword123');
        authStore.setName('New User');
        when(() => mockAuthRepository.createUserWithEmailAndPassword(
              email: 'newuser@example.com',
              password: 'newpassword123',
              name: 'New User',
            )).thenThrow(AuthException('Email already in use'));

        await authStore.createUserWithEmailAndPassword();
        expect(authStore.isLoading, isFalse);
        expect(authStore.error, 'Email already in use');
      });

      test('sets error on generic Exception', () async {
        authStore.setEmail('newuser@example.com');
        authStore.setPassword('newpassword123');
        authStore.setConfirmPassword('newpassword123');
        authStore.setName('New User');
        when(() => mockAuthRepository.createUserWithEmailAndPassword(
              email: 'newuser@example.com',
              password: 'newpassword123',
              name: 'New User',
            )).thenThrow(Exception('Something went wrong'));

        await authStore.createUserWithEmailAndPassword();
        expect(authStore.isLoading, isFalse);
        expect(authStore.error, contains('Erro desconhecido'));
      });

      test('sets error if passwords do not match', () async {
        authStore.setEmail('newuser@example.com');
        authStore.setPassword('newpassword123');
        authStore.setConfirmPassword('differentpassword');
        authStore.setName('New User');

        await authStore.createUserWithEmailAndPassword();
        expect(authStore.isLoading, isFalse);
        expect(authStore.error, 'As senhas não coincidem.');
        verifyNever(() => mockAuthRepository.createUserWithEmailAndPassword(email: any(named: 'email'), password: any(named: 'password'), name: any(named: 'name')));
      });

      test('does nothing if form is invalid', () async {
        authStore.setEmail('');
        authStore.setPassword('');
        authStore.setConfirmPassword('');
        authStore.setName('');
        await authStore.createUserWithEmailAndPassword();
        expect(authStore.isLoading, isFalse);
        verifyNever(() => mockAuthRepository.createUserWithEmailAndPassword(email: any(named: 'email'), password: any(named: 'password'), name: any(named: 'name')));
      });
    });

    group('signInWithGoogle', () {
      test('sets isLoading to true then false on success', () async {
        when(() => mockAuthRepository.signInWithGoogle()).thenAnswer((_) async {});

        final future = authStore.signInWithGoogle();
        expect(authStore.isLoading, isTrue);
        await future;
        expect(authStore.isLoading, isFalse);
        expect(authStore.error, isNull);
      });

      test('sets error on AuthException', () async {
        when(() => mockAuthRepository.signInWithGoogle()).thenThrow(AuthException('Google sign-in failed'));

        await authStore.signInWithGoogle();
        expect(authStore.isLoading, isFalse);
        expect(authStore.error, 'Google sign-in failed');
      });

      test('sets error on generic Exception', () async {
        when(() => mockAuthRepository.signInWithGoogle()).thenThrow(Exception('Something went wrong'));

        await authStore.signInWithGoogle();
        expect(authStore.isLoading, isFalse);
        expect(authStore.error, contains('Erro desconhecido'));
      });
    });

    group('signOut', () {
      test('sets isLoading to true then false on success', () async {
        when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});

        final future = authStore.signOut();
        expect(authStore.isLoading, isTrue);
        await future;
        expect(authStore.isLoading, isFalse);
        expect(authStore.error, isNull);
      });

      test('sets error on AuthException', () async {
        when(() => mockAuthRepository.signOut()).thenThrow(AuthException('Logout failed'));

        await authStore.signOut();
        expect(authStore.isLoading, isFalse);
        expect(authStore.error, 'Logout failed');
      });

      test('sets error on generic Exception', () async {
        when(() => mockAuthRepository.signOut()).thenThrow(Exception('Something went wrong'));

        await authStore.signOut();
        expect(authStore.isLoading, isFalse);
        expect(authStore.error, contains('Erro desconhecido'));
      });
    });
  });
}