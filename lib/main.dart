import 'package:flutter/material.dart';
import 'calculator.dart';

void main() {
  runApp(CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: _CalculatorScreen());
  }
}

class _CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<_CalculatorScreen> {
  String display = '0';
  double num1 = 0.0;
  double num2 = 0.0;
  String operation = '';

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        display = '0';
        num1 = 0.0;
        num2 = 0.0;
        operation = '';
      } else if (value == '+' || value == '-' || value == '*' || value == '/') {
        operation = value;
        num1 = double.tryParse(display) ?? 0.0;
        display = '0';
      } else if (value == '=') {
        num2 = double.tryParse(display) ?? 0.0;
        double result = 0.0;
        //try {
        switch (operation) {
          case '+':
            result = suma(num1.toDouble(), num2.toDouble()).toDouble();
            break;
          case '-':
            result = resta(num1, num2);
            break;
          case '*':
            result = multiplica(num1, num2);
            break;
          case '/':
            result = division(num1, num2);
            break;
          default:
            result = 0.0;
        }
        display = result.toString();
        /*} catch (e) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(
                  e.toString(),
                ), // Mostrará "Division en 0, no se puede realizar"
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
          return; // No cambies display
        }*/
        operation = '';
      } else {
        display = display == '0' ? value : display + value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculadora TDD')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(20),
              child: Text(display, style: TextStyle(fontSize: 48)),
            ),
          ),
          Row(
            children: [
              buildButton('7'),
              buildButton('8'),
              buildButton('9'),
              buildButton('/'),
            ],
          ),
          Row(
            children: [
              buildButton('4'),
              buildButton('5'),
              buildButton('6'),
              buildButton('*'),
            ],
          ),
          Row(
            children: [
              buildButton('1'),
              buildButton('2'),
              buildButton('3'),
              buildButton('-'),
            ],
          ),
          Row(
            children: [
              buildButton('0'),
              buildButton('C'),
              buildButton('='),
              buildButton('+'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(String text) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => onButtonPressed(text),
        child: Text(text, style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
