import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

Future<String?> downloadImage(String imageUrl) async {
  try {
    // 获取应用的临时目录
    final directory = await getApplicationDocumentsDirectory();
    final fileName = basename(imageUrl); // 获取文件名
    final filePath = join(directory.path, fileName); // 文件存储路径

    // 下载图片
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      // 将图片保存到本地文件
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath; // 返回本地文件路径
    } else {
      throw Exception('图片下载失败');
    }
  } catch (e) {
    print('下载图片失败: $e');
    return null;
  }
}
