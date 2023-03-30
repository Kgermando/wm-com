import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/commercial/succursale_model.dart'; 

class SuccursaleStore {
  static final SuccursaleStore _singleton = SuccursaleStore._internal();
  factory SuccursaleStore() {
    return _singleton;
  }
  SuccursaleStore._internal();

  static const String tableName = 'succursales';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<SuccursaleModel>> getAllData() async {
    var data = await store.find(await _db);
    List<SuccursaleModel> dataList = [];
    for (var snapshot in data) {
      final SuccursaleModel dataItem = SuccursaleModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<SuccursaleModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late SuccursaleModel dataItem = SuccursaleModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(SuccursaleModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(SuccursaleModel entity) async {
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
