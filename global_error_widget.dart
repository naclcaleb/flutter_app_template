import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'service_locator.dart';

import 'model/services/error_service.dart';

class GlobalErrorWidget extends StatefulWidget {

  final Widget child;

  const GlobalErrorWidget({super.key, required this.child});

  @override
  State<GlobalErrorWidget> createState() => _GlobalErrorWidgetState();
}

class _GlobalErrorWidgetState extends State<GlobalErrorWidget> {

  final ErrorService _errorService = sl();
  StreamSubscription<String>? _snackSubscription;

  SnackBar _buildSnackbar(BuildContext context, String message) {
    return SnackBar(
      content: Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.background)),
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }

  @override
  void initState() {
    super.initState();

    _snackSubscription = _errorService.subscribeToSnackStream((message) {
      log(message);
      ScaffoldMessenger.of(context).showSnackBar( _buildSnackbar(context, message) );
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _snackSubscription?.cancel();
    super.dispose();
  }
}