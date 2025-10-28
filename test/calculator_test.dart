import 'package:calculadora4/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Suma básica funciona', (WidgetTester tester) async {
    await tester.pumpWidget(CalculadoraApp());
    await tester.tap(find.text('2'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('3'));
    await tester.tap(find.text('='));
    await tester.pump();
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('División funciona', (WidgetTester tester) async {
    await tester.pumpWidget(CalculadoraApp());
    await tester.tap(find.text('9'));
    await tester.tap(find.text('-'));
    await tester.tap(find.text('1'));
    await tester.tap(find.text('='));
    await tester.pump();
    expect(find.text('8'), findsOneWidget);
  });
}
