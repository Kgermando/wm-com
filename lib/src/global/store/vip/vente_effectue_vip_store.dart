import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/restaurant/vente_restaurant_model.dart';

class VenteEffectueVipStore {
  static final VenteEffectueVipStore _singleton =
      VenteEffectueVipStore._internal();
  factory VenteEffectueVipStore() {
    return _singleton;
  }
  VenteEffectueVipStore._internal();

  static const String tableName = 'vente-effectue-vip';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<VenteRestaurantModel>> getAllData() async {
    var data = await store.find(await _db);
    List<VenteRestaurantModel> dataList = [];
    for (var snapshot in data) {
      final VenteRestaurantModel dataItem =
          VenteRestaurantModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<VenteRestaurantModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late VenteRestaurantModel dataItem =
        VenteRestaurantModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(VenteRestaurantModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(VenteRestaurantModel entity) async {
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

  Future<int> getCount() async {
    var dataList = await getAllData();
    int count = dataList.length;
    return count;
  }
}
