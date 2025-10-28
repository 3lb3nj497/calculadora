import 'package:flutter/material.dart';
import 'package:calculadora4/calculator_controller.dart';

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
  final controller = CalculatorController();

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
            setState(() {
              if (texto == 'C') {
                controller.limpiar();
              } else if (texto == '⌫') {
                controller.borrar();
              } else if (texto == '=') {
                controller.calcularResultado();
              } else {
                controller.agregarValor(texto);
              }
            });
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
            /// HISTORIAL DE OPERACIONES
            // HISTORIAL - se mostrará justo arriba del resultado
            if (controller.historial.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Encabezado con botón limpiar historial
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Historial',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.limpiarHistorial();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: const Icon(
                              Icons.delete_forever,
                              color: Colors.redAccent,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    /*// Operaciones anteriores (si existen)
                    ...controller.historial.skip(1).map((op) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '${op['expresion']} = ${op['resultado']}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      );*/
                    // Operaciones anteriores (interactivas)
                    ...controller.historial.skip(1).map((op) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            controller.expresion = op['expresion']!;
                            controller.mostrarResultadoFinal = false;
                            controller.resultadoPrevio = op['resultado']!;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '${op['expresion']} = ${op['resultado']}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

            ///PANTALLA DE LA CALCULADORA
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      controller.expresion,
                      style: const TextStyle(fontSize: 36, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      controller.resultadoPrevio,
                      style: const TextStyle(fontSize: 28, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            // Botones de la calculadora
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
