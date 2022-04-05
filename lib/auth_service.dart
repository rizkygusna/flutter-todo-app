import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  //constructor
  AuthService(this._firebaseAuth);

  // check if user signed in or not, returns user or null
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // SIGN IN METHOD
  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  //SIGN UP METHOD
  Future<String> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  //SIGN OUT METHOD
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
