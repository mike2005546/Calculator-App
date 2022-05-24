import 'package:flutter/material.dart';

extension BreakpointUtils on BoxConstraints {
  bool get isTablet => maxWidth > 730;
  bool get isDesktop => maxWidth > 1200;
  bool get isMobile => !isTablet && !isDesktop;
}

extension UtilExtensions on String {
  List<String> multiSplit(List<String> delimiters) {
    if (delimiters.isEmpty) {
      return [this];
    } else {
      var list = split(RegExp(delimiters.map(RegExp.escape).join('|')));
      list.removeWhere((element) => element == '');
      return list;
    }
  }
}