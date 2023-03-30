import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/commercial/history_ravitaillement_model.dart';

class HistoryRavitaillementStore {
  static final HistoryRavitaillementStore _singleton =
      HistoryRavitaillementStore._internal();
  factory HistoryRavitaillementStore() {
    return _singleton;
  }
  HistoryRavitaillementStore._internal();

  static const String tableName = 'history-ravitaillements';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<HistoryRavitaillementModel>> getAllData() async {
    var data = await store.find(await _db);
    List<HistoryRavitaillementModel> dataList = [];
    for (var snapshot in data) {
      final HistoryRavitaillementModel dataItem =
          HistoryRavitaillementModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<HistoryRavitaillementModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late HistoryRavitaillementModel dataItem =
        HistoryRavitaillementModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(HistoryRavitaillementModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(HistoryRavitaillementModel entity) async {
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
