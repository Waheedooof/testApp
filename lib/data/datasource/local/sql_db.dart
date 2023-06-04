// import 'dart:async';
// import 'package:get/get.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class SqlDB extends DataOps {
//   static Database? _db;
//
//   Future<Database?> get db async {
//     if (_db.isNull) {
//       _db = await initDb();
//     }
//     return _db;
//   }
//
//   Future<Database?> initDb() async {
//     String databasePath = await getDatabasesPath();
//     String path = join(databasePath, 'times.db');
//     Database database = await openDatabase(
//       path,
//       onCreate: _onCreate,
//       version: 1,
//       onUpgrade: _onUpgrade,
//     );
//     return database;
//   }
//
//   FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {}
//
//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//     CREATE TABLE "times" (
//     id INTEGER AUTOINCREMENT NOT NULL PRIMARY KEY,
//     time TEXT ,
//     name TEXT ,
//     locationLate REAL ,
//     locationLong REAL ,
//     mode VARCHAR(1) ,
//     )
//     ''');
//     print('onCreate CREATE TABLE times ==============');
//   }
//
//   @override
//   Future<List<Map>> readData(String sql) async {
//     Database? myDb = await db;
//     List<Map> response = await myDb!.rawQuery(sql);
//     return response;
//   }
//
//   @override
//   Future<int> insertData(String sql) async {
//     Database? myDb = await db;
//     int response = await myDb!.rawInsert(sql);
//     return response;
//   }
//
//   @override
//   Future<int> deleteData(String sql) async {
//     Database? myDb = await db;
//     int response = await myDb!.rawDelete(sql);
//     return response;
//   }
//
//   @override
//   Future<int> updateData(String sql) async {
//     Database? myDb = await db;
//     int response = await myDb!.rawUpdate(sql);
//     return response;
//   }
// }
//
// abstract class DataOps {
//   Future<List<Map>> readData(String sql);
//
//   Future<int> insertData(String sql);
//
//   Future<int> deleteData(String sql);
//
//   Future<int> updateData(String sql);
// }
