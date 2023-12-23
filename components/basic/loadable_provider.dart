import 'dart:async';

import 'package:flutter/material.dart';
import '../../model/loadable.dart';

class LoadableProvider<ValueType> extends StatefulWidget {

  final Loadable<ValueType> loadable;
  final Widget Function()? notStarted;
  final Widget Function() loading;
  final Widget Function(String error) error;
  final Widget Function(ValueType data) data;

  const LoadableProvider(this.loadable, {super.key, this.notStarted, required this.loading, required this.error, required this.data});

  @override
  State<LoadableProvider<ValueType>> createState() => _LoadableProviderState<ValueType>();
}

class _LoadableProviderState<ValueType> extends State<LoadableProvider<ValueType>> {

  StreamSubscription<LoadableUpdate<ValueType>>? _subscription;

  LoadableState _currentState = LoadableState.notStarted;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();

    if (_subscription != null) _subscription?.cancel();
    _subscription = widget.loadable.listenToStream((update) {
      _currentState = update.state;
      switch(update.state) {
        case LoadableState.notStarted:
          setState(() {});
          break;
        case LoadableState.loading:
          setState(() {});
          break;
        case LoadableState.error:
          setState(() {
            errorMessage = update.error!;
          });
          break;
        default:
          setState(() {});
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(_currentState) {
      case LoadableState.notStarted:
        if (widget.notStarted != null) return widget.notStarted!();
        return widget.loading();
      case LoadableState.loading:
        return widget.loading();
      case LoadableState.error:
        return widget.error(errorMessage);
      case LoadableState.data:
        if (widget.loadable.value == null) return widget.error('An unknown error occurred');
        return widget.data(widget.loadable.value!);
      case LoadableState.done:
        if (widget.loadable.value == null) return widget.error('An unknown error occurred');
        return widget.data(widget.loadable.value!);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _subscription?.cancel();
  }
}