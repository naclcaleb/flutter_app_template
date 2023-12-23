import '../loadable.dart';

class CachedLoadableManager {

  final Map<String, Loadable> _cachedLoadables = {};

  Loadable<ValueType> loadLoadable<ValueType>(String key) {
    if (_cachedLoadables.containsKey(key)) {
      try {
        return _cachedLoadables[key] as Loadable<ValueType>;
      } catch(error) {
        throw const FormatException('This loadable is not of the requested type');
      }
    } else {
      final loadable = Loadable<ValueType>();
      _cachedLoadables[key] = loadable;
      return loadable;
    }
  }

  void invalidateLoadable(String key) {
    if (_cachedLoadables.containsKey(key)) {
      _cachedLoadables[key]?.reload();
    }
  }

}