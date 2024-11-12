import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 定义热搜数据模型
class HotSearch {
  final String title;
  final int hotnum;
  final String digest;

  HotSearch({
    required this.title,
    required this.hotnum,
    required this.digest,
  });

  // 从API返回的数据中解析出HotSearch对象
  factory HotSearch.fromJson(Map<String, dynamic> json) {
    return HotSearch(
      title: json['title'] ?? '无标题',
      hotnum: json['hotnum'] ?? 0,
      digest: json['digest'] ?? '暂无简介',
    );
  }
}

class HotSearchPage extends StatefulWidget {
  @override
  _HotSearchPageState createState() => _HotSearchPageState();
}

class _HotSearchPageState extends State<HotSearchPage> {
  late Future<List<HotSearch>> _hotSearchList;
  late List<HotSearch> _allHotSearches;
  late TextEditingController _searchController;

  // 获取全网热搜数据的函数
  Future<List<HotSearch>> fetchHotSearch() async {
    final String apiKey = 'b00c8a71e17ce2a3763cda02b56f1eac'; // 替换为你的API密钥
    final url = Uri.parse('https://apis.tianapi.com/networkhot/index?key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // 确保返回的数据格式正确
      if (data['code'] == 200 && data['result']['list'] != null) {
        List<HotSearch> hotSearches = (data['result']['list'] as List)
            .map((item) => HotSearch.fromJson(item))
            .toList();
        _allHotSearches = hotSearches;
        return hotSearches;
      } else {
        throw Exception('API返回数据格式错误');
      }
    } else {
      throw Exception('无法加载热搜数据');
    }
  }

  // 筛选热搜列表
  void _filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<HotSearch> filteredList = _allHotSearches
          .where((item) => item.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {
        _hotSearchList = Future.value(filteredList);
      });
    } else {
      setState(() {
        _hotSearchList = Future.value(_allHotSearches);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _hotSearchList = fetchHotSearch(); // 获取热搜数据
    _searchController = TextEditingController();
    _searchController.addListener(() {
      _filterSearchResults(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();  // 释放控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('全网热搜榜'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: '搜索热搜',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<HotSearch>>(
        future: _hotSearchList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("加载失败: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("暂无热搜数据"));
          }

          List<HotSearch> hotSearches = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              // 执行数据重新加载
              setState(() {
                _hotSearchList = fetchHotSearch();
              });
            },
            child: ListView.builder(
              itemCount: hotSearches.length,
              itemBuilder: (context, index) {
                HotSearch hotSearch = hotSearches[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      hotSearch.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("热度：${hotSearch.hotnum}"),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
