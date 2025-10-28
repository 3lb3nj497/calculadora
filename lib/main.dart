import 'package:flutter/material.dart';
import 'calculator.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CalculadoraScreen(),
    );
  }
}

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  String expresion = '';
  String resultadoPrevio = '';
  bool mostrarResultadoFinal = false;

  void agregarValor(String valor) {
    setState(() {
      if (mostrarResultadoFinal && RegExp(r'[0-9]').hasMatch(valor)) {
        expresion = valor;
        mostrarResultadoFinal = false;
      } else if (mostrarResultadoFinal && !RegExp(r'[0-9]').hasMatch(valor)) {
        mostrarResultadoFinal = false;
        expresion += valor;
      } else {
        expresion += valor;
      }

      final eval = evaluarExpresion(expresion);
      resultadoPrevio = eval['resultado'] != null
          ? formatearNumero(eval['resultado'])
          : '';
    });
  }

  void limpiar() {
    setState(() {
      expresion = '';
      resultadoPrevio = '';
      mostrarResultadoFinal = false;
    });
  }

  void borrar() {
    setState(() {
      if (expresion.isNotEmpty) {
        expresion = expresion.substring(0, expresion.length - 1);
        mostrarResultadoFinal = false;
        if (expresion.isEmpty) {
          resultadoPrevio = '';
        } else {
          final eval = evaluarExpresion(expresion);
          resultadoPrevio = eval['resultado'] != null
              ? formatearNumero(eval['resultado'])
              : '';
        }
      }
    });
  }

  void calcularResultado() {
    setState(() {
      final eval = evaluarExpresion(expresion);
      if (eval['resultado'] != null) {
        expresion = formatearNumero(eval['resultado']);
        resultadoPrevio = '';
        mostrarResultadoFinal = true;
      } else {
        expresion = eval['error'] ?? 'Error';
        resultadoPrevio = '';
      }
    });
  }

  Widget buildBoton(String texto, {Color? color, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[850],
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            if (texto == 'C') {
              limpiar();
            } else if (texto == '⌫') {
              borrar();
            } else if (texto == '=') {
              calcularResultado();
            } else {
              agregarValor(texto);
            }
          },
          child: Text(
            texto,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      expresion,
                      style: const TextStyle(fontSize: 36, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      resultadoPrevio,
                      style: const TextStyle(fontSize: 28, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    buildBoton('C', color: Colors.red),
                    buildBoton('⌫', color: Colors.orangeAccent),
                    buildBoton('%', color: Colors.blueGrey),
                    buildBoton('/', color: Colors.blueGrey),
                  ],
                ),
                Row(
                  children: [
                    buildBoton('7'),
                    buildBoton('8'),
                    buildBoton('9'),
                    buildBoton('*', color: Colors.blueGrey),
                  ],
                ),
                Row(
                  children: [
                    buildBoton('4'),
                    buildBoton('5'),
                    buildBoton('6'),
                    buildBoton('-', color: Colors.blueGrey),
                  ],
                ),
                Row(
                  children: [
                    buildBoton('1'),
                    buildBoton('2'),
                    buildBoton('3'),
                    buildBoton('+', color: Colors.blueGrey),
                  ],
                ),
                Row(
                  children: [
                    buildBoton('0', flex: 2),
                    buildBoton('.'),
                    buildBoton('=', color: Colors.green, flex: 2),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
