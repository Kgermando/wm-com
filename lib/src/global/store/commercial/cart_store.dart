import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/commercial/cart_model.dart';

class CartStore {
  static final CartStore _singleton = CartStore._internal();
  factory CartStore() {
    return _singleton;
  }
  CartStore._internal();

  static const String tableName = 'carts';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<CartModel>> getAllData() async {
    var data = await store.find(await _db);
    List<CartModel> dataList = [];
    for (var snapshot in data) {
      final CartModel dataItem = CartModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<CartModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late CartModel dataItem = CartModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(CartModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(CartModel entity) async {
    final finder = Finder(filter: Filter.equals('id', entity.id));
    var key = await store.update(await _db, entity.toJson(id: entity.id!),
        finder: finder);
    return key;
  }

  deleteData(int id) async {
    await store.delete(await _db,
        finder: Finder(filter: Filter.equals('id', id)));
  }

  Future<int> getCount(String matricule) async {
    var dataList = await getAllData();
    int count =
        dataList.where((element) => element.signature == matricule).length;
    return count;
  }
 

  deleteAllData() async {
    await store.delete(await _db);
  }
}
