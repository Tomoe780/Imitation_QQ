import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QQ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => MyHomePage(title: "Home Page"),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordVisible = false;
  bool checkboxSelected = false;
  final TextEditingController qqController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() {
    // 示例的登录逻辑
    if (qqController.text == "5120223299" && passwordController.text == "123456") {
      Navigator.pushNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QQ号或密码错误，请重新输入')),
      );
      qqController.clear();
      passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 顶部 QQ logo 和标题
              Column(
                children: [
                  Image.asset(
                    "images/QQ.png",
                    width: 160.0,
                    height: 100.0,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // QQ号输入框
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,  // 设置输入框高度为50
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: qqController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right, // 从右侧输入
                  maxLines: 1, // 单行输入
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '请输入QQ号',
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 密码输入框
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '请输入密码',
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 服务协议复选框
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: checkboxSelected,
                    onChanged: (value) {
                      setState(() {
                        checkboxSelected = value!;
                      });
                    },
                  ),
                  RichText(
                    text: TextSpan(
                      text: "已阅读并同意",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                      children: [
                        TextSpan(
                          text: "服务协议",
                          style: TextStyle(fontSize: 12, color: Colors.blue, decoration: TextDecoration.underline)
                        ),
                        TextSpan(
                          text: "和",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        TextSpan(
                          text: "QQ隐私保护指引",
                          style: TextStyle(fontSize: 12, color: Colors.blue, decoration: TextDecoration.underline)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // 登录按钮
              GestureDetector(
                onTap: checkboxSelected ? _login : null,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.lightBlueAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 底部的其他选项
              Column(
                children: [
                  const SizedBox(height: 60),  // 调整选项与按钮之间的距离
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // 手机号登录逻辑
                        },
                        child: const Text(
                          '手机号登录',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                      const SizedBox(width: 20),  // 间距
                      Container(width: 1, height: 15, color: Colors.grey),  // 竖线分隔符
                      const SizedBox(width: 20),  // 间距
                      GestureDetector(
                        onTap: () {
                          // 新用户注册逻辑
                        },
                        child: const Text(
                          '新用户注册',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                      const SizedBox(width: 20),  // 间距
                      Container(width: 1, height: 15, color: Colors.grey),  // 竖线分隔符
                      const SizedBox(width: 20),  // 间距
                      GestureDetector(
                        onTap: () {
                          // 更多选项逻辑
                        },
                        child: const Text(
                          '更多选项',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
