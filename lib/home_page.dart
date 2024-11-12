import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'user_profile_page.dart';
import 'chat_page.dart';
import 'dynamic_page.dart';
import 'world_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Friend {
  final String name; // 好友昵称
  final String avatar; // 头像路径
  final String lastMessage; // 最近的聊天内容
  final String lastMessageTime; // 最近消息时间

  Friend({
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.lastMessageTime,
  });
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  // 创建包含个性化昵称和头像的好友列表
  final List<Friend> friends = [
    Friend(name: '毛润之', avatar: 'images/QQ头像_1.png', lastMessage: '一万年太久，只争朝夕', lastMessageTime: '5:00 PM'),
    Friend(name: '李云鹤', avatar: 'images/QQ头像_2.png', lastMessage: '我听着呢，你说吧', lastMessageTime: '3:20 PM'),
    Friend(name: '姚文元', avatar: 'images/QQ头像_3.png', lastMessage: '文坛杀手', lastMessageTime: '5:01 PM'),
    Friend(name: '张春桥', avatar: 'images/QQ头像_4.png', lastMessage: '信仰坚定的战士', lastMessageTime: '2:10 PM'),
    Friend(name: '王洪文', avatar: 'images/QQ头像_5.png', lastMessage: '工农兵', lastMessageTime: '8:00 PM'),
    Friend(name: '林彪', avatar: 'images/QQ头像_6.png', lastMessage: '第四野战军，最锋利的剑', lastMessageTime: '5:42 PM'),
    Friend(name: '胡耀邦', avatar: 'images/QQ头像_7.png', lastMessage: '善良的人', lastMessageTime: '7:10 PM'),
    Friend(name: '赵紫阳', avatar: 'images/QQ头像_8.png', lastMessage: '知难而进', lastMessageTime: '9:13 PM'),
    Friend(name: '江泽民', avatar: 'images/QQ头像_9.png', lastMessage: '谈笑风生', lastMessageTime: '1:15 PM'),
    Friend(name: '胡锦涛', avatar: 'images/QQ头像_10.png', lastMessage: '惋惜', lastMessageTime: '4:11 PM'),
  ];

  ScrollController _scrollController = ScrollController(); // 用于控制滚动

  @override
  void initState() {
    super.initState();
    // 设置状态栏不沉浸
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 设置状态栏背景色
      statusBarIconBrightness: Brightness.light, // 设置状态栏图标的颜色（亮色）
    ));

    // 可选：在页面加载时，自动滚动到消息列表的底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();  // 页面销毁时销毁控制器
    super.dispose();
  }

  // 滚动到列表的底部
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, // 滚动到最大位置
      duration: Duration(milliseconds: 300), // 滚动的时间
      curve: Curves.easeOut, // 滚动动画的曲线
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 50.0, // 增加阴影效果，使状态栏显得立体
        backgroundColor: Colors.blue,
        leading: GestureDetector(
          onTap: () {
            _showUserProfile(context);
          },
          child: CircleAvatar(
            radius: 10,
            backgroundImage: AssetImage('images/QQ头像.jpg'),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tomoe', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                // 绿色圆点
                CircleAvatar(
                  radius: 6,
                  backgroundColor: Colors.green,
                ),
                SizedBox(width: 8),
                Text(
                  '手机在线',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showMenu(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.blue,
        child: BottomNavigationBar(
          currentIndex: currentPageIndex,
          onTap: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: '消息',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.adjust),
              label: '小世界',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: '联系人',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.refresh),
              label: '动态',
            ),
          ],
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      body: _getPage(currentPageIndex),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildMessagesPage();
      case 1:
        return HotSearchPage();
      case 2:
        return Center(child: Text("联系人"));
      case 3:
        return DynamicPage();
      default:
        return Center(child: Text("消息"));
    }
  }


  Widget _buildMessagesPage() {
    return ListView.builder(
      controller: _scrollController,  // 设置控制器
      padding: const EdgeInsets.all(8),
      itemCount: friends.length,  // 使用 friends 列表的长度
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(backgroundImage: AssetImage(friends[index].avatar)), // 使用对应好友的头像
          title: Text(friends[index].name),  // 使用对应好友的昵称
          subtitle: Row(
            children: [
              Expanded(child: Text(friends[index].lastMessage)),  // 显示最近消息
              Text(friends[index].lastMessageTime, style: TextStyle(fontSize: 12, color: Colors.grey)),  // 显示消息时间
            ],
          ),
          onTap: () {
            // 点击打开聊天界面
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(friendName: friends[index].name),
              ),
            );
          },
        );
      },
    );
  }

  // 点击头像弹出用户个人资料页面
  void _showUserProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(), // 跳转到个人资料页面
      ),
    );
  }

  // 弹出菜单
  void _showMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(1000, 80, 0, 0),
      items: [
        PopupMenuItem(
          value: 1,
          child: Text("发起群聊"),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("添加好友"),
        ),
        PopupMenuItem(
          value: 3,
          child: Text("扫一扫"),
        ),
        PopupMenuItem(
          value: 4,
          child: Text("收付款"),
        ),
      ],
    ).then((value) {
      if (value != null) {
        // 根据选择的菜单项执行相应的操作
      }
    });
  }
}
