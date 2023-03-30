import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/commercial/achat_model.dart';

class StockStore {
  static final StockStore _singleton = StockStore._internal();
  factory StockStore() {
    return _singleton;
  }
  StockStore._internal();

  static const String tableName = 'stocks';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<AchatModel>> getAllData() async {
    var data = await store.find(await _db);
    List<AchatModel> dataList = [];
    for (var snapshot in data) {
      final AchatModel dataItem = AchatModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<AchatModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late AchatModel dataItem = AchatModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(AchatModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(AchatModel entity) async {
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
