import 'package:firebase_auth/firebase_auth.dart';
import '../api/server.dart';
import '../auth/auth_controller.dart';
import '../services/error_service.dart';
import '../../service_locator.dart';

class AuthService {

  final ErrorService _errorService = sl();

  final FirebaseAuth _auth;
  final Server _server;
  final AuthController _authController = sl();

  AuthService(this._auth, this._server);

  String get currentUserId => _authController.getCurrentUserId();

  //Auth service functions go here
}