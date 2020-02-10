import 'dart:core';
import 'dart:core' as prefix0;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';
import 'Objects.dart';

class DatabaseHelper {

  static final _databaseName = "Pins.db";
  static final _databaseVersion = 1;

  static final table = 'Pins';

  static final columnId = 'ID';
  static final columnYear = 'Year';
  static final columnMarked = 'Marked';
  static final columnSeries = 'Series';
  static final columnNumber = 'Number';
  static final columnQty = 'Qty';
  static final columnDesc = 'Description';
  static final columnPath = 'Path';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();


  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {

    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "Pins.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copy from asset");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "Pins.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    return await openDatabase(path, readOnly: false);

  }

  Future<List<int>> getList(int type) async{
    List<int> list = new List();
    Database db = await instance.database;
    List<Map<String, dynamic>> templist;
    if (type == 1)
      templist = await (db.rawQuery('SELECT $columnId FROM $table WHERE ($columnMarked > 0)'));
    else if (type == 2)
      templist = await (db.rawQuery('SELECT $columnId FROM $table WHERE ($columnQty > 0)'));

    for (Map<String, dynamic> l in templist){
      list.add((l["ID"])-1);
    }
    return list;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> getSetSize(int year, int series)async{
    Database db = await instance.database;
    List<Map<String, dynamic>> temp = await (db.rawQuery('SELECT $columnId FROM $table WHERE $columnYear = ? AND $columnSeries = ?',[year, series]));
    return temp.length;
  }



  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<int>> checkForRelevantPins(int id) async{
    Database db = await instance.database;
    //print("DB HELPER ID:  " + id.toString());
    List<Map<String, dynamic>> templist = await (db.rawQuery('SELECT $columnDesc, Series, Year FROM $table WHERE $columnId = ?',[id]));
    //if (templist.isEmpty)
    //return new List<Pin>();
    Map<String, dynamic> temp = templist.first;
    String desc = temp["Description"];
    String newdesc = "CMP " + desc;
    int s = temp["Series"];
    int y = temp["Year"];
    List<Map<String, dynamic>> result = List<Map< String, dynamic>>();
    // check if there is a completer pin for this set
    result.addAll(await db.rawQuery('SELECT ID FROM $table WHERE $columnDesc = ? AND (Series != ? AND Year = ?)',['$newdesc', '$s', '$y']));

    result.addAll(await db.rawQuery('SELECT ID FROM $table WHERE $columnDesc = ? AND (Series != ? OR Year != ?)',['$desc', '$s', '$y']));


    List<int> pins= new List();
    result.forEach((p) => pins.add(p["ID"]-1));
    return pins;
  }
}