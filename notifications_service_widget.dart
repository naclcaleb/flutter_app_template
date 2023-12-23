import 'dart:async';

import 'package:flutter/material.dart';
import 'model/services/notification_service.dart';
import 'service_locator.dart';

class NotificationsServiceWidget extends StatefulWidget {

  final Widget child;

  const NotificationsServiceWidget({super.key, required this.child});

  @override
  State<NotificationsServiceWidget> createState() => _NotificationsServiceWidgetState();
}

class _NotificationsServiceWidgetState extends State<NotificationsServiceWidget> {

  final NotificationService _notificationService = sl();
  StreamSubscription<String>? _snackSubscription;

  SnackBar _buildSnackbar(BuildContext context, String message) {
    return SnackBar(
      content: Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.background)),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  @override
  void initState() {
    super.initState();

    if (_snackSubscription != null) _snackSubscription?.cancel();
    _snackSubscription = _notificationService.subscribeToSnackStream((value) { 
      ScaffoldMessenger.of(context).showSnackBar( _buildSnackbar(context, value) );
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    super.dispose();
    _snackSubscription?.cancel();
  }
}