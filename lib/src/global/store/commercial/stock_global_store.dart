import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/commercial/stocks_global_model.dart';

class StockGlobalStore {
  static final StockGlobalStore _singleton = StockGlobalStore._internal();
  factory StockGlobalStore() {
    return _singleton;
  }
  StockGlobalStore._internal();

  static const String tableName = 'stock_globals';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<StocksGlobalMOdel>> getAllData() async {
    var data = await store.find(await _db);
    List<StocksGlobalMOdel> dataList = [];
    for (var snapshot in data) {
      final StocksGlobalMOdel dataItem = StocksGlobalMOdel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<StocksGlobalMOdel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late StocksGlobalMOdel dataItem = StocksGlobalMOdel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(StocksGlobalMOdel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(StocksGlobalMOdel entity) async {
    final finder = Finder(filter: Filter.equals('id', entity.id));
    var key = await store.update(await _db, entity.toJson(id: entity.id!),
        finder: finder);
    return key;
  }

  deleteData(int id) async {
    await store.delete(await _db,
        finder: Finder(filter: Filter.equals('id', id)));
  }

  Future<int> getCount() async {
    var dataList = await getAllData();
    int count = dataList.length;
    return count;
  }

  deleteAllData() async {
    await store.delete(await _db);
  }
}
