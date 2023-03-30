import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/home/service_home_model.dart';

class ServiceHomeStore {
  static final ServiceHomeStore _singleton = ServiceHomeStore._internal();
  factory ServiceHomeStore() {
    return _singleton;
  }
  ServiceHomeStore._internal();

  static const String tableName = 'service-home';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<ServiceHomeModel>> getAllData() async {
    var data = await store.find(await _db);
    List<ServiceHomeModel> dataList = [];
    for (var snapshot in data) {
      final ServiceHomeModel dataItem =
          ServiceHomeModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<ServiceHomeModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late ServiceHomeModel dataItem = ServiceHomeModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(ServiceHomeModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(ServiceHomeModel entity) async {
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
