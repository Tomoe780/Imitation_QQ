import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dynamic_page.dart'; // 导入新闻模型

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // 初始化数据库
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'news.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE news(
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            source TEXT,
            picUrl TEXT,
            url TEXT,
            ctime TEXT
          )
        ''');
      },
    );
  }

  // 插入新闻数据
  Future<void> insertNews(List<News> newsList) async {
    final db = await database;
    final batch = db.batch();
    for (var news in newsList) {
      batch.insert(
        'news',
        news.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // 从数据库加载新闻数据
  Future<List<News>> fetchNews() async {
    final db = await database;
    final maps = await db.query('news');

    return List.generate(maps.length, (i) {
      return News.fromJson(maps[i]);
    });
  }
}
