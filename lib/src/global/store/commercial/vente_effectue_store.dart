import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/commercial/vente_cart_model.dart';

class VenteEffectueStore {
  static final VenteEffectueStore _singleton = VenteEffectueStore._internal();
  factory VenteEffectueStore() {
    return _singleton;
  }
  VenteEffectueStore._internal();

  static const String tableName = 'ventes-effectues';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<VenteCartModel>> getAllData() async {
    var data = await store.find(await _db);
    List<VenteCartModel> dataList = [];
    for (var snapshot in data) {
      final VenteCartModel dataItem = VenteCartModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<VenteCartModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late VenteCartModel dataItem = VenteCartModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(VenteCartModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(VenteCartModel entity) async {
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
