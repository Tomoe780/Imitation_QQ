import 'package:flutter_test/flutter_test.dart';

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
}


Future<List<News>> fetchNews() async {

  return [
    News(id: '1', title: '新闻1', description: '新闻描述1', url: 'https://example.com/news1'),
    News(id: '2', title: '新闻2', description: '新闻描述2', url: 'https://example.com/news2'),
  ];
}

void main() {
  group('fetchNews', () {

    test('should return a list of News when the http call completes successfully', () async {

      final newsList = await fetchNews();

      expect(newsList, isA<List<News>>());
      expect(newsList.length, 2);
      expect(newsList[0].title, '新闻1');
      expect(newsList[1].title, '新闻2');
    });

    test('should throw an exception when the http call fails', () async {

      expect(() async => throw Exception('HTTP call failed'), throwsException);
    });
  });
}
