import 'package:flutter/services.dart';

class NumberFormats extends TextInputFormatter {
  final bool isInt;

  NumberFormats({this.isInt = false});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length < oldValue.text.length) {
      return TextEditingValue(
          text: newValue.text,
          selection: TextSelection.collapsed(offset: newValue.text.length));
    }
    int ascii = newValue.text.codeUnitAt(oldValue.text.length);
    if ((isInt ? false : ascii == 46) || (ascii >= 48 && ascii <= 57)) {
      return TextEditingValue(
          text: newValue.text,
          selection: TextSelection.collapsed(offset: newValue.text.length));
    }
    return TextEditingValue(
        text: oldValue.text,
        selection: TextSelection.collapsed(offset: oldValue.text.length));
  }
}
