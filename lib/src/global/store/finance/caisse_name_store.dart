import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/finance/caisse_name_model.dart';

class CaisseNameStore {
  static final CaisseNameStore _singleton = CaisseNameStore._internal();
  factory CaisseNameStore() {
    return _singleton;
  }
  CaisseNameStore._internal();

  static const String tableName = 'caisses-name';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<CaisseNameModel>> getAllData() async {
    var data = await store.find(await _db);
    List<CaisseNameModel> dataList = [];
    for (var snapshot in data) {
      final CaisseNameModel dataItem = CaisseNameModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<CaisseNameModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late CaisseNameModel dataItem = CaisseNameModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(CaisseNameModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(CaisseNameModel entity) async {
    final finder = Finder(filter: Filter.equals('id', entity.id));
    var key = await store.update(await _db, entity.toJson(id: entity.id),
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
