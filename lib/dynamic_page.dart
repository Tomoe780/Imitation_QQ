import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

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

  // 从JSON解析新闻数据
  factory News.fromJson(Map<String, dynamic> json) {
    // 检查图片 URL 是否以 http 或 https 开头
    String picUrl = json['picUrl'] ?? '';
    if (!picUrl.startsWith('http') && !picUrl.startsWith('https')) {
      picUrl = ''; // 如果不以 http/https 开头，则设置为空字符串
    }
    String detailUrl = json['url'] ?? '';
    if (!detailUrl.startsWith('http') && !detailUrl.startsWith('https')) {
      detailUrl = 'https://$detailUrl'; // 添加默认协议
    }
    return News(
      id: json['id'] ?? '',
      title: json['title'] ?? '无标题',
      description: json['description'] ?? '',
      source: json['source'] ?? '未知来源',
      picUrl: json['picUrl'] ?? '',
      url: json['url'] ?? '',
      ctime: json['ctime'] ?? '',
    );
  }
}

// 动态页面类
class DynamicPage extends StatefulWidget {
  @override
  _DynamicPageState createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage> {
  int _currentPage = 1;
  late Future<List<News>> _newsList;

  @override
  void initState() {
    super.initState();
    _newsList = fetchNews(_currentPage);
  }

  Future<List<News>> fetchNews(int page) async {
    final url = 'https://api.tianapi.com/generalnews/index?key=b00c8a71e17ce2a3763cda02b56f1eac&page=$page';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['code'] == 200 && data['newslist'] != null) {
        return (data['newslist'] as List).map((item) => News.fromJson(item)).toList();
      } else {
        throw Exception('API返回数据格式错误');
      }
    } else {
      throw Exception('无法加载新闻数据');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("综合新闻"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _currentPage++;
                _newsList = fetchNews(_currentPage); // 刷新时获取下一页新闻
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _currentPage++;
            _newsList = fetchNews(_currentPage); // 下拉刷新时获取下一页新闻
          });
        },
        child: FutureBuilder<List<News>>(
          future: _newsList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("加载新闻失败: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("暂无新闻"));
            }

            List<News> newsList = snapshot.data!;
            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                News news = newsList[index];
                return ListTile(
                  leading: news.picUrl.isNotEmpty
                      ? Image.network(
                    news.picUrl,
                    width: 80,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 80);
                    },
                  )
                      : Icon(Icons.image, size: 80),
                  title: Text(news.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(news.source),
                      Text(news.ctime, style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailPage(url: news.url),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}


// 新闻详情页
class NewsDetailPage extends StatelessWidget {
  final String url;

  NewsDetailPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新闻详情"),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          // 可以在此添加额外的配置
        },
      ),
    );
  }
}
