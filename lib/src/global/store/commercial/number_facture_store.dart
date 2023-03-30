import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/commercial/number_facture.dart';

class NumberFactureStore {
  static final NumberFactureStore _singleton = NumberFactureStore._internal();
  factory NumberFactureStore() {
    return _singleton;
  }
  NumberFactureStore._internal();

  static const String tableName = 'number-factures';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<NumberFactureModel>> getAllData() async {
    var data = await store.find(await _db);
    List<NumberFactureModel> dataList = [];
    for (var snapshot in data) {
      final NumberFactureModel dataItem =
          NumberFactureModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<NumberFactureModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late NumberFactureModel dataItem = NumberFactureModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(NumberFactureModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(NumberFactureModel entity) async {
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
