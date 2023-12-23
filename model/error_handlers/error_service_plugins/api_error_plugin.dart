import 'dart:developer';

import '../../error_handlers/network_error_handler.dart';
import '../../services/error_service.dart';

bool apiErrorPlugin(ErrorService errorService, Exception error) {
  
  if (error is! NetworkException) return true;

  log(error.statusCode.toString());

  errorService.showSnack(error.message);
  return false;
}