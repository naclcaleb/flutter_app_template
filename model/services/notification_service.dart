import 'dart:async';

class NotificationService {

  final StreamController<String> _snackStreamController = StreamController<String>.broadcast();

  StreamSubscription<String> subscribeToSnackStream(void Function(String value) listener) {
    return _snackStreamController.stream.listen(listener);
  }

  void showSnack(String message) {
    _snackStreamController.add(message);
  }

}