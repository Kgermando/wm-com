import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/commercial/livraiason_history_model.dart'; 

class HistoryLivraisonStore {
  static final HistoryLivraisonStore _singleton =
      HistoryLivraisonStore._internal();
  factory HistoryLivraisonStore() {
    return _singleton;
  }
  HistoryLivraisonStore._internal();

  static const String tableName = 'history-livraisons';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<LivraisonHistoryModel>> getAllData() async {
    var data = await store.find(await _db);
    List<LivraisonHistoryModel> dataList = [];
    for (var snapshot in data) {
      final LivraisonHistoryModel dataItem =
          LivraisonHistoryModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<LivraisonHistoryModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late LivraisonHistoryModel dataItem =
        LivraisonHistoryModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(LivraisonHistoryModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(LivraisonHistoryModel entity) async {
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
