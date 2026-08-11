import 'package:flutter_test/flutter_test.dart';

import 'package:charitask/app/app.dart';

void main() {
  testWidgets('ChariTask app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const ChariTaskApp());

    expect(find.byType(ChariTaskApp), findsOneWidget);
  });
}
