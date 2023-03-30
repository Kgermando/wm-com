import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/models/reservation/paiement_reservation_model.dart';

class PaiementReservationStore {
  static final PaiementReservationStore _singleton =
      PaiementReservationStore._internal();
  factory PaiementReservationStore() {
    return _singleton;
  }
  PaiementReservationStore._internal();

  static const String tableName = 'paiement-reservations';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  /// Get the favorites available in the device
  Future<List<PaiementReservationModel>> getAllData() async {
    var data = await store.find(await _db);
    List<PaiementReservationModel> dataList = [];
    for (var snapshot in data) {
      final PaiementReservationModel dataItem =
          PaiementReservationModel.fromJson(snapshot.value);
      dataList.add(dataItem);
    }
    return dataList;
  }

  Future<PaiementReservationModel> getOneData(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late PaiementReservationModel dataItem =
        PaiementReservationModel.fromJson(data!.value);
    return dataItem;
  }

  Future<int> insertData(PaiementReservationModel dataItem) async {
    var dataList = await getAllData();
    int key =
        await store.add(await _db, dataItem.toJson(id: dataList.length + 1));
    return key;
  }

  Future<int> updateData(PaiementReservationModel entity) async {
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
