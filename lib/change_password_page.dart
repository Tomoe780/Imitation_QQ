import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  Future<void> _changePassword() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPassword = prefs.getString('password');

    if (oldPasswordController.text == storedPassword) {
      // 更新密码
      await prefs.setString('password', newPasswordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('密码修改成功'),
          backgroundColor: Colors.green, // 成功时绿色背景
        ),
      );
      Navigator.pop(context); // 返回
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('旧密码错误'),
          backgroundColor: Colors.red, // 错误时红色背景
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('修改密码'),
        backgroundColor: Colors.deepPurple, // 设置AppBar颜色
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 旧密码输入框
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '旧密码',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
              SizedBox(height: 20),
              // 新密码输入框
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '新密码',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
              SizedBox(height: 40),
              // 修改密码按钮
              ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 按钮颜色
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text('修改密码'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
