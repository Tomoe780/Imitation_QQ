import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

// 新闻数据模型
class News {
  final String id;
  final String title;
  final String description;
  final String source;
  final String picUrl;
  final String url;
  final String ctime;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.source,
    required this.picUrl,
    required this.url,
    required this.ctime,
  });

  // 转换为数据库可存储的 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'source': source,
      'picUrl': picUrl,
      'url': url,
      'ctime': ctime,
    };
  }

  // 从 Map 中创建 News 对象
  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      source: map['source'],
      picUrl: map['picUrl'],
      url: map['url'],
      ctime: map['ctime'],
    );
  }
}

// 数据库操作类
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
    final path = join(dbPath, 'news.db'); // 数据库文件

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
  Future<void> insertNews(News news) async {
    final db = await database;
    await db.insert(
      'news',
      news.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // 如果主键重复，替换数据
    );
  }

  // 获取所有新闻
  Future<List<News>> getAllNews() async {
    final db = await database;
    final maps = await db.query('news');

    return List.generate(maps.length, (i) {
      return News.fromMap(maps[i]);
    });
  }

  // 根据ID获取新闻
  Future<News?> getNewsById(String id) async {
    final db = await database;
    final maps = await db.query(
      'news',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return News.fromMap(maps.first);
    }
    return null;
  }

  // 更新新闻
  Future<int> updateNews(News news) async {
    final db = await database;
    return await db.update(
      'news',
      news.toMap(),
      where: 'id = ?',
      whereArgs: [news.id],
    );
  }

  // 删除新闻
  Future<int> deleteNews(String id) async {
    final db = await database;
    return await db.delete(
      'news',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
