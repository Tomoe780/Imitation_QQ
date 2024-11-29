import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController qqController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _register() async {
    final prefs = await SharedPreferences.getInstance();

    if (qqController.text.isEmpty || passwordController.text.isEmpty || nicknameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写完整信息')),
      );
      return;
    }

    await prefs.setString('nickname', nicknameController.text);
    await prefs.setString('qq', qqController.text);
    await prefs.setString('password', passwordController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('注册成功！')),
    );

    // 返回登录页面并传递 QQ 号
    Navigator.pop(context, qqController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('注册'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 顶部标题
              Text(
                '欢迎注册',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),

              // 昵称输入框
              _buildInputField(
                controller: nicknameController,
                hintText: '请输入昵称',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),

              // QQ号输入框
              _buildInputField(
                controller: qqController,
                hintText: '请输入QQ号',
                icon: Icons.account_circle,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // 密码输入框
              _buildInputField(
                controller: passwordController,
                hintText: '请输入密码',
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 30),

              // 注册按钮
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  '注册',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    IconData? icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          icon: Icon(icon, color: Colors.blueAccent),
        ),
      ),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _changePassword() async {
    final prefs = await SharedPreferences.getInstance();
    final currentPassword = prefs.getString('password');

    // 检查当前密码是否正确
    if (currentPasswordController.text != currentPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('当前密码错误')),
      );
      return;
    }

    // 检查新密码和确认密码是否匹配
    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('新密码和确认密码不一致')),
      );
      return;
    }

    // 更新密码
    await prefs.setString('password', newPasswordController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('密码修改成功')),
    );

    Navigator.pop(context); // 返回到登录页面
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('修改密码')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '当前密码'),
            ),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '新密码'),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '确认密码'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              child: const Text('修改密码'),
            ),
          ],
        ),
      ),
    );
  }
}
