import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/commercial/creance_cart_model.dart';

class FactureCreanceStore {
  static final FactureCreanceStore _singleton = FactureCreanceStore._internal();
  factory FactureCreanceStore() {
    return _singleton;
  }
  FactureCreanceStore._internal();

  static const String tableName = 'creances';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<CreanceCartModel>> getAllData() async {
    var data = await store.find(await _db);
    List<CreanceCartModel> dataList = [];
    for (var snapshot in data) {
      final CreanceCartModel dataItem =
          CreanceCartModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<CreanceCartModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late CreanceCartModel dataItem = CreanceCartModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(CreanceCartModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(CreanceCartModel entity) async {
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
