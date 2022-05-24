import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

import '../utils/extensions.dart';
import '../views/calculator.dart';

List<String> listPMTD = ['+', '-', '×', '÷'];
List<String> listOperator = ['C', 'DEL', '%', '='];
List<String> listNumber = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

String question = '';

bool questionEmpty = false;

// Declare equal'=' is pressed or not
// If equal'=' have pressed, question need to be cleared once
// Then user can calculate a new calculation
bool equalPressed = false;

void updateQuestionEmpty(String str) => str.isEmpty ? questionEmpty = true : questionEmpty = false;

bool isNumber(String buttonText) => listNumber.contains(buttonText);

bool isOperator(String buttonText) => (listPMTD.contains(buttonText) || listOperator.contains(buttonText));

String getFirstChar(String str) => str.substring(0, 1);

String getLastChar(String str) => str.substring(str.length - 1);

bool checkLastCharIsNumber(String str) => isNumber(getLastChar(str));

bool checkLastCharIsOperator(String str) => listPMTD.contains(getLastChar(str));

// EXAMPLE: split number to [1, 2.5] from '1+2.5'
// And check the last number contains '.' or not
bool checkIfDotAlreadyExistInNumber(String str) => str.multiSplit(listPMTD).last.contains('.');

void clearAll() {
  question = '';
  CalculatorPage.answer = '';
}

String delete(String str, int deleteLength) => str.substring(0, str.length - deleteLength);

// context for showing SnackBar
void input(BuildContext context, String buttonText) {

  question = CalculatorPage.question;

  // check equal'=' have pressed or not
  if (equalPressed) {

    // Operator['+', '-', '×', '÷', '%', '.']
    if (buttonText == '%' || buttonText == '.' || listPMTD.contains(buttonText)) {
      equalPressed = false;
    }

    // Number
    else if (isNumber(buttonText)) {
      question = '';
      equalPressed = false;
    }
  }

  // Check question is empty or not
  updateQuestionEmpty(question);

  if (questionEmpty) {
    // If question is empty

    // Four actions can be done when question is empty
    // Dot['.'], ClearAll function['C'] and numbers[0-9] can be input anytime

    switch (buttonText) {

      case 'C':
        clearAll();
        break;

      case '.':
        question = "0.";
        break;

      case '±':
        // Add '-' to the question
        question = '-';
        break;

      default:
        if (isNumber(buttonText)) {
          question += buttonText;
        }
        break;
    }

  } else {
    // If question is not empty

    switch (buttonText) {

      case 'C':
        clearAll();
        break;

      case 'DEL':
        question = delete(question, 1);
        break;

      case '.':
        // Dot['.'] can be entered after a number
        // And after the operator['+', '-', '×', '÷']

        // Check last char is number or not
        if (checkLastCharIsNumber(question)) {

          // Check last number contain dot or not
          if (!checkIfDotAlreadyExistInNumber(question)) {

            // Add '.' to question
            question += buttonText;
          }
        }

        // If it is entered after operator['+', '-', '×', '÷']
        else if (checkLastCharIsOperator(question)) {

          // Add '0.' to question
          question += '0.';
        }

        break;

      case '%':
        // '%' can be entered after number
        if (checkLastCharIsNumber(question)) {

          // Add '%' to question
          question += buttonText;
        }
        break;

      case '=':
        try {
          // Move the answer to the question so the user can keep calculating
          question = calculate(question);

          // And clear the answer
          CalculatorPage.answer = '';

          // Declare equalPressed to True
          equalPressed = true;
        } catch(_) {
          showSnackBar(context, 'Invalid Formula');
        }
        break;

      case '±':
        // Two situation
        // Handle the first number or last number
        // If one number only -> first number,
        // else -> last number
        var numberSize = question.multiSplit(listPMTD).length;

        // First check how many numbers are there
        // If one only, check it is negative or not
        if (numberSize == 1) {

          // Check first character is negative or not
          if (getFirstChar(question).contains('-')) {

            // delete '-' at first character
            question = question.substring(1);
          }

          // First character is not '-'
          else {

            // Add '-' to first character
            question = '-$question';
          }
        }

        // If more than one number, handle the last number
        // If it is negative, turn it to positive
        // Use split by number to get last symbol
        else if (numberSize > 1) {

          // Get last symbol position
          int lastSymbolPosition;

          // Get last symbol
          String lastSymbol = question.multiSplit(listNumber + ['%', '.']).last;

          // If last symbol is '+'
          // Replace it with '-'
          if (lastSymbol == '+') {
            lastSymbolPosition = question.lastIndexOf('+');
            question = question.replaceRange(lastSymbolPosition, lastSymbolPosition + 1, '-');
          }

          // If last symbol is '-'
          // Replace it with '+'
          else if (lastSymbol == '-') {
            lastSymbolPosition = question.lastIndexOf('-');
            question = question.replaceRange(lastSymbolPosition, lastSymbolPosition + 1, '+');
          }

          // If last symbol is '×'
          // Replace it with '×-'
          else if (lastSymbol == '×') {
            lastSymbolPosition = question.lastIndexOf('×');
            question = question.replaceRange(lastSymbolPosition, lastSymbolPosition + 1, '×-');
          }

          // If last symbol is '÷'
          // Replace it with '÷-'
          else if (lastSymbol == '÷') {
            lastSymbolPosition = question.lastIndexOf('÷');
            question = question.replaceRange(lastSymbolPosition, lastSymbolPosition + 1, '÷-');
          }

          else if (lastSymbol == '×-') {
            lastSymbolPosition = question.lastIndexOf('-');
            question = question.replaceRange(lastSymbolPosition, lastSymbolPosition + 1, '');
          }

          else if (lastSymbol == '÷-' ) {
            lastSymbolPosition = question.lastIndexOf('-');
            question = question.replaceRange(lastSymbolPosition, lastSymbolPosition + 1, '');
          }
        }
        break;

      default:
        // Handle other buttons like operator['+', '-', '×', '÷'] or numbers['0-9']

        // If button == operator['+', '-', '×', '÷']
        if (listPMTD.contains(buttonText)) {

          // Operator can be entered after number[0-9] or percentage'%'
          // Check last character is number[0-9] or percentage'%'
          if (checkLastCharIsNumber(question) || getLastChar(question) == '%') {

            // Add operator to question
            question += buttonText;
          }

          // If operator is entered after a operator
          // Delete the old one and change it to the new one
          else if (listPMTD.contains(getLastChar(buttonText))) {
            question = delete(question, 1);
            question += buttonText;
          }
        }

        // If button == number[0-9]
        else if (isNumber(buttonText)) {

          // numbers can be entered anytime except percentage'%'
          if (getLastChar(question) != '%') {
            question += buttonText;
          }
        }
        break;
    }
  }

  // At last, update question
  CalculatorPage.question = question;

  // calculate temporary answer
  calTempAns();
}

