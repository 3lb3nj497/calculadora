import 'package:calculadora4/calculator.dart';

class CalculatorController {
  String expresion = '';
  String resultadoPrevio = '';
  bool mostrarResultadoFinal = false;

  /// Historial de operaciones (máx 5)
  final List<Map<String, String>> historial = [];

  bool _terminaEnOperador(String s) => RegExp(r'[+\-*/.(]$').hasMatch(s);

  String _sanearParaEvaluar(String s) {
    while (s.isNotEmpty && _terminaEnOperador(s)) {
      s = s.substring(0, s.length - 1);
    }
    return s;
  }

  void _actualizarPreview() {
    final eval = evaluarExpresion(expresion);
    resultadoPrevio = eval['resultado'] != null
        ? formatearNumero(eval['resultado'])
        : '';
  }

  void agregarValor(String valor) {
    if (mostrarResultadoFinal && RegExp(r'[0-9]').hasMatch(valor)) {
      expresion = valor;
      mostrarResultadoFinal = false;
    } else if (mostrarResultadoFinal && !RegExp(r'[0-9]').hasMatch(valor)) {
      mostrarResultadoFinal = false;
      expresion += valor;
    } else {
      expresion += valor;
    }
    _actualizarPreview();
  }

  void limpiar() {
    expresion = '';
    resultadoPrevio = '';
    mostrarResultadoFinal = false;
  }

  void borrar() {
    if (expresion.isNotEmpty) {
      expresion = expresion.substring(0, expresion.length - 1);
      mostrarResultadoFinal = false;
      if (expresion.isEmpty) {
        resultadoPrevio = '';
      } else {
        _actualizarPreview();
      }
    }
  }

  void limpiarHistorial() {
    historial.clear();
  }

  void calcularResultado() {
    String expr = expresion.trim();

    if (_terminaEnOperador(expr)) {
      expr = _sanearParaEvaluar(expr);
    }

    if (expr.isEmpty && resultadoPrevio.isNotEmpty) {
      expresion = resultadoPrevio;
      _guardarEnHistorial(original: expresion, resultado: expresion);
      resultadoPrevio = '';
      mostrarResultadoFinal = true;
      return;
    }

    final eval = evaluarExpresion(expr);
    if (eval['resultado'] != null) {
      final resStr = formatearNumero(eval['resultado']);
      _guardarEnHistorial(original: expresion, resultado: resStr);
      expresion = resStr;
      resultadoPrevio = '';
      mostrarResultadoFinal = true;
    } else {
      expresion = eval['error'] ?? 'Error';
      resultadoPrevio = '';
      mostrarResultadoFinal = true;
    }
  }

  void _guardarEnHistorial({
    required String original,
    required String resultado,
  }) {
    if (original.isEmpty) return;
    historial.insert(0, {'expresion': original, 'resultado': resultado});
    if (historial.length > 5) historial.removeLast();
  }
}
