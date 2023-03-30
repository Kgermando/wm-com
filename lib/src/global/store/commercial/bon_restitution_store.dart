import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/commercial/restitution_model.dart'; 

class BonRestitutionStore {
  static final BonRestitutionStore _singleton = BonRestitutionStore._internal();
  factory BonRestitutionStore() {
    return _singleton;
  }
  BonRestitutionStore._internal();

  static const String tableName = 'bon_livraisons';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<RestitutionModel>> getAllData() async {
    var data = await store.find(await _db);
    List<RestitutionModel> dataList = [];
    for (var snapshot in data) {
      final RestitutionModel dataItem =
          RestitutionModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<RestitutionModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late RestitutionModel dataItem = RestitutionModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(RestitutionModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(RestitutionModel entity) async {
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
