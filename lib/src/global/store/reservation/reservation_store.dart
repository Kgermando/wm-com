import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/reservation/reservation_model.dart';

class ReservationStore {
  static final ReservationStore _singleton = ReservationStore._internal();
  factory ReservationStore() {
    return _singleton;
  }
  ReservationStore._internal();

  static const String tableName = 'reservations';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<ReservationModel>> getAllData() async {
    var data = await store.find(await _db);
    List<ReservationModel> dataList = [];
    for (var snapshot in data) {
      final ReservationModel dataItem =
          ReservationModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    deleteDataAll();
    return dataList;
  }

  Future<ReservationModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late ReservationModel dataItem = ReservationModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(ReservationModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(ReservationModel entity) async {
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
