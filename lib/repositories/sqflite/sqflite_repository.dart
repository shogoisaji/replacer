// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// @Riverpod(keepAlive: true)
// SqfliteRepository sqfliteRepository(
//   SqfliteRepositoryRef ref,
// ) {
//   throw UnimplementedError();
// }

// class SqfliteRepository {
//   static const _databaseName = "sqflite_Database.db";
//   static const _databaseVersion = 1;

//   static const bucketTable = 'bucketTable';
//   static const columnBucketId = 'BucketId';
//   static const columnBucketTitle = 'bucketTitle';
//   static const columnBucketDescription = 'bucketDescription';
//   static const columnBucketInnerColor = 'bucketInnerColor';
//   static const columnBucketOuterColor = 'bucketOuterColor';
//   static const columnBucketLayoutSizeX = 'bucketLayoutSizeX';
//   static const columnBucketLayoutSizeY = 'bucketLayoutSizeY';
//   static const columnBucketIntoBlock = 'bucketIntoBlock';
//   static const columnBucketRegisterDate = 'bucketRegisterDate';
//   static const columnBucketArchiveDate = 'bucketArchiveDate';

//   SqfliteRepository._();
//   static final SqfliteRepository instance = SqfliteRepository._();

//   static Database? _database;
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   _initDatabase() async {
//     String path = join(await getDatabasesPath(), _databaseName);
//     return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
//   }

//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//           CREATE TABLE $bucketTable (
//             $columnBucketId TEXT PRIMARY KEY,
//             $columnBucketTitle TEXT NOT NULL,
//             $columnBucketDescription TEXT,
//             $columnBucketInnerColor INTEGER NOT NULL,
//             $columnBucketOuterColor INTEGER NOT NULL,
//             $columnBucketLayoutSizeX INTEGER NOT NULL,
//             $columnBucketLayoutSizeY INTEGER NOT NULL,
//             $columnBucketIntoBlock TEXT,
//             $columnBucketRegisterDate TEXT NOT NULL,
//             $columnBucketArchiveDate TEXT
//           )
//           ''');
//   }

// // add database row
//   Future<void> insertBucket(Bucket bucket) async {
//     Database db = await instance.database;
//     final row = {
//       columnBucketId: bucket.bucketId,
//       columnBucketTitle: bucket.bucketTitle,
//       columnBucketDescription: bucket.bucketDescription,
//       columnBucketInnerColor: bucket.bucketInnerColor.value,
//       columnBucketOuterColor: bucket.bucketOuterColor.value,
//       columnBucketLayoutSizeX: bucket.bucketLayoutSizeX,
//       columnBucketLayoutSizeY: bucket.bucketLayoutSizeY,
//       columnBucketIntoBlock: bucket.jsonEncodeBucketIntoBlock(),
//       columnBucketRegisterDate: bucket.bucketRegisterDate.toIso8601String(),
//     };
//     await db.insert(bucketTable, row);
//   }

//   Future<List<Bucket>> fetchArchiveBucket() async {
//     Database db = await instance.database;
//     List<Map<String, dynamic>>? allBucket = await db.query(bucketTable, orderBy: '$columnBucketRegisterDate DESC');
//     if (allBucket == []) return [];
//     final List<Bucket> bucketList =
//         allBucket.where((e) => e[columnBucketArchiveDate] != null).map((e) => mapToBucket(e)).toList();
//     return bucketList;
//   }

// // find by Id
//   Future<Bucket?> findBucketById(String id) async {
//     Database db = await instance.database;
//     final List<Map<String, dynamic>> maps = await db.query(
//       bucketTable,
//       where: '$columnBucketId = ?',
//       whereArgs: [id],
//     );

//     if (maps.isNotEmpty) {
//       return mapToBucket(maps.first);
//     } else {
//       return null;
//     }
//   }

//   Bucket mapToBucket(Map<String, dynamic> map) {
//     final Bucket bucket = Bucket(
//       bucketId: map[columnBucketId],
//       bucketTitle: map[columnBucketTitle],
//       bucketDescription: map[columnBucketDescription] ?? '',
//       bucketInnerColor: Color(map[columnBucketInnerColor]),
//       bucketOuterColor: Color(map[columnBucketOuterColor]),
//       bucketLayoutSizeX: map[columnBucketLayoutSizeX],
//       bucketLayoutSizeY: map[columnBucketLayoutSizeY],
//       bucketIntoBlock: Bucket.jsonDecodeBucketIntoBlock(json.decode(map[columnBucketIntoBlock])),
//       bucketRegisterDate: DateTime.parse(map[columnBucketRegisterDate]),
//       bucketArchiveDate: map[columnBucketArchiveDate] != null ? DateTime.parse(map[columnBucketArchiveDate]) : null,
//     );
//     return bucket;
//   }

// // update bucketIntoBlock
//   Future<int> updateBucketIntoBlock(String id, Bucket bucket) async {
//     Database db = await instance.database;
//     return await db.update(
//       bucketTable,
//       {
//         columnBucketIntoBlock: bucket.jsonEncodeBucketIntoBlock(),
//       },
//       where: '$columnBucketId = ?',
//       whereArgs: [id],
//     );
//   }

// // update bucketIntoBlock
//   Future<int> updateBucket(String id, Bucket bucket) async {
//     Database db = await instance.database;
//     return await db.update(
//       bucketTable,
//       {
//         columnBucketTitle: bucket.bucketTitle,
//         columnBucketDescription: bucket.bucketDescription,
//         columnBucketInnerColor: bucket.bucketInnerColor.value,
//         columnBucketOuterColor: bucket.bucketOuterColor.value,
//         columnBucketLayoutSizeX: bucket.bucketLayoutSizeX,
//         columnBucketLayoutSizeY: bucket.bucketLayoutSizeY,
//         columnBucketIntoBlock: bucket.jsonEncodeBucketIntoBlock(),
//         columnBucketRegisterDate: bucket.bucketRegisterDate.toIso8601String(),
//         columnBucketArchiveDate: bucket.bucketArchiveDate?.toIso8601String(),
//       },
//       where: '$columnBucketId = ?',
//       whereArgs: [id],
//     );
//   }

// // delete row
//   Future<void> deleteRow(String id) async {
//     Database db = await instance.database;
//     await db.delete(
//       bucketTable,
//       where: '$columnBucketId = ?',
//       whereArgs: [id],
//     );
//   }
// }
