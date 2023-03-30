import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/commercial/bon_livraison.dart'; 

class BonLivraisonStore {
  static final BonLivraisonStore _singleton = BonLivraisonStore._internal();
  factory BonLivraisonStore() {
    return _singleton;
  }
  BonLivraisonStore._internal();

  static const String tableName = 'bon_livraisons';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<BonLivraisonModel>> getAllData() async {
    var data = await store.find(await _db);
    List<BonLivraisonModel> dataList = [];
    for (var snapshot in data) {
      final BonLivraisonModel dataItem =
          BonLivraisonModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<BonLivraisonModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late BonLivraisonModel dataItem = BonLivraisonModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(BonLivraisonModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(BonLivraisonModel entity) async {
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
