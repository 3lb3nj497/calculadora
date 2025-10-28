import 'package:flutter_test/flutter_test.dart';
import 'package:calculadora4/calculator.dart';

void main() {
  group('Evaluador de expresiones', () {
    test('Expresión simple', () {
      final result = evaluarExpresion('2+3');
      expect(result['resultado'], 5.0);
      expect(result['error'], null);
    });

    test('Expresión con precedencia', () {
      final result = evaluarExpresion('2+3*4');
      expect(result['resultado'], 14.0);
    });

    test('Porcentaje', () {
      final result = evaluarExpresion('50*10%');
      expect(result['resultado'], 5.0);
    });

    test('Expresión incompleta', () {
      final result = evaluarExpresion('2+');
      expect(result['resultado'], null);
      expect(result['error'], 'Expresión incompleta');
    });

    test('Expresión inválida', () {
      final result = evaluarExpresion('abc');
      expect(result['resultado'], null);
      expect(result['error'], 'Expresión inválida');
    });
  });

  group('Formateo de números', () {
    test('Número entero', () {
      expect(formatearNumero(5.0), '5');
    });

    test('Número decimal', () {
      expect(formatearNumero(5.123456), '5.123456');
    });

    test('Eliminar ceros finales', () {
      expect(formatearNumero(5.100000), '5.1');
    });
  });
}
