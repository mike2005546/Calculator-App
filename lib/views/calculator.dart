import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../utils/extensions.dart';
import '../function/calculator_logic.dart';
import 'buttons.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  static String question = '';
  static String answer = '';

  @override
  State<CalculatorPage> createState() => _CalculatorState();
}

class _CalculatorState extends State<CalculatorPage> {

  final List<String> buttons = [
    'C', 'DEL', '%', '÷',
    '7', '8', '9', '×',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '±', '0', '.', '='
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var height = 30.0;
      if (constraints.isMobile) {
        height = MediaQuery.of(context).viewPadding.top;
      }
      return Scaffold(
        backgroundColor: Colors.deepPurple.shade100,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: AutoSizeText(
                        CalculatorPage.question,
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontSize: 80),
                        minFontSize: 30,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: AutoSizeText(
                        CalculatorPage.answer,
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontSize: 60),
                        minFontSize: 40,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: buttons.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1.0
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (buttons[index] == '±') {
                        return CalculatorButton(
                          buttonText: buttons[index],
                          buttonColor: Colors.deepPurple.shade200,
                          textColor: Colors.white,
                          buttonTapped: () {
                            setState(() {
                              input(context, buttons[index]);
                            });
                          },
                        );
                      } else {
                        return CalculatorButton(
                          buttonText: buttons[index],
                          buttonColor: isOperator(buttons[index])
                              ? Colors.deepPurple
                              : Colors.deepPurple.shade50,
                          textColor: isOperator(buttons[index])
                              ? Colors.white
                              : Colors.deepPurple,
                          buttonTapped: () {
                            setState(() {
                              input(context, buttons[index]);
                            });
                          },
                        );
                      }
                    }
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
