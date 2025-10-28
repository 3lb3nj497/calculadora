import 'package:flutter_test/flutter_test.dart';
import 'package:calculadora4/calculator.dart';
import 'package:calculadora4/calculator_controller.dart';

void main() {
  group('Operaciones básicas', () {
    test('Suma', () => expect(suma(2, 3), 5));
    test('Resta', () => expect(resta(5, 2), 3));
    test('Multiplicación', () => expect(multiplicacion(3, 4), 12));
    test('División válida', () => expect(division(10, 2), 5));
    test(
      'División por cero',
      () => expect(() => division(10, 0), throwsException),
    );
  });

  group('Evaluador de expresiones', () {
    test('Expresión básica', () {
      final r = evaluarExpresion('2+3');
      expect(r['resultado'], 5.0);
    });

    test('Porcentaje', () {
      final r = evaluarExpresion('50*10%');
      expect(r['resultado'], 5.0);
    });

    test('Expresión inválida', () {
      final r = evaluarExpresion('abc');
      expect(r['resultado'], null);
    });
  });

  group('CalculatorController', () {
    final controller = CalculatorController();

    test('Agregar valor', () {
      controller.agregarValor('2');
      controller.agregarValor('+');
      controller.agregarValor('3');
      expect(controller.expresion, '2+3');
    });

    test('Borrar último', () {
      controller.borrar();
      expect(controller.expresion, '2+');
    });

    test('Limpiar', () {
      controller.limpiar();
      expect(controller.expresion, '');
    });

    test('Calcular resultado', () {
      controller.agregarValor('2');
      controller.agregarValor('+');
      controller.agregarValor('2');
      controller.calcularResultado();
      expect(controller.expresion, '4');
    });
  });

  group('Historial', () {
    late CalculatorController controller;

    setUp(() {
      controller = CalculatorController();
    });

    /// HISTORIAL ALMACENA Y GUARDA OPERACIONES
    test('Almacena correctamente una operación', () {
      controller.agregarValor('2');
      controller.agregarValor('+');
      controller.agregarValor('3');
      controller.calcularResultado();

      expect(controller.historial.length, 1);
      final registro = controller.historial.first;
      expect(registro['expresion'], '2+3');
      expect(registro['resultado'], '5');
    });

    /// LÍMITE MÁXIMO DE 5 ELEMENTOS EN EL HISTORIAL
    test('No debe superar los 5 elementos', () {
      controller.limpiarHistorial();
      for (int i = 0; i < 6; i++) {
        controller.expresion = '$i+1';
        controller.calcularResultado();
      }
      expect(controller.historial.length, 5);
      expect(controller.historial.first['expresion'], '5+1');
      expect(controller.historial.last['expresion'], '1+1');
    });

    test('Última operación aparece al inicio (orden inverso)', () {
      controller.limpiarHistorial();
      controller.expresion = '1+1';
      controller.calcularResultado();
      controller.expresion = '2+2';
      controller.calcularResultado();

      expect(controller.historial.first['expresion'], '2+2');
      expect(controller.historial.last['expresion'], '1+1');
    });

    test('Limpiar historial vacía la lista', () {
      controller.agregarValor('2');
      controller.agregarValor('+');
      controller.agregarValor('2');
      controller.calcularResultado();

      controller.limpiarHistorial();
      expect(controller.historial.isEmpty, true);
    });
  });
}
