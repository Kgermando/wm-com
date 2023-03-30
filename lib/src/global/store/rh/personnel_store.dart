import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/rh/agent_model.dart';

class PersonnelStore {
  static final PersonnelStore _singleton = PersonnelStore._internal();
  factory PersonnelStore() {
    return _singleton;
  }
  PersonnelStore._internal();

  static const String tableName = 'personnels';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<AgentModel>> getAllData() async {
    var data = await store.find(await _db);
    List<AgentModel> dataList = [];
    for (var snapshot in data) {
      final AgentModel dataItem = AgentModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<AgentModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late AgentModel dataItem = AgentModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(AgentModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(AgentModel entity) async {
    final finder = Finder(filter: Filter.equals('id', entity.id));
    var key = await store.update(await _db, entity.toJson(id: entity.id!),
        finder: finder);
    return key;
  }

  deleteData(int id) async {
    await store.delete(await _db,
        finder: Finder(filter: Filter.equals('id', id)));
  }
}
