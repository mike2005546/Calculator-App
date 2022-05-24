import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final void Function() buttonTapped;

  const CalculatorButton(
      {Key? key,
      required this.buttonText,
      required this.buttonColor,
      required this.textColor,
      required this.buttonTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          child: InkWell(
            splashFactory: InkRipple.splashFactory,
            onTap: buttonTapped,
            child: Ink(
              color: buttonColor,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  child: Text(
                    buttonText,
                    style: TextStyle(fontSize: 500, color: textColor),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
