import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_page.dart'; // 引入注册页面
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
        '/home': (context) => MyHomePage(title: "Home Page", nickname: 'Tomoe'),
        '/register': (context) => const RegisterPage(), // 注册页面路由
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
  bool rememberPassword = false;
  final TextEditingController qqController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCredentials();  // 载入已保存的用户名和密码
  }

  // 载入已保存的QQ号和密码
  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedQQ = prefs.getString('qq');
    final savedPassword = prefs.getString('password');
    final isRemembered = prefs.getBool('rememberMe') ?? false;

    if (isRemembered) {
      setState(() {
        qqController.text = savedQQ ?? '';
        passwordController.text = savedPassword ?? '';
        checkboxSelected = true; // 如果已勾选“记住密码”，默认勾选复选框
      });
    }
  }

  // 保存QQ号、密码和记住密码状态
  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberPassword) {
      prefs.setString('qq', qqController.text);
      prefs.setString('password', passwordController.text);
      prefs.setBool('rememberMe', true);
    } else {
      prefs.remove('qq');
      prefs.remove('password');
      prefs.remove('rememberMe');
    }
  }

  // 登录逻辑
  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();
    final registeredQQ = prefs.getString('qq');
    final registeredPassword = prefs.getString('password');
    final registeredNickname = prefs.getString('nickname');

    if (qqController.text == registeredQQ && passwordController.text == registeredPassword) {
      // 登录成功，跳转到主界面并显示昵称
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(title: 'Home Page', nickname: registeredNickname!),
        ),
      );
      _saveCredentials();  // 保存“记住密码”状态
    } else {
      // 密码错误或QQ号不匹配
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QQ号或密码错误，请重新输入')),
      );
      qqController.clear();
      passwordController.clear();
    }

  }

  // 跳转到注册页面
  Future<void> _navigateToRegisterPage() async {
    final result = await Navigator.pushNamed(context, '/register') as String?;
    if (result != null) {
      setState(() {
        qqController.text = result; // 将注册成功的 QQ 号填充到输入框
      });
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
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: qqController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '请输入QQ号',
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 20),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: rememberPassword,
                        onChanged: (value) {
                          setState(() {
                            rememberPassword = value!;
                          });
                        },
                      ),
                      const Text("记住密码"),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
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
                  const Text("已阅读并同意服务协议"),
                ],
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: checkboxSelected ? _login : null,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
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
              Column(
                children: [
                  const SizedBox(height: 60),
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
                      const SizedBox(width: 20),
                      Container(width: 1, height: 15, color: Colors.grey),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: _navigateToRegisterPage, // 跳转到注册页面
                        child: const Text(
                          '新用户注册',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(width: 1, height: 15, color: Colors.grey),
                      const SizedBox(width: 20),
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

