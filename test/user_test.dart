import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Imitation_QQ/user_profile_page.dart'; // 根据实际路径修改

void main() {
  group('UserProfilePage UI Tests', () {
    testWidgets('should display the correct UI elements', (WidgetTester tester) async {
      // 构建 Widget 树
      await tester.pumpWidget(MaterialApp(
        home: UserProfilePage(),
      ));

      // 验证标题是否正确显示
      expect(find.text('个人资料'), findsOneWidget);

      // 验证背景图片是否正确加载
      expect(find.byType(Image), findsOneWidget);

      // 验证用户头像是否显示
      expect(find.byType(CircleAvatar), findsOneWidget);

      // 验证用户昵称和 QQ 号是否正确显示
      expect(find.text('Tomoe'), findsOneWidget);
      expect(find.text('QQ号：780741725'), findsOneWidget);

      // 验证点赞图标及数量是否显示
      expect(find.byIcon(Icons.thumb_up_alt_outlined), findsOneWidget);
      expect(find.text('1001'), findsOneWidget);

      // 验证性别、星座等信息是否正确显示
      expect(find.text('男  |  双子座  |  现居四川绵阳'), findsOneWidget);

      // 验证图标和“QQ空间”与“精选照片”是否显示
      expect(find.byIcon(Icons.public), findsOneWidget);
      expect(find.byIcon(Icons.photo_library), findsOneWidget);
      expect(find.text('QQ空间'), findsOneWidget);
      expect(find.text('精选照片'), findsOneWidget);

      // 验证底部按钮是否正确显示
      expect(find.text('个性名片'), findsOneWidget);
      expect(find.text('修改资料'), findsOneWidget);
      expect(find.text('发消息'), findsOneWidget);
    });
  });

  group('UserProfilePage Button Click Tests', () {
    testWidgets('should trigger actions when buttons are clicked', (WidgetTester tester) async {
      // 构建 Widget 树
      await tester.pumpWidget(MaterialApp(
        home: UserProfilePage(),
      ));

      // 点击“个性名片”按钮并验证
      await tester.tap(find.text('个性名片'));
      await tester.pump(); // 等待界面更新

      // 点击“修改资料”按钮并验证
      await tester.tap(find.text('修改资料'));
      await tester.pump(); // 等待界面更新

      // 点击“发消息”按钮并验证
      await tester.tap(find.text('发消息'));
      await tester.pump(); // 等待界面更新
    });
  });
}
