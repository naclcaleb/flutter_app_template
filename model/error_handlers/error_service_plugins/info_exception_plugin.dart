import '../info_exception.dart';
import '../../services/error_service.dart';

bool infoExceptionPlugin(ErrorService errorService, Exception error) {
  if (error is! InfoException) return true;

  errorService.showSnack(error.message);
  return false;
}