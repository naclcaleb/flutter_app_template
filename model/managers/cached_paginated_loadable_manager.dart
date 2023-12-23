import '../paginated_loadable.dart';

class CachedPaginatedLoadableManager {

  final Map<String, PaginatedLoadable> _cachedPaginatedLoadables = {};

  PaginatedLoadable<ValueType> loadPaginatedLoadable<ValueType>(String key) {
    if (_cachedPaginatedLoadables.containsKey(key)) {
      try {
        return _cachedPaginatedLoadables[key] as PaginatedLoadable<ValueType>;
      } catch(error) {
        throw const FormatException('This loadable is not of the requested type');
      }
    } else {
      final loadable = PaginatedLoadable<ValueType>(pageSize: 10);
      _cachedPaginatedLoadables[key] = loadable;
      return loadable;
    }
  }

  void invalidatePaginatedLoadable(String key) {
    if (_cachedPaginatedLoadables.containsKey(key)) {
      _cachedPaginatedLoadables[key]?.reset();
    }
  }

}