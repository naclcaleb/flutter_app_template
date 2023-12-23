import 'dart:async';
import 'dart:core';
import 'dart:developer';

import 'loadable.dart';

class PaginatedLoadable<ValueType> {

  final int pageSize;
  bool _continueLoadingPages = true;
  int currentPage = 0;
  Future<List<ValueType>> Function(int page)? _future;

  LoadableUpdate<List<ValueType>> _latestUpdate = LoadableUpdate(LoadableState.notStarted);

  bool isLoadingPage = false;

  PaginatedLoadable({required this.pageSize});

  final List<ValueType> _values = [];
  List<ValueType> get values => _values;

  void reset() {
    _values.clear();
    _continueLoadingPages = true;
    currentPage = 0;
    sendUpdate(LoadableUpdate(LoadableState.notStarted));
  }

  void sendUpdate(LoadableUpdate<List<ValueType>> update) {
    _streamController.add(update);
    _latestUpdate = update;
  }

  LoadableUpdate<List<ValueType>> latestUpdate() { return _latestUpdate; }

  int getItemCount() {
    return _values.length;
  }

  ValueType? getItem(int index) {
    if (index >= _values.length) {
      if (_continueLoadingPages) {
        requestLoadNewPage();
      }
      return null;
    }
    return _values[index];
  }

  void setLoader(Future<List<ValueType>> Function(int page) future) {
    _future = future;
  }

  void setLoaderIfEmpty(Future<List<ValueType>> Function(int page) future) {
    if (_future == null) _future = future;
  }

  void addFirstPage(List<ValueType> items) {
    //Add the items to our values array
    _values.addAll(items);

    //Update the current page
    currentPage = (_values.length / pageSize).floor();

    //No more loading pages if this was less than the pageSize
    if (items.length != pageSize) {
      _continueLoadingPages = false;
      sendUpdate(LoadableUpdate(LoadableState.done, data: _values));
    } else {
      sendUpdate(LoadableUpdate(LoadableState.data, data: _values));
    }
    
  }

  void requestLoadNewPage() {
    if (isLoadingPage) return;
    if (!_continueLoadingPages) return;
    if (_future == null) throw UnimplementedError('PaginatedLoadable has not been set up with a loader function. Please call `setLoader()` before attempting to retrieve items.');

    loadPageWithFuture(_future!);
  }

  void deleteItem(ValueType item) {
    _values.remove(item);
    if (_values.isEmpty) sendUpdate(LoadableUpdate(LoadableState.done));
    else sendUpdate(LoadableUpdate(LoadableState.data));
  }

  void notifyUpdate() {
    sendUpdate(LoadableUpdate(LoadableState.data));
  }

  void reopen() {
    _continueLoadingPages = true;
    if (_latestUpdate.state == LoadableState.done) {
      sendUpdate(LoadableUpdate(LoadableState.loading));
    }
  }

  Future<List<ValueType>> loadPageWithFuture(Future<List<ValueType>> Function(int page) future) async {
    if (!_continueLoadingPages) return _values;

    //Start loading
    isLoadingPage = true;
    sendUpdate(LoadableUpdate<List<ValueType>>(LoadableState.loading));

    //Load the data
    List<ValueType> newValues = await future(currentPage).catchError((error) {
      _continueLoadingPages = false;
      sendUpdate(LoadableUpdate<List<ValueType>>(LoadableState.error, error: error.toString()));
      throw error;
    }).whenComplete(() => isLoadingPage = false);

    //Update the stream
    if (_values.length < (currentPage + 1) * pageSize) {
      _values.removeRange(currentPage * pageSize, _values.length);
    }
    if (newValues.length == pageSize) {
      currentPage++;
      _values.addAll(newValues);
      sendUpdate(LoadableUpdate<List<ValueType>>(LoadableState.data, data: _values));
    } else {
      _continueLoadingPages = false;
      _values.addAll(newValues);
      sendUpdate(LoadableUpdate<List<ValueType>>(LoadableState.done, data: _values));
    }

    return _values;
  }

  final StreamController<LoadableUpdate<List<ValueType>>> _streamController = StreamController<LoadableUpdate<List<ValueType>>>.broadcast();
  Stream<LoadableUpdate<List<ValueType>>> get stream => _streamController.stream;
  
  void dispose() {
    _streamController.close();
  }

  StreamSubscription<LoadableUpdate<List<ValueType>>> listenToStream(void Function(LoadableUpdate<List<ValueType>> update) onData) {
    return _streamController.stream.listen(onData);
  }

}