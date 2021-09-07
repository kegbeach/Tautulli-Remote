import 'dart:io';

import 'package:app_group_directory/app_group_directory.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../error/new_exception.dart';
import '../models/new_server_model.dart';

class DBProvider {
  // Create a singleton
  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database? _database;

  Future<Database?> get database async {
    // Avoid possible race condition where openDatabase is called twice
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  Future initDB() async {
    Directory? documentsDir = Platform.isIOS
        ? await AppGroupDirectory.getAppGroupDirectory(
            'group.com.tautulli.tautulliRemote.onesignal',
          )
        : await getApplicationDocumentsDirectory();

    // If documentsDir ends up null throw DatabaseInitException.
    if (documentsDir == null) {
      throw DatabaseInitException();
    }

    String path = join(documentsDir.path, 'tautulli_remote.db');

    return await openDatabase(
      path,
      version: 6,
      onOpen: (db) async {},
      onCreate: (Database db, int version) async {
        var batch = db.batch();
        _createTableServerV6(batch);
        await batch.commit();
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        var batch = db.batch();
        if (oldVersion == 1) {
          _updateTableServerV1toV6(batch);
          await _addInitialIndexValue(db, batch);
        }
        if (oldVersion == 2) {
          _updateTableServerV2toV6(batch);
          await _addInitialIndexValue(db, batch);
        }
        if (oldVersion == 3) {
          _updateTableServerV3toV6(batch);
          await _addInitialIndexValue(db, batch);
        }
        if (oldVersion == 4) {
          _updateTableServerV4toV6(batch);
          await _addInitialIndexValue(db, batch);
        }
        if (oldVersion == 5) {
          _updateTableServerV5toV6(batch);
          await _addInitialIndexValue(db, batch);
        }
        await batch.commit();
      },
    );
  }

  void _createTableServerV6(Batch batch) {
    batch.execute('''CREATE TABLE servers(
                    id INTEGER PRIMARY KEY,
                    sort_index INTEGER,
                    plex_name TEXT,
                    plex_identifier TEXT,
                    tautulli_id TEXT,
                    primary_connection_address TEXT,
                    primary_connection_protocol TEXT,
                    primary_connection_domain TEXT,
                    primary_connection_path TEXT,
                    secondary_connection_address TEXT,
                    secondary_connection_protocol TEXT,
                    secondary_connection_domain TEXT,
                    secondary_connection_path TEXT,
                    device_token TEXT,
                    primary_active INTEGER,
                    onesignal_registered INTEGER,
                    plex_pass INTEGER,
                    date_format TEXT,
                    time_format TEXT
                  )''');
  }

  void _updateTableServerV1toV6(Batch batch) {
    batch.execute('ALTER TABLE servers ADD plex_pass INTEGER');
    batch.execute('ALTER TABLE servers ADD date_format TEXT');
    batch.execute('ALTER TABLE servers ADD time_format TEXT');
    batch.execute('ALTER TABLE servers ADD plex_identifier TEXT');
    batch.execute('ALTER TABLE servers ADD sort_index INTEGER');
    batch.execute('ALTER TABLE servers ADD onesignal_registered INTEGER');
  }

  void _updateTableServerV2toV6(Batch batch) {
    batch.execute('ALTER TABLE servers ADD date_format TEXT');
    batch.execute('ALTER TABLE servers ADD time_format TEXT');
    batch.execute('ALTER TABLE servers ADD plex_identifier TEXT');
    batch.execute('ALTER TABLE servers ADD sort_index INTEGER');
    batch.execute('ALTER TABLE servers ADD onesignal_registered INTEGER');
  }

  void _updateTableServerV3toV6(Batch batch) {
    batch.execute('ALTER TABLE servers ADD plex_identifier TEXT');
    batch.execute('ALTER TABLE servers ADD sort_index INTEGER');
    batch.execute('ALTER TABLE servers ADD onesignal_registered INTEGER');
  }

  void _updateTableServerV4toV6(Batch batch) {
    batch.execute('ALTER TABLE servers ADD sort_index INTEGER');
    batch.execute('ALTER TABLE servers ADD onesignal_registered INTEGER');
  }

  void _updateTableServerV5toV6(Batch batch) {
    batch.execute('ALTER TABLE servers ADD onesignal_registered INTEGER');
  }

  // Adds an sort index value on databases prior to V6.
  Future<void> _addInitialIndexValue(Database db, Batch batch) async {
    var servers = await db.query('servers');
    for (var i = 0; i <= servers.length - 1; i++) {
      batch.update(
        'servers',
        {'sort_index': i},
        where: 'id = ?',
        whereArgs: [servers[i]['id']],
      );
    }
  }

  //* Database Interactions
  Future<NewServerModel> getServerByTautulliId(String tautulliId) async {
    final db = await database;
    var result = await db!.query(
      'servers',
      where: 'tautulli_id = ?',
      whereArgs: [tautulliId],
    );

    if (result.isEmpty) {
      throw ServerNotFoundException;
    }

    return NewServerModel.fromJson(result.first);
  }
}
