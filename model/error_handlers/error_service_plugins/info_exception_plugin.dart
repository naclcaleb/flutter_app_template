import 'model/error_handlers/info_exception.dart';
import 'model/services/error_service.dart';

bool infoExceptionPlugin(ErrorService errorService, Exception error) {
  if (error is! InfoException) return true;

  errorService.showSnack(error.message);
  return false;
}