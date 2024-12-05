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


  News copyWith({
    String? id,
    String? title,
    String? description,
    String? source,
    String? picUrl,
    String? url,
    String? ctime,
  }) {
    return News(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      source: source ?? this.source,
      picUrl: picUrl ?? this.picUrl,
      url: url ?? this.url,
      ctime: ctime ?? this.ctime,
    );
  }

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

  // 从JSON解析新闻数据
  factory News.fromJson(Map<String, dynamic> json) {
    String picUrl = json['picUrl'] ?? '';
    if (!picUrl.startsWith('http') && !picUrl.startsWith('https')) {
      picUrl = 'https://via.placeholder.com/150'; // 使用默认网络图片URL
    }

    return News(
      id: json['id'] ?? '',
      title: json['title'] ?? '无标题',
      description: json['description'] ?? '',
      source: json['source'] ?? '未知来源',
      picUrl: picUrl,
      url: json['url'] ?? '',
      ctime: json['ctime'] ?? '',
    );
  }
}

// 根据分类请求新闻数据
Future<List<News>> fetchNews(int page, String category) async {
  final url = 'http://api.tianapi.com/generalnews/index?key=b00c8a71e17ce2a3763cda02b56f1eac&page=$page&';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    // 解析新闻列表
    final newsList = (data['newslist'] as List).map((item) {
      return News.fromJson(item); // 直接将数据转换为 News 对象
    }).toList();
    return newsList;
}


// 动态页面类
class DynamicPage extends StatefulWidget {
  @override
  _DynamicPageState createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage> {
  int _currentPage = 1;
  late Future<List<News>> _newsList;
  String _selectedCategory = '国内'; // 新增：默认选择新闻分类

  @override
  void initState() {
    super.initState();
    _newsList = fetchNews(_currentPage, _selectedCategory); // 根据分类加载新闻
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("综合新闻"),
        actions: [
          // 分类选择下拉框
          DropdownButton<String>(
            value: _selectedCategory,
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (String? newCategory) {
              if (newCategory != null) {
                setState(() {
                  _selectedCategory = newCategory;
                  _currentPage = 1; // 切换分类时重置页码
                  _newsList = fetchNews(_currentPage, _selectedCategory); // 获取新分类的新闻
                });
              }
            },
            items: ['国内', '国际', '科技', '体育'].map<DropdownMenuItem<String>>((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
          ),
          // 刷新按钮
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _currentPage++;
                _newsList = fetchNews(_currentPage, _selectedCategory); // 刷新时获取下一页新闻
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _currentPage++;
            _newsList = fetchNews(_currentPage, _selectedCategory); // 下拉刷新时获取下一页新闻
          });
        },
        child: FutureBuilder<List<News>>(
          future: _newsList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("加载新闻失败: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("暂无新闻"));
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
                      return const Icon(Icons.broken_image, size: 80);
                    },
                  )
                      : const Icon(Icons.image, size: 80),
                  title: Text(news.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(news.source),
                      Text(news.ctime, style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
class NewsDetailPage extends StatefulWidget {
  final String url;

  const NewsDetailPage({super.key, required this.url});

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  bool _isLoading = true; // 用于控制进度条显示

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新闻详情"),
      ),
      body: Column(
        children: [
          if (_isLoading) const LinearProgressIndicator(), // 显示加载进度条
          Expanded(
            child: WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: (url) {
                setState(() {
                  _isLoading = true; // 网页开始加载时显示进度条
                });
              },
              onPageFinished: (url) {
                setState(() {
                  _isLoading = false; // 网页加载完成时隐藏进度条
                });
              },
              onWebViewCreated: (WebViewController webViewController) {
                // 可以在此进行WebView配置
              },
            ),
          ),
        ],
      ),
    );
  }
}
