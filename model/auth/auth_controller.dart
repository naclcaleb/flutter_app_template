import 'package:firebase_auth/firebase_auth.dart';
import '../api/requests.dart';
import '../api/server.dart';

class AuthController {

  final FirebaseAuth _auth;
  
  bool isBlockingNavigation = false;

  AuthController(this._auth);

  final List<Function(bool isLoggedIn)> _listeners = [];

  void listenForAuthStateChanges(Function(bool isLoggedIn) listener) {
    _listeners.add(listener);
    _auth.authStateChanges().listen((User? user) {
      if (isBlockingNavigation) return;
      if (user == null) {
        listener(false);
      } else {
        listener(true);
      }
    });
  }

  void beginBlockingAuthListeners() {
    isBlockingNavigation = true;
  }
  void reactivateAuthListeners() {
    isBlockingNavigation = false;
  }
  void notifyListenersOfAuthorization() {
    for (final listener in _listeners) {
      listener(true);
    }
  }

  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> getSessionToken() async {
    if (_auth.currentUser == null) {
      throw Exception('User is not logged in');
    }
    return await _auth.currentUser!.getIdToken() ?? '';
  }

  getCurrentUserId() {
    if (_auth.currentUser == null) throw Exception('User is not logged in');
    return _auth.currentUser!.uid;
  }

}