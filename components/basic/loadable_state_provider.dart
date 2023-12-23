import 'dart:async';

import 'package:flutter/material.dart';
import '../../model/loadable.dart';

class LoadableStateProvider<ValueType> extends StatefulWidget {

  final Loadable<ValueType> loadable;
  final void Function()? onCompleteCallback;
  final Widget Function(LoadableState state, String? error) builder;

  const LoadableStateProvider(this.loadable, {super.key, this.onCompleteCallback, required this.builder});

  @override
  State<LoadableStateProvider<ValueType>> createState() => _LoadableStateProviderState<ValueType>();
}

class _LoadableStateProviderState<ValueType> extends State<LoadableStateProvider<ValueType>> {

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
          widget.onCompleteCallback?.call();
          setState(() {});
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_currentState, errorMessage);
  }

  @override
  void dispose() {
    super.dispose();

    _subscription?.cancel();
  }
}