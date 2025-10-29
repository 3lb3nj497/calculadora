import 'package:intl/intl.dart';
import 'gastos_controller.dart';

class CalculatorController {
  String expresion = '';
  String resultadoPrevio = '';

  /// 📝 Historial corto
  final List<Map<String, dynamic>> historial = [];

  /// 🧾 Operaciones guardadas
  final List<Map<String, dynamic>> operacionesGuardadas = [];

  /// ➕ Agregar valor a la expresión
  void agregarValor(String valor) {
    expresion += valor;
    actualizarResultadoPrevio();
  }

  /// ⌫ Borrar último carácter
  void borrar() {
    if (expresion.isNotEmpty) {
      expresion = expresion.substring(0, expresion.length - 1);
      actualizarResultadoPrevio();
    }
  }

  /// 🧼 Limpiar pantalla
  void limpiar() {
    expresion = '';
    resultadoPrevio = '';
  }

  /// 🧮 Calcular resultado
  void calcularResultado() {
    final r = _evaluarExpresion(expresion);
    if (r['resultado'] != null) {
      _guardarEnHistorial(expresion, r['resultado']);
      expresion = _formatearNumero(r['resultado']);
      resultadoPrevio = expresion;
    }
  }

  /// 🧠 Evaluador de expresiones (compatible con tests antiguos)
  Map<String, dynamic> _evaluarExpresion(String expr) {
    if (expr.isEmpty) return {'resultado': null, 'error': null};
    try {
      final sanitized = expr.replaceAll('%', '/100');
      final parser = RegExp(r'([\d.]+|[-+*/])');
      final tokens = parser
          .allMatches(sanitized)
          .map((e) => e.group(0)!)
          .toList();
      if (tokens.isEmpty)
        return {'resultado': null, 'error': 'Expresión inválida'};

      double resultado = double.parse(tokens[0]);
      for (int i = 1; i < tokens.length; i += 2) {
        final op = tokens[i];
        final num = double.parse(tokens[i + 1]);
        switch (op) {
          case '+':
            resultado += num;
            break;
          case '-':
            resultado -= num;
            break;
          case '*':
            resultado *= num;
            break;
          case '/':
            if (num == 0) throw Exception('División por cero');
            resultado /= num;
            break;
        }
      }
      return {'resultado': resultado, 'error': null};
    } catch (e) {
      if (e.toString().contains('División por cero')) {
        return {'resultado': null, 'error': 'División por cero'};
      }
      return {'resultado': null, 'error': 'Expresión inválida'};
    }
  }

  /// 📜 Guardar en historial corto
  void _guardarEnHistorial(String operacion, double resultado) {
    final registro = {
      'operacion': operacion,
      'resultado': _formatearNumero(resultado),
      'fecha': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
    };

    historial.insert(0, registro);
    if (historial.length > 5) historial.removeLast();
  }

  /// 💾 Guardar operación en categoría
  void guardarOperacion({required String categoria, required String nombre}) {
    if (expresion.isEmpty && resultadoPrevio.isEmpty) return;

    final ultimaOperacion = historial.isNotEmpty
        ? historial.first['operacion']
        : expresion;
    final nombreFinal = nombre.trim().isEmpty ? 'Operación sin nombre' : nombre;

    final registro = {
      'categoria': categoria,
      'nombre': nombreFinal,
      'operacion': ultimaOperacion,
      'resultado': resultadoPrevio.isNotEmpty ? resultadoPrevio : expresion,
      'fecha': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
    };

    historial.insert(0, registro);
    if (historial.length > 5) historial.removeLast();

    operacionesGuardadas.add(registro);

    // 📌 Si es gasto, también guardarlo en GastosController
    if (categoria == 'Gastos') {
      final gasto = {
        'nombre': nombreFinal,
        'operacion': registro['operacion'],
        'resultado': registro['resultado'],
        'fecha': registro['fecha'],
      };
      GastosController.agregarGasto(gasto);
    }
  }

  /// 🧼 Limpiar historial
  void limpiarHistorial() {
    historial.clear();
    operacionesGuardadas.clear();
  }

  /// 🔁 Actualizar resultado previo en tiempo real
  void actualizarResultadoPrevio() {
    final r = _evaluarExpresion(expresion);
    resultadoPrevio = (r['resultado'] != null)
        ? _formatearNumero(r['resultado'])
        : '';
  }

  /// 🧮 Formatear números
  String _formatearNumero(double num) {
    if (num == num.roundToDouble()) {
      return num.toInt().toString();
    } else {
      return num.toStringAsFixed(
        6,
      ).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
    }
  }
}
