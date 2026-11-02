// Smoke test del flujo: la primera pantalla ofrece iniciar sesión o registrarse.
//
// (El test genérico del contador que trae el template de Flutter ya no aplica
// a esta app.)

import 'package:flutter_test/flutter_test.dart';

import 'package:skillship/main.dart';

void main() {
  testWidgets('La pantalla de ingreso muestra las dos opciones', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Iniciar Sesion'), findsOneWidget);
    expect(find.text('Registrarse'), findsOneWidget);
  });
}
