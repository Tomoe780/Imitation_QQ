import 'package:flutter/material.dart';
import 'database.dart'; // 导入数据库帮助类

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite CRUD Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsPage(),
    );
  }
}

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<News> _newsList = [];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  // 加载所有新闻
  _loadNews() async {
    final newsList = await DatabaseHelper().getAllNews();
    setState(() {
      _newsList = newsList;
    });
  }

  // 添加一条新闻
  _addNews() async {
    // 弹出对话框输入新闻内容
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('添加新闻'),
          content: NewsForm(onSave: (news) async {
            await DatabaseHelper().insertNews(news);
            _loadNews(); // 重新加载新闻列表
            Navigator.pop(context); // 关闭对话框
          }),
        );
      },
    );
  }

  // 更新新闻
  _updateNews(News news) async {
    // 弹出对话框修改新闻内容
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('更新新闻'),
          content: NewsForm(
            news: news,
            onSave: (updatedNews) async {
              await DatabaseHelper().updateNews(updatedNews);
              _loadNews(); // 重新加载新闻列表
              Navigator.pop(context); // 关闭对话框
            },
          ),
        );
      },
    );
  }

  // 删除新闻
  _deleteNews(String id) async {
    await DatabaseHelper().deleteNews(id);
    _loadNews(); // 重新加载新闻列表
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("新闻列表")),
      body: ListView.builder(
        itemCount: _newsList.length,
        itemBuilder: (context, index) {
          final news = _newsList[index];
          return ListTile(
            title: Text(news.title),
            subtitle: Text(news.source),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteNews(news.id); // 删除新闻
              },
            ),
            onTap: () {
              // 点击新闻项更新新闻内容
              _updateNews(news);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNews, // 添加新闻
        child: Icon(Icons.add),
      ),
    );
  }
}

class NewsForm extends StatefulWidget {
  final News? news;
  final Function(News) onSave;

  const NewsForm({Key? key, this.news, required this.onSave}) : super(key: key);

  @override
  _NewsFormState createState() => _NewsFormState();
}

class _NewsFormState extends State<NewsForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _source;
  late String _picUrl;
  late String _url;
  late String _ctime;

  @override
  void initState() {
    super.initState();
    if (widget.news != null) {
      // 如果是更新新闻，填充表单
      _title = widget.news!.title;
      _description = widget.news!.description;
      _source = widget.news!.source;
      _picUrl = widget.news!.picUrl;
      _url = widget.news!.url;
      _ctime = widget.news!.ctime;
    } else {
      // 默认值
      _title = '';
      _description = '';
      _source = '';
      _picUrl = '';
      _url = '';
      _ctime = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: _title,
            decoration: InputDecoration(labelText: '标题'),
            validator: (value) => value!.isEmpty ? '请输入标题' : null,
            onSaved: (value) => _title = value!,
          ),
          TextFormField(
            initialValue: _description,
            decoration: InputDecoration(labelText: '描述'),
            validator: (value) => value!.isEmpty ? '请输入描述' : null,
            onSaved: (value) => _description = value!,
          ),
          TextFormField(
            initialValue: _source,
            decoration: InputDecoration(labelText: '来源'),
            validator: (value) => value!.isEmpty ? '请输入来源' : null,
            onSaved: (value) => _source = value!,
          ),
          TextFormField(
            initialValue: _picUrl,
            decoration: InputDecoration(labelText: '图片URL'),
            onSaved: (value) => _picUrl = value!,
          ),
          TextFormField(
            initialValue: _url,
            decoration: InputDecoration(labelText: '新闻链接'),
            onSaved: (value) => _url = value!,
          ),
          TextFormField(
            initialValue: _ctime,
            decoration: InputDecoration(labelText: '发布时间'),
            onSaved: (value) => _ctime = value!,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final news = News(
                  id: widget.news?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _title,
                  description: _description,
                  source: _source,
                  picUrl: _picUrl,
                  url: _url,
                  ctime: _ctime,
                );
                widget.onSave(news); // 调用保存操作
              }
            },
            child: Text(widget.news == null ? '添加新闻' : '更新新闻'),
          ),
        ],
      ),
    );
  }
}
