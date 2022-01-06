import 'package:restaurant_apps/data/model/favorite.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  static late DbHelper _dbHelper;
  static late Database _database;
  DbHelper._createObject();

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'favorite.db';
    var itemDatabase = openDatabase(path, version: 4, onCreate: _createDb);
    return itemDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE favorite (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      idfavorit TEXT,
      name TEXT,
      desc TEXT,
      urlimage TEXT,
      city TEXT,
      rating TEXT,
      address TEXT,
      isFav TEXT
    )
    ''');
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.initDb();
    var mapList = await db.query('favorite', orderBy: 'name');
    return mapList;
  }

  Future<int> insert(Favorite object) async {
    Database db = await this.initDb();
    int count = await db.insert('favorite', object.toMap());
    return count;
  }

  Future<int> update(Favorite object) async {
    Database db = await this.initDb();
    int count = await db.update('favorite', object.toMap(),
        where: 'id=?', whereArgs: [object.id]);
    return count;
  }

  Future<int> delete(int id) async {
    Database db = await this.initDb();
    int count = await db.delete('favorite', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<Favorite>> getFavoriteList() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query('favorite');

    return results.map((res) => Favorite.fromMap(res)).toList();
  }

  factory DbHelper() {
    _dbHelper = DbHelper._createObject();
    return _dbHelper;
  }

  Future<Database> get database async {
    _database = await initDb();
    return _database;
  }
}
