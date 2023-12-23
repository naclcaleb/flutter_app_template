import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

typedef ErrorServicePlugin = bool Function(ErrorService service, Exception error);

class ErrorService extends ChangeNotifier {

  final List<ErrorServicePlugin> _plugins = [];

  ErrorService();

  final StreamController<String> _snackStreamController = StreamController<String>.broadcast();

  StreamSubscription<String> subscribeToSnackStream(void Function(String value) listener) {
    return _snackStreamController.stream.listen(listener);
  }

  void receiveError(Exception error) {

    var shouldContinue = true;

    for (final plugin in _plugins) {
      shouldContinue = plugin(this, error);
      if (!shouldContinue) break;
    }

    if (shouldContinue) _defaultPlugin(error);

  }

  bool _defaultPlugin(Exception error) {
    //If all else fails, just throw
    throw error;
  }

  void registerPlugin(ErrorServicePlugin plugin) {
    _plugins.add(plugin);
  }

  void registerPlugins(List<ErrorServicePlugin> plugins) {
    _plugins.addAll(plugins);
  }

  void showSnack(String message) {
    _snackStreamController.add(message);
  }

}