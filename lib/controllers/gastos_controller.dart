class GastosController {
  static final List<Map<String, dynamic>> _gastos = [];

  static List<Map<String, dynamic>> get gastos => _gastos;

  static void agregarGasto(Map<String, dynamic> gasto) {
    _gastos.insert(0, gasto);
  }

  static void eliminarGasto(int index) {
    _gastos.removeAt(index);
  }

  static void limpiarGastos() {
    _gastos.clear();
  }

  static double get total {
    return _gastos.fold(
      0.0,
      (sum, item) => sum + double.tryParse(item['resultado'].toString())!,
    );
  }

  /// ✍️ Nuevo: Editar nombre de un gasto existente
  static void editarNombre(int index, String nuevoNombre) {
    if (index >= 0 && index < _gastos.length) {
      _gastos[index]['nombre'] = nuevoNombre;
    }
  }
}
