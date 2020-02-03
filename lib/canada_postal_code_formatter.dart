library canada_postal_code_formatter;

import 'package:flutter/services.dart';

/// [TextInputFormatter] that ensures a [TextInput] conforms to the Canadian
/// Postal Code format. This is used because we need to evaluate the [TextInput]
/// on each change of the input to ensure it matches the expected input at any
/// given time.
class CanadaPostalCodeFormatter extends TextInputFormatter {
  static final firstString = "[ABCEGHJKLMNPRSTVXY]";
  static final remainderString = "[ABCEGHJKLMNPRSTVWXYZ]";

  /// [List] of [RegExp] representing the expected text input at all points
  /// of text input.
  static final List<RegExp> _regExp = [
    RegExp(firstString),
    RegExp("$firstString[\\d]"),
    RegExp("$firstString[\\d]$remainderString"),
    RegExp("$firstString[\\d]$remainderString[ ]"),
    RegExp("$firstString[\\d]$remainderString[ ][\\d]"),
    RegExp("$firstString[\\d]$remainderString[ ][\\d]$remainderString"),
    RegExp("$firstString[\\d]$remainderString[ ][\\d]$remainderString[\\d]"),
  ];

  /// Returns a [String]. Ensures the [newValue] matches the expected input,
  /// determined by the supplied [regExp], if it doesn't, we set the newText
  /// value to the [oldValue] text, essentially rejecting the update.
  String _validateNewText(
      TextEditingValue newValue, TextEditingValue oldValue, RegExp regExp) {
    String newText = newValue.text;
    if (!regExp.hasMatch(newValue.text)) {
      newText = oldValue.text;
    }
    return newText;
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    String newText = newValue.text;
    if (newTextLength != 0) {
      // validate the text matches the expected input at this point
      newText =
          _validateNewText(newValue, oldValue, _regExp[newTextLength - 1]);
    }
    if (newText.length == 3 && newText.length > oldValue.text.length) {
      // add a space for the user, so they don't need to type it themselves
      newText = newText + " ";
    }
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

