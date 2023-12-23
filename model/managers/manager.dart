abstract class Manageable<T extends Manageable<T>> {
  String get id;
  void update(T newVersion);
}

class Manager<Item extends Manageable<Item>> {
  final Map<String, Item> _itemCache = {};

  Future<Item> get(String id, { bool? forceRefresh }) async {
    if ((forceRefresh == null || forceRefresh == false) && _itemCache.containsKey(id)) {
      return _itemCache[id]!;
    } else {
      Item item = await fetchItem(id);
      save(item);
      return item;
    }
  }

  Item save(Item item) {
    if (_itemCache.containsKey(item.id)){ _itemCache[item.id]!.update(item); }
    else { _itemCache[item.id] = item; }
    return _itemCache[item.id]!;
  }

  List<Item> saveAll(List<Item> items) {
    List<Item> _returnedItems = [];
    for (var item in items) {
      _returnedItems.add( save(item) );
    }
    return _returnedItems;
  }

  Future<Item> fetchItem(String id) async { throw UnimplementedError(); }
}