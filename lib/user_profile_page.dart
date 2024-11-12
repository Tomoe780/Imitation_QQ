import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人资料'),
        backgroundColor: Colors.blue,
      ),
      body: CustomScrollView(
        slivers: [
          // 背景部分
          SliverAppBar(
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'images/QQ背景图.jpg', // 你的背景图
                fit: BoxFit.cover,
              ),
              title: SizedBox(), // 这里不显示原来 title 的内容
            ),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 用户头像和信息
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('images/QQ头像.jpg'),
                        ),
                        SizedBox(width: 16),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '5120223299 钱川',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text('QQ号：780741725', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        // 点赞图标和数量
                        Align(
                          alignment: Alignment.centerRight, // 向右对齐
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // 确保Column只占用最小空间
                            crossAxisAlignment: CrossAxisAlignment.center, // 确保图标和数字居中
                            children: [
                              Icon(
                                Icons.thumb_up_alt_outlined,
                                size: 24, // 可以调整图标的大小
                              ),
                              SizedBox(height: 4), // 图标和数字之间的间距
                              Text(
                                '1001',
                                style: TextStyle(fontSize: 14), // 点赞数字字体变小
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Text('男  |  双子座  |  现居四川绵阳'),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(Icons.wb_sunny, color: Colors.orange, size: 20),
                        SizedBox(width: 4),
                        Icon(Icons.wb_sunny, color: Colors.orange, size: 20),
                        SizedBox(width: 4),
                        Icon(Icons.nightlight_round, color: Colors.yellow, size: 20),
                        SizedBox(width: 4),
                        Icon(Icons.nightlight_round, color: Colors.yellow, size: 20),
                        SizedBox(width: 4),
                        Icon(Icons.star, color: Colors.yellow, size: 20),
                        SizedBox(width: 4),
                        Icon(Icons.star, color: Colors.yellow, size: 20),
                        SizedBox(width: 4),
                      ],
                    ),
                    SizedBox(height: 24),
                    Text('知行合一', style: TextStyle(fontSize: 16)),

                    // 新增的“QQ空间”和“精选照片”部分，放置在左边并分行显示
                    SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
                      children: [
                        _buildRowWithIcon('QQ空间', Icons.public),
                        SizedBox(height: 16), // 增加间距
                        _buildRowWithIcon('精选照片', Icons.photo_library),
                      ],
                    ),

                    SizedBox(height: 180),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildButton("个性名片"),
                        _buildButton("修改资料"),
                        _buildBlueButton("发消息"),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // 创建带图标的Row
  Widget _buildRowWithIcon(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 16, color: Colors.blue)),
      ],
    );
  }

  // 创建普通按钮
  Widget _buildButton(String text) {
    return Container(
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  // 创建带蓝色背景的按钮
  Widget _buildBlueButton(String text) {
    return Container(
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}
