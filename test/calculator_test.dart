import 'package:flutter_test/flutter_test.dart';
import 'package:calculadora4/controllers/calculator_controller.dart';

void main() {
  late CalculatorController controller;

  setUp(() {
    controller = CalculatorController();
  });

  /// Operaciones básicas
  group('Operaciones básicas', () {
    test('Suma básica', () {
      controller.agregarValor('2');
      controller.agregarValor('+');
      controller.agregarValor('3');
      controller.calcularResultado();
      expect(controller.expresion, '5');
    });

    test('Resta básica', () {
      controller.agregarValor('5');
      controller.agregarValor('-');
      controller.agregarValor('2');
      controller.calcularResultado();
      expect(controller.expresion, '3');
    });

    test('Multiplicación básica', () {
      controller.agregarValor('3');
      controller.agregarValor('*');
      controller.agregarValor('4');
      controller.calcularResultado();
      expect(controller.expresion, '12');
    });

    test('División válida', () {
      controller.agregarValor('10');
      controller.agregarValor('/');
      controller.agregarValor('2');
      controller.calcularResultado();
      expect(controller.expresion, '5');
    });

    test('División por cero', () {
      controller.expresion = '5/0';
      controller.calcularResultado();
      expect(controller.resultadoPrevio, '');
    });
  });

  /// Edición de expresión
  group('Expresión y edición', () {
    test('Agregar valores a la expresión', () {
      controller.agregarValor('2');
      controller.agregarValor('+');
      controller.agregarValor('3');
      expect(controller.expresion, '2+3');
    });

    test('Borrar último valor', () {
      controller.agregarValor('2');
      controller.agregarValor('+');
      controller.agregarValor('3');
      controller.borrar();
      expect(controller.expresion, '2+');
    });

    test('Limpiar expresión', () {
      controller.agregarValor('5');
      controller.limpiar();
      expect(controller.expresion, '');
    });
  });

  /// Historial
  group('Historial', () {
    test('Almacena correctamente una operación', () {
      controller.agregarValor('2');
      controller.agregarValor('+');
      controller.agregarValor('3');
      controller.calcularResultado();
      expect(controller.historial.length, 1);
      expect(controller.historial.first['operacion'], '2+3');
      expect(controller.historial.first['resultado'], '5');
    });

    test('No supera los 5 elementos', () {
      controller.limpiarHistorial();
      for (int i = 0; i < 6; i++) {
        controller.expresion = '$i+1';
        controller.calcularResultado();
      }
      expect(controller.historial.length, 5);
    });
  });

  /// Guardado de operaciones
  group('Guardar operación', () {
    test('Guardar operación con categoría y nombre', () {
      controller.agregarValor('3');
      controller.agregarValor('+');
      controller.agregarValor('2');
      controller.calcularResultado();
      controller.guardarOperacion(
        categoria: 'Gastos',
        nombre: 'Compra mercado',
      );
      final ultima = controller.operacionesGuardadas.last;
      expect(ultima['categoria'], 'Gastos');
      expect(ultima['nombre'], 'Compra mercado');
    });

    test('Guardar operación sin nombre asigna por defecto', () {
      controller.agregarValor('5');
      controller.agregarValor('+');
      controller.agregarValor('5');
      controller.calcularResultado();
      controller.guardarOperacion(categoria: 'Gastos', nombre: '');
      final ultima = controller.operacionesGuardadas.last;
      expect(ultima['nombre'], 'Operación sin nombre');
    });
  });
}
