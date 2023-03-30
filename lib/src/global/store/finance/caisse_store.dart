import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/finance/caisse_model.dart';

class CaisseStore {
  static final CaisseStore _singleton = CaisseStore._internal();
  factory CaisseStore() {
    return _singleton;
  }
  CaisseStore._internal();

  static const String tableName = 'caisses';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<CaisseModel>> getAllData() async {
    var data = await store.find(await _db);
    List<CaisseModel> dataList = [];
    for (var snapshot in data) {
      final CaisseModel dataItem = CaisseModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<CaisseModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late CaisseModel dataItem = CaisseModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(CaisseModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(CaisseModel entity) async {
    final finder = Finder(filter: Filter.equals('id', entity.id));
    var key = await store.update(await _db, entity.toJson(id: entity.id!),
        finder: finder);
    return key;
  }

  deleteData(int id) async {
    await store.delete(await _db,
        finder: Finder(filter: Filter.equals('id', id)));
  }

  deleteDataAll() async {
    await store.delete(await _db);
  }
}
