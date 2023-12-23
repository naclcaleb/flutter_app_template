import 'dart:async';
import 'dart:developer';

enum LoadableState {
  notStarted,
  loading,
  error,
  data,
  done //Optional, usually for marking the end of a paginated list of loads
}

class LoadableUpdate<ValueType> {
  final LoadableState state;
  final String? error;
  final ValueType? data;

  LoadableUpdate(this.state, {this.error, this.data});
}

class Loadable<ValueType> {

  Future<ValueType?> Function()? _currentFuture;

  ValueType? _value;
  ValueType? get value => _value;
  set value(ValueType? newValue) {
    _value = newValue;
    if (newValue != null) {
      _streamController.add(LoadableUpdate<ValueType>(LoadableState.data, data: _value));
    }
  }

  Future<void> reload() async {
    if (_currentFuture != null) await loadWithFuture(_currentFuture!);
  }

  Future<ValueType?> loadWithFuture(Future<ValueType?> Function() future) async {

    _currentFuture = future;

    //Start loading
    _streamController.add(LoadableUpdate<ValueType>(LoadableState.loading));

    //Load the data
    _value = await future().catchError((error) {
      _streamController.add(LoadableUpdate<ValueType>(LoadableState.error, error: error.toString()));
      throw error;
    });

    //Update the stream
    if (_value != null) _streamController.add(LoadableUpdate<ValueType>(LoadableState.data, data: _value));

    return _value;
  }

  Future<ValueType?> silentlyLoadWithFuture(Future<ValueType?> Function() future) async {
    _currentFuture = future;

    //Load the data
    _value = await future().catchError((error) {
      _streamController.add(LoadableUpdate<ValueType>(LoadableState.error, error: error.toString()));
      throw error;
    });

    //Update the stream
    if (_value != null) _streamController.add(LoadableUpdate<ValueType>(LoadableState.data, data: _value));

    return _value;
  }

  final StreamController<LoadableUpdate<ValueType>> _streamController = StreamController<LoadableUpdate<ValueType>>.broadcast();
  Stream<LoadableUpdate<ValueType>> get stream => _streamController.stream;
  
  void dispose() {
    _streamController.close();
  }

  StreamSubscription<LoadableUpdate<ValueType>> listenToStream(void Function(LoadableUpdate<ValueType> update) onData) {
    return _streamController.stream.listen(onData);
  }

}