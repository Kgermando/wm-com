import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/restaurant/facture_restaurant_model.dart';

class FactureRestaurantStore {
  static final FactureRestaurantStore _singleton =
      FactureRestaurantStore._internal();
  factory FactureRestaurantStore() {
    return _singleton;
  }
  FactureRestaurantStore._internal();

  static const String tableName = 'facture-restaurants';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<FactureRestaurantModel>> getAllData() async {
    var data = await store.find(await _db);
    List<FactureRestaurantModel> dataList = [];
    for (var snapshot in data) {
      final FactureRestaurantModel dataItem =
          FactureRestaurantModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<FactureRestaurantModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late FactureRestaurantModel dataItem =
        FactureRestaurantModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(FactureRestaurantModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(FactureRestaurantModel entity) async {
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
