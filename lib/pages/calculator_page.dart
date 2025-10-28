import 'package:flutter/material.dart';
import '../controllers/calculator_controller.dart';
import '../widgets/calc_button.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final controller = CalculatorController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// 🔙 Borrar según posición del cursor (si no hay selección, borra al final)
  void _borrarEnPosicion() {
    var text = _textController.text;
    var sel = _textController.selection;

    // Si el campo no tiene foco o la selección no es válida, llevar cursor al final
    if (!_focusNode.hasFocus || sel.start < 0) {
      sel = TextSelection.collapsed(offset: text.length);
    }

    // Nada que borrar
    if (text.isEmpty || sel.start == 0) return;

    final newText = text.replaceRange(sel.start - 1, sel.start, '');
    final newOffset = sel.start - 1;

    _textController.text = newText;
    _textController.selection = TextSelection.collapsed(offset: newOffset);

    controller.expresion = newText;
    controller.actualizarResultadoPrevio();
  }

  /// 💾 Diálogo para guardar operación (igual que tenías)
  void _mostrarDialogoGuardar() {
    final TextEditingController nombreController = TextEditingController();
    String categoriaSeleccionada = 'Gastos';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Guardar operación'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: categoriaSeleccionada,
                items: const [
                  DropdownMenuItem(value: 'Gastos', child: Text('Gastos')),
                  DropdownMenuItem(value: 'Ingresos', child: Text('Ingresos')),
                  DropdownMenuItem(value: 'Pagos', child: Text('Pagos')),
                ],
                onChanged: (value) {
                  setState(() => categoriaSeleccionada = value!);
                },
                decoration: const InputDecoration(
                  labelText: 'Seleccionar categoría',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre / Descripción',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.historial.isEmpty &&
                    controller.resultadoPrevio.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('⚠️ Primero realiza un cálculo.'),
                    ),
                  );
                  return;
                }

                controller.guardarOperacion(
                  categoria: categoriaSeleccionada,
                  nombre: nombreController.text.trim().isEmpty
                      ? 'Operación sin nombre'
                      : nombreController.text.trim(),
                );

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Operación guardada')),
                );
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final botonesFila1 = ['C', '⌫', '%', '/'];
    final botonesFila2 = ['7', '8', '9', '*'];
    final botonesFila3 = ['4', '5', '6', '-'];
    final botonesFila4 = ['1', '2', '3', '+'];
    final botonesFila5 = ['0', '.', '='];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calculadora'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Guardar operación',
            onPressed: _mostrarDialogoGuardar,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 📜 Historial reutilizable
            if (controller.historial.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: controller.historial
                      .map(
                        (item) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _textController.text = item['operacion'];
                              _textController.selection =
                                  TextSelection.collapsed(
                                    offset: _textController.text.length,
                                  );
                              _focusNode.requestFocus(); // asegura foco
                              controller.expresion = item['operacion'];
                              controller.actualizarResultadoPrevio();
                            });
                          },
                          child: Text(
                            "${item['operacion']} = ${item['resultado']}",
                            style: const TextStyle(color: Colors.grey),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

            // 🧮 Pantalla editable
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 36, color: Colors.white),
                      cursorColor: Colors.greenAccent,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          controller.expresion = value;
                          controller.actualizarResultadoPrevio();
                        });
                      },
                      onTap: () {
                        // Asegura foco y mantiene selección del usuario
                        if (!_focusNode.hasFocus) _focusNode.requestFocus();
                      },
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

            // ⌨️ Botonera
            Column(
              children: [
                _buildRow(botonesFila1),
                _buildRow(botonesFila2),
                _buildRow(botonesFila3),
                _buildRow(botonesFila4),
                _buildRow(botonesFila5),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<String> botones) {
    return Row(
      children: botones.map((texto) {
        return CalcButton(
          texto: texto,
          onPressed: (valor) {
            setState(() {
              // Siempre aseguramos foco en el campo antes de operar
              if (!_focusNode.hasFocus) {
                _focusNode.requestFocus();
              }

              if (valor == 'C') {
                controller.limpiar();
                _textController.text = controller.expresion;
                _textController.selection = const TextSelection.collapsed(
                  offset: 0,
                );
              } else if (valor == '⌫') {
                _borrarEnPosicion();
              } else if (valor == '=') {
                controller.calcularResultado();
                _textController.text = controller.expresion;
                _textController.selection = TextSelection.collapsed(
                  offset: _textController.text.length,
                );
              } else {
                // Inserción en la posición del cursor
                final text = _textController.text;
                var sel = _textController.selection;

                // Si la selección no es válida, colocar al final
                if (sel.start < 0) {
                  sel = TextSelection.collapsed(offset: text.length);
                }

                final newText = text.replaceRange(sel.start, sel.end, valor);
                final newOffset = sel.start + valor.length;

                _textController.text = newText;
                _textController.selection = TextSelection.collapsed(
                  offset: newOffset,
                );

                controller.expresion = newText;
                controller.actualizarResultadoPrevio();
              }
            });
          },
        );
      }).toList(),
    );
  }
}
