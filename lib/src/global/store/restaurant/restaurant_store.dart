import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/restaurant/restaurant_model.dart';

class RestaurantStore {
  static final RestaurantStore _singleton = RestaurantStore._internal();
  factory RestaurantStore() {
    return _singleton;
  }
  RestaurantStore._internal();

  static const String tableName = 'restaurants';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<RestaurantModel>> getAllData() async {
    var data = await store.find(await _db);
    List<RestaurantModel> dataList = [];
    for (var snapshot in data) {
      final RestaurantModel dataItem = RestaurantModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<RestaurantModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late RestaurantModel dataItem = RestaurantModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(RestaurantModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(RestaurantModel entity) async {
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

  Future<int> getCountCommande() async {
    var dataList = await getAllData();
    int count = dataList.where((e) => e.statutCommande == 'false').length;
    return count;
  }

  Future<int> getCountConsommation() async {
    var dataList = await getAllData();
    int count = dataList.where((e) => e.statutCommande == 'true').length;
    return count;
  }
}
