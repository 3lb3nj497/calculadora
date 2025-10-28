double suma(double a, double b) {
  return a + b;
}

double resta(double a, double b) {
  return a - b;
}

double multiplica(double a, double b) {
  return a * b;
}

double division(double a, double b) {
  if (b == 0) throw Exception('Dividido en 0, no se puede realizar');
  return a / b;
}
