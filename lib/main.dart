import 'package:flutter/material.dart';

const operatorColor = Color(0xff272727);
const buttonColor = Color.fromARGB(255, 98, 98, 98);
const orangeColor = Color(0xffD9802E);

void main() {
  runApp(MaterialApp(home: Calculator()));
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String input = "";
  String output = "";
  bool hideInput = false;
  double outputSize = 3.0;
  bool hasOperator = false;

  onButtonClick(String value) {
    if (value == "AC") {
      input = "";
      output = "";
      hasOperator = false;
    } else if (value == "Back") {
      if (input.isNotEmpty) {
        String lastChar = input[input.length - 1];
        input = input.substring(0, input.length - 1);
        
        // Reset operator flag if an operator was removed
        if ("+-*/".contains(lastChar)) {
          hasOperator = false;
        }
      }
    } else if (value == "=") {
      if (input.isNotEmpty) {
        try {
          output = evaluateExpression(input).toString();
          input = output;
          hideInput = true;
          outputSize = 52;
          hasOperator = false;
        } catch (e) {
          output = "Cannot divide by 0";
        }
      }
    } else {
      // Allow only one operator and only in the middle
      if ("+-*/".contains(value)) {
        if (input.isNotEmpty && !hasOperator) {
          input += value;
          hasOperator = true;
        }
      } else {
        // Ensure no more than two numbers
        List<String> parts = input.split(RegExp(r'[\+\-\*/]'));
        if (parts.length < 2 || parts[1].isEmpty) {
          input += value;
        }
      }
      hideInput = false;
      outputSize = 34;
    }

    setState(() {});
  }

  int evaluateExpression(String expression) {
    expression = expression.replaceAll("x", "*");

    RegExp regex = RegExp(r'^(\d+)\s*([\+\-\*/])\s*(\d+)$');
    Match? match = regex.firstMatch(expression);

    if (match == null) throw Exception("Invalid expression");

    int num1 = int.parse(match.group(1)!);
    String operator = match.group(2)!;
    int num2 = int.parse(match.group(3)!);

    switch (operator) {
      case "+":
        return num1 + num2;
      case "-":
        return num1 - num2;
      case "*":
        return num1 * num2;
      case "/":
        if (num2 == 0) throw Exception("Division by zero");
        return num1 ~/ num2;
      default:
        throw Exception("Unknown operator");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    hideInput ? "" : input,
                    style: TextStyle(fontSize: 48, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    output,
                    style: TextStyle(fontSize: outputSize, color: Colors.white),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Row(
            children: [
              button(text: "AC", buttonBgColor: operatorColor, tColor: orangeColor),
              button(text: "Back", buttonBgColor: operatorColor, tColor: orangeColor),
              button(text: "/", buttonBgColor: operatorColor, tColor: orangeColor),
            ],
          ),
          Row(
            children: [
              button(text: "7"),
              button(text: "8"),
              button(text: "9"),
              button(text: "x", tColor: orangeColor, buttonBgColor: operatorColor),
            ],
          ),
          Row(
            children: [
              button(text: "4"),
              button(text: "5"),
              button(text: "6"),
              button(text: "-", tColor: orangeColor, buttonBgColor: operatorColor),
            ],
          ),
          Row(
            children: [
              button(text: "1"),
              button(text: "2"),
              button(text: "3"),
              button(text: "+", tColor: orangeColor, buttonBgColor: operatorColor),
            ],
          ),
          Row(
            children: [
              button(text: "0"),
              button(text: "=", buttonBgColor: orangeColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget button({required String text, Color tColor = Colors.white, Color buttonBgColor = buttonColor}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: buttonBgColor,
            padding: const EdgeInsets.all(22),
          ),
          onPressed: () => onButtonClick(text),
          child: Text(
            text,
            style: TextStyle(fontSize: 18, color: tColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