void calTempAns() {

  // Show temporary answer when equal'=' is not pressed and full formula is here
  if (!questionEmpty) {

    // Define what is a full formula first
    // Two ways to make it a full formula:
    // 1. Have '%', like '20%', temporary answer should shows '0.2'
    // 2. Have two numbers and one operator, like '20+6' to ['20', '6'] and ['+']

    int numbersLength = question.multiSplit(listPMTD).length;
    int operatorLength = question.multiSplit(listNumber + ['%', '.']).length;

    if (question.contains('%') || (numbersLength > 1 && operatorLength > 0)) {

      // Calculate the temporary answer
      try {
        CalculatorPage.answer = calculate(question);
      } catch(_) {}
    }
  }
}

String updateFormula(String formula) {

  // Delete '%' and replace it like '0.00'
  if (formula.contains('%')) {
    var listOfNumber = formula.multiSplit(listPMTD);

    var setOfNumberHavePercentage = listOfNumber.where((number) => number.contains('%'));

    var newFormula = formula;
    for (final numberHavePercentage in setOfNumberHavePercentage) {
      var number = (double.parse((numberHavePercentage.substring(0, numberHavePercentage.length - 1))) / 100).toString();
      newFormula = newFormula.replaceAll(numberHavePercentage, number);
    }

    formula = newFormula;
  }

  // Replace symbols to a calculable formula
  formula = formula.replaceAll('×', '*');
  formula = formula.replaceAll('÷', '/');

  return formula;
}

String calculate(String question) {
  String formula = question;

  formula = updateFormula(formula);

  Expression expression = Expression.parse(formula);
  var evaluator = const ExpressionEvaluator();
  String answer = evaluator.eval(expression, {}).toString();

  return answer;
}

void showSnackBar(BuildContext context, String text) {
  var snackBar = SnackBar(
    content: Text(text),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
