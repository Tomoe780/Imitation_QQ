import 'dart:convert';
import 'package:http/http.dart' as http;

// 新闻数据模型
class News {
  final String id;
  final String title;
  final String description;
  final String url;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
  });

  // 从JSON解析新闻数据
  factory News.fromJson(Map<String, dynamic> json) {
    // 确保从JSON解析时没有返回 null 的字段
    return News(
      id: json['id'] ?? '',  // 若为 null，默认空字符串
      title: json['title'] ?? '无标题',  // 若为 null，默认'无标题'
      description: json['description'] ?? '',  // 若为 null，默认空字符串
      url: json['url'] ?? '',  // 若为 null，默认空字符串
    );
  }
}

// 模拟的新闻 API 请求
Future<List<News>> fetchNews() async {
  const url = 'http://api.tianapi.com/generalnews/index?key=b00c8a71e17ce2a3763cda02b56f1eac&page=1&'; // 假设的新闻 API 地址
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['news'];
    return data.map((json) => News.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load news');
  }
}
