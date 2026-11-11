import 'package:flutter_test/flutter_test.dart';

import 'package:ldsw_movisee_pokeapi/main.dart';

void main() {
  testWidgets('La pantalla de inicio muestra el nombre de la app',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Movisee'), findsOneWidget);
    expect(find.text('¡Atrápalos ya!'), findsOneWidget);
  });
}
