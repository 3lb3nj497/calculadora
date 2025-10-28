import 'package:math_expressions/math_expressions.dart';

// 🔹 Operaciones básicas
double suma(double a, double b) => a + b;
double resta(double a, double b) => a - b;
double multiplicacion(double a, double b) => a * b;
double division(double a, double b) {
  if (b == 0) throw Exception('División por cero');
  return a / b;
}

double porcentaje(double a, double b) => (a * b) / 100;

// 🔹 Evaluador principal
Map<String, dynamic> evaluarExpresion(String expr) {
  try {
    expr = expr.trim();
    if (expr.isEmpty) return {'resultado': null, 'error': null};

    // ✅ Reemplazar porcentajes: 50*10% → 50*(10/100)
    expr = expr.replaceAllMapped(
      RegExp(r'(\d+(\.\d+)?)%'),
      (m) => '(${m.group(1)}/100)',
    );

    // ✅ Limpieza básica
    expr = expr.replaceAll('=', '').replaceAll(RegExp(r'\.\.'), '.');
    if (expr.startsWith('.')) expr = '0$expr';
    if (expr.endsWith('.')) expr = expr.substring(0, expr.length - 1);

    // Evitar evaluar si termina con operador
    if (RegExp(r'[+\-*/.(]$').hasMatch(expr)) {
      return {'resultado': null, 'error': 'Expresión incompleta'};
    }

    // ✅ Analizador correcto
    Parser parser = Parser();
    Expression exp = parser.parse(expr);
    ContextModel cm = ContextModel();
    final result = exp.evaluate(EvaluationType.REAL, cm);

    if (result.isNaN || result.isInfinite) {
      return {'resultado': null, 'error': 'Resultado inválido'};
    }

    return {'resultado': result.toDouble(), 'error': null};
  } catch (e) {
    if (e.toString().contains('Division by zero')) {
      return {'resultado': null, 'error': 'División por cero'};
    }
    return {'resultado': null, 'error': 'Expresión inválida'};
  }
}

// 🔢 Formatear número sin decimales innecesarios
String formatearNumero(double num) {
  if (num == num.roundToDouble()) {
    return num.toInt().toString();
  } else {
    return num.toStringAsFixed(
      6,
    ).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }
}
