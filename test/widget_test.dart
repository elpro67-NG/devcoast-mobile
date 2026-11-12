import 'package:flutter_test/flutter_test.dart';
import 'package:devcoast_mobile/app.dart';

void main() {
  testWidgets('Muestra pantalla inicial DevCoast', (tester) async {
    await tester.pumpWidget(const DevCoastApp());
    expect(find.text('DevCoast'), findsWidgets);
  });
}
