import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_error_handler.dart';
import '../../services/error_service.dart';

bool firebaseAuthErrorPlugin(ErrorService errorService, Exception error) {
  if (error is! FirebaseAuthException) return true;
  final firebaseError = error as FirebaseAuthException;
  if (firebaseError.code == 'invalid-token') return false;
  final errorMessage = FirebaseErrorHandler.getErrorMessage(error);
  errorService.showSnack(errorMessage);
  return false;
}