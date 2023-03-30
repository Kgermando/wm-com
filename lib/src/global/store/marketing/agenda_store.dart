import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/marketing/agenda_model.dart';

class AgendaStore {
  static final AgendaStore _singleton = AgendaStore._internal();
  factory AgendaStore() {
    return _singleton;
  }
  AgendaStore._internal();

  static const String tableName = 'agendas';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<AgendaModel>> getAllData() async {
    var data = await store.find(await _db);
    List<AgendaModel> dataList = [];
    for (var snapshot in data) {
      final AgendaModel dataItem = AgendaModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<AgendaModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late AgendaModel dataItem = AgendaModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(AgendaModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(AgendaModel entity) async {
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
}
