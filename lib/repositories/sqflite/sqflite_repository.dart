import 'dart:convert';

import 'package:replacer/models/replace_data/replace_data.dart';
import 'package:replacer/models/replace_format/replace_format.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteRepository {
  static const _databaseName = "sqflite_Database3.db";
  static const _databaseVersion = 1;
  static const formatTable = 'formatTable';

  static const formatId = 'formatId';
  static const formatName = 'formatName';
  static const thumbnailImage = 'thumbnailImage';
  static const replaceDataList = 'replaceDataList';
  static const createdAt = 'createdAt';

  SqfliteRepository._();
  static final SqfliteRepository instance = SqfliteRepository._();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $formatTable (
            $formatId TEXT PRIMARY KEY,
            $formatName TEXT NOT NULL,
            $thumbnailImage BLOB,
            $replaceDataList TEXT NOT NULL,
            $createdAt TEXT NOT NULL
          )
          ''');
  }

  /// 現在の最大のIDを取得する
  Future<String> fetchCurrentId() async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>>? fetchData = await db.query(formatTable, orderBy: '$formatId DESC');
      final List<ReplaceFormat> allFormat = fetchData.map((e) => mapToFormat(e)).toList();
      return allFormat.isNotEmpty ? allFormat[0].formatId : '000000';
    } catch (e) {
      print('Idの最大値を取得中にエラーが発生しました: $e');
      return '';
    }
  }

  String encodeReplaceDataList(List<ReplaceData> replaceDataList) {
    final encodeDataList = replaceDataList.map((e) => e.toJson()).toList();
    return jsonEncode(encodeDataList);
  }

// add database row
  Future<int> insertFormat(ReplaceFormat format) async {
    Database db = await instance.database;
    final currentId = await fetchCurrentId();
    final newId = (int.parse(currentId) + 1).toString().padLeft(6, '0');
    try {
      final row = {
        formatId: newId,
        formatName: format.formatName,
        thumbnailImage: format.thumbnailImage,
        replaceDataList: encodeReplaceDataList(format.replaceDataList),
        createdAt: format.createdAt.toIso8601String(),
      };
      int result = await db.insert(formatTable, row);
      print('データベースへの挿入が成功しました : $row');
      return result;
    } catch (e) {
      print('データベースへの挿入中にエラーが発生しました: $e');
      return -1; // エラーが発生した場合は-1を返す
    }
  }

  Future<List<ReplaceFormat>> fetchSavedAllFormat() async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>>? fetchData = await db.query(formatTable, orderBy: '$createdAt DESC');
      final List<ReplaceFormat> allFormat = fetchData.map((e) => mapToFormat(e)).toList();
      return allFormat;
    } catch (e) {
      print('全てのフォーマットを取得中にエラーが発生しました: $e');
      return [];
    }
  }

// find by Id
  Future<ReplaceFormat?> findFormatById(String id) async {
    try {
      Database db = await instance.database;
      final List<Map<String, dynamic>> maps = await db.query(
        formatTable,
        where: '$formatId = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return mapToFormat(maps.first);
      } else {
        return null;
      }
    } catch (e) {
      print('IDによる検索中にエラーが発生しました: $e');
      return null;
    }
  }

  ReplaceFormat mapToFormat(Map<String, dynamic> map) {
    try {
      final List<dynamic> decodedList = jsonDecode(map[replaceDataList]);
      final List<ReplaceData> decodedReplaceDataList = decodedList.map((e) => ReplaceData.fromJson(e)).toList();
      final format = ReplaceFormat(
        formatId: map[formatId],
        formatName: map[formatName],
        thumbnailImage: map[thumbnailImage],
        replaceDataList: decodedReplaceDataList,
        createdAt: DateTime.parse(map[createdAt]),
      );
      return format;
    } catch (e) {
      print('マップからフォーマットへの変換中にエラーが発生しました: $e');
      throw Exception('マップからフォーマットへの変換に失敗しました');
    }
  }

  /// formatNameを更新 更新が成功した場合は1を返す
  Future<int> updateFormatName(String id, String newName) async {
    try {
      Database db = await instance.database;
      return await db.update(
        formatTable,
        {
          formatName: newName,
        },
        where: '$formatId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('フォーマット名の更新中にエラーが発生しました: $e');
      return -1;
    }
  }

// delete row 削除が成功した場合は1を返す
  Future<int> deleteRow(String id) async {
    try {
      Database db = await instance.database;
      return await db.delete(
        formatTable,
        where: '$formatId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('行の削除中にエラーが発生しました: $e');
      return -1;
    }
  }
}
