import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../../model/loadable.dart';
import '../../model/paginated_loadable.dart';

class PaginatedLoadableProvider<ValueType> extends StatefulWidget {

  final PaginatedLoadable<ValueType> loadable;
  final Widget Function()? empty;
  final Widget Function(String error) error;
  final Widget Function(ValueType? Function(int index) getItem, bool done) data;

  const PaginatedLoadableProvider(this.loadable, {super.key, this.empty, required this.error, required this.data});

  @override
  State<PaginatedLoadableProvider<ValueType>> createState() => _PaginatedLoadableProviderState<ValueType>();
}

class _PaginatedLoadableProviderState<ValueType> extends State<PaginatedLoadableProvider<ValueType>> {

  StreamSubscription<LoadableUpdate<List<ValueType>>>? _subscription;

  LoadableState _currentState = LoadableState.loading;
  String errorMessage = '';
  bool _done = false;

  @override
  void initState() {
    super.initState();

    if (_subscription != null) _subscription?.cancel();
    _subscription = widget.loadable.listenToStream(consumeUpdate);

    consumeUpdate( widget.loadable.latestUpdate() ); //Get any initial state
  
  }

  void consumeUpdate(LoadableUpdate<List<ValueType>> update) {
    _currentState = update.state;
      switch(update.state) {
        case LoadableState.notStarted:
          setState(() {
            _done = false;
          });
          break;
        case LoadableState.loading:
          setState(() {});
          break;
        case LoadableState.error:
          setState(() {
            errorMessage = update.error!;
          });
          break;
        case LoadableState.data:
          setState(() {});
          break;
        case LoadableState.done:
          setState(() {
            _done = true;
          });
          break;
      }
  }

  @override
  Widget build(BuildContext context) {

    switch(_currentState) {
      case LoadableState.error:
        return widget.error(errorMessage);
      case LoadableState.done:
        if (widget.loadable.values == null) return widget.error('An unknown error occurred');
        if (widget.loadable.values!.isEmpty && widget.empty != null) return widget.empty!();
        return widget.data(widget.loadable.getItem, _done);
      default:
        if (widget.loadable.values == null) return widget.error('An unknown error occurred');
        return widget.data(widget.loadable.getItem, _done);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _subscription?.cancel();
  }
}