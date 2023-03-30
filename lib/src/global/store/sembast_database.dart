import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:path/path.dart';
import 'package:wm_com/src/utils/info_system.dart';

class SembastDataBase {
  static String databaseName = "${InfoSystem().business()}.db";
  static final SembastDataBase _singleton = SembastDataBase._();

  static SembastDataBase get instance => _singleton;
  Completer<Database>? _dbOpenCompleter;
  SembastDataBase._();

  Future<Database> get database async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      initDatabase();
    }
    return _dbOpenCompleter!.future;
  }

  Future _initWebDatabase() async {
    var factory = databaseFactoryWeb;
    // Open the database
    final database = await factory.openDatabase(databaseName);
    _dbOpenCompleter!.complete(database);
    // Close the database
    // await database.close();
  }

  Future _initNativeDatabase() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    String dbPath = join(dir.path, databaseName);

    final database = await databaseFactoryIo.openDatabase(dbPath);
    _dbOpenCompleter!.complete(database);
    // Close the database
    // await database.close();
  }

  initDatabase() async {
    if (kIsWeb) {
      await _initWebDatabase();
    } else {
      await _initNativeDatabase();
    }
  }

  Future<Database> getDatabase() {
    return database;
  }
}
