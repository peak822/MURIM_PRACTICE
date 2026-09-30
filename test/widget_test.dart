import 'package:flutter_test/flutter_test.dart';
import 'package:murim_app/presentation/widgets/wuxia_badge.dart';
import 'package:murim_app/presentation/widgets/wuxia_button.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('WuxiaButton renders text and triggers callback', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WuxiaButton(
            text: 'ทะลวงด่าน',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('ทะลวงด่าน'), findsOneWidget);

    await tester.tap(find.text('ทะลวงด่าน'));
    await tester.pump();

    expect(tapped, true);
  });

  testWidgets('WuxiaBadge renders difficulty and Qi values', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              WuxiaBadge.difficulty(3),
              WuxiaBadge.qiReward(50),
            ],
          ),
        ),
      ),
    );

    expect(find.text('ระดับสูง'), findsOneWidget);
    expect(find.text('+50 Qi'), findsOneWidget);
  });
}
