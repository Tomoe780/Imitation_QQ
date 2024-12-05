import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MyHomePage extends StatelessWidget {
  final String nickname;

  const MyHomePage({Key? key, required this.nickname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(nickname)),
      body: Center(child: Text('Welcome to the Home Page')),
    );
  }
}

void main() {
  testWidgets('Test basic HomePage with nickname display', (WidgetTester tester) async {

    await tester.pumpWidget(MaterialApp(
      home: MyHomePage(nickname: 'Tomoe'),
    ));

    expect(find.text('Tomoe'), findsOneWidget);

    expect(find.text('Welcome to the Home Page'), findsOneWidget);

    expect(find.byType(AppBar), findsOneWidget);
  });
}
