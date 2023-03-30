import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/users/user_model.dart';

class UsersStore {
  static final UsersStore _singleton = UsersStore._internal();
  factory UsersStore() {
    return _singleton;
  }
  UsersStore._internal();

  static const String tableName = 'users';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<UserModel>> getAllData() async {
    var data = await store.find(await _db);
    List<UserModel> dataList = [];
    for (var snapshot in data) {
      final UserModel dataItem = UserModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<UserModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late UserModel dataItem = UserModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(UserModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(UserModel entity) async {
    final finder = Finder(filter: Filter.equals('id', entity.id));
    var key = await store.update(await _db, entity.toJson(id: entity.id!),
        finder: finder);
    return key;
  }

  deleteData(int id) async {
    await store.delete(await _db,
        finder: Finder(filter: Filter.equals('id', id)));
  }

  // deleteAllData() async {
  //   await store.delete(await _db);
  // }
}
