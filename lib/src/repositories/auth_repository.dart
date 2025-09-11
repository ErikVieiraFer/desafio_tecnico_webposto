import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './auth_exception.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthException(e));
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(name);

      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;
        final defaultColumn = {
          'name': 'A Fazer',
          'order': 0,
          'isDeletable': false,
          'createdAt': FieldValue.serverTimestamp(),
          'userId': uid,
        };
        await _firestore.collection('kanban_lists').add(defaultColumn);
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthException(e));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException('Login com Google cancelado.');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthException(e));
    } catch (e) {
      throw AuthException('Erro ao fazer login com Google: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  String _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'E-mail invalido.';
      case 'user-disabled':
        return 'Este usuario foi desabilitado.';
      case 'user-not-found':
        return 'Usuario nao encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Este e-mail ja esta em uso.';
      case 'operation-not-allowed':
        return 'Operacao nao permitida.';
      case 'weak-password':
        return 'Senha muito fraca.';
      default:
        return 'Ocorreu um erro inesperado.';
    }
  }
}
