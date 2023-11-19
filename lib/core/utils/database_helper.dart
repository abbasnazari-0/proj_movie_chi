import 'dart:io' as io;

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DictionaryDataBaseHelper {
  Database? _db;

  void _onCreate(Database db, int version) async {
    // ایجاد جداول در دیتابیس
    await db.execute('''
      CREATE TABLE tbl_bookmark(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tag TEXT,
        video_detail TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tbl_downloaded(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        video TEXT,
        tag TEXT,
        download_status TEXT,
        download_path TEXT,
        isDownloading TEXT,
        task_id TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tbl_favorite(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tag TEXT,
        video_detail TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tbl_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tag TEXT,
        video_detail TEXT,
        data TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tbl_notif(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tag TEXT,
        status INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE tbl_news_notif(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        desc TEXT,
        action TEXT,
        action_content TEXT,
        tag TEXT,
        readed INTEGER 
      )
    ''');
  }

  Future<void> init() async {
    io.Directory applicationDirectory =
        await getApplicationDocumentsDirectory();

    String dbPath = path.join(applicationDirectory.path, "local-v1.db");

    bool dbExists = await io.File(dbPath).exists();

    if (!dbExists) {
      // // Copy from asset
      // ByteData data = await rootBundle.load(path.join("assets", "local.db"));
      // List<int> bytes =
      //     data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // // Write and flush the bytes written
      // await io.File(dbPath).writeAsBytes(bytes, flush: true);

      // open the database
      _db = await openDatabase(dbPath, version: 1, onCreate: _onCreate);
    }

    _db = await openDatabase(dbPath);
  }

  /// get all the words from english dictionary
  Future<List> getQuery(String tblName,
      {String? where = '', String? whereValue, String? orderBy}) async {
    if (_db == null) {
      await init();
      //throw ("db is not initiated, initiate using [init(db)] function");
    }
    if (where?.isNotEmpty ?? false) {
      return await _db!.rawQuery(
        "SELECT * FROM $tblName WHERE $where = '$whereValue' ORDER BY $orderBy",
      );
    } else {
      return await _db!.rawQuery(
        'SELECT * FROM $tblName ORDER BY id DESC',
      );
    }
  }

  Future<List> query(String sql) async {
    if (_db == null) {
      await init();
      //throw ("db is not initiated, initiate using [init(db)] function");
    }
    return await _db!.rawQuery(sql);
  }

  /// get all the words from english dictionary
  Future<List> getDoubleQuery(
    String tblName, {
    String where = '',
    required String whereValue,
    String where2 = '',
    required String whereValue2,
    String? orderBy,
  }) async {
    if (_db == null) {
      throw "db is not initiated, initiate using [init(db)] function";
    }
    if (where.isNotEmpty) {
      return await _db!.rawQuery(
        "SELECT * FROM $tblName WHERE `$where` = '$whereValue' AND `$where2` = '$whereValue2' ${orderBy != null ? "ORDER BY $orderBy" : ""} ",
      );
    } else {
      return await _db!.rawQuery(
        'SELECT * FROM $tblName ORDER BY id DESC',
      );
    }
  }

  Future<int> addQuery(
      String columns, String columnsValue, String table) async {
    if (_db == null) {
      throw "db is not initiated, initiate using [init(db)] function";
    }
    return await _db!
        .rawUpdate("INSERT INTO $table ($columns) VALUES ($columnsValue) ");
  }

  Future<int> updateQuery(String sql) async {
    if (_db == null) {
      throw "db is not initiated, initiate using [init(db)] function";
    }
    return await _db!.rawUpdate(sql);
  }
}
