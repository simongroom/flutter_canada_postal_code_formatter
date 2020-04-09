library canada_postal_code_formatter;

import 'package:flutter/services.dart';

/// [TextInputFormatter] that ensures a [TextInput] conforms to the Canadian
/// Postal Code format. This is used because we need to evaluate the [TextInput]
/// on each change of the input to ensure it matches the expected input at any
/// given time.
class CanadaPostalCodeFormatter extends TextInputFormatter {
  // Forward Sortation Area (FSA) - Is the first 3 chars of the Canadian
  // Postal Code. The first char cannot be W or Z, nor D, F, I, O, Q and U
  // Local Delivery Unit (LDU) is the last 3 chars of Canadian Postal Code.
  // LDU cannot contain D, F, I, O, Q and U
  static const String validFsaFirstChar = "[ABCEGHJKLMNPRSTVXY]";
  static const String validFsaAndLduChars = "[ABCEGHJKLMNPRSTVWXYZ]";
  static const String validFsa = "$validFsaFirstChar[\\d]$validFsaAndLduChars";
  static const String validLdu = "[\\d]$validFsaAndLduChars[\\d]";
  static const String validPostalCode = "$validFsa[ ]$validLdu";

  /// [List] of [RegExp] representing the expected text input at all points
  /// of text input.
  static final List<RegExp> _regExp = [
    RegExp(validFsaFirstChar),
    RegExp("$validFsaFirstChar[\\d]"),
    RegExp(validFsa),
    RegExp("$validFsa[ ]"),
    RegExp("$validFsa[ ][\\d]"),
    RegExp("$validFsa[ ][\\d]$validFsaAndLduChars"),
    RegExp(validPostalCode),
  ];

  /// Returns a [String]. Ensures the [newValue] matches the expected input,
  /// determined by the supplied [regExp], if it doesn't, we set the newText
  /// value to the [oldValue] text, essentially rejecting the update.
  String _validateNewText(
      TextEditingValue newValue, TextEditingValue oldValue, RegExp regExp) {
    String newText = newValue.text;
    // check our regex - if we don't match expected, set the newText val to the
    // oldValue text - rejecting the update.
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
      // if we have a valid FSA, and we aren't deleting characters, add a space
      // for the user, so they don't need to type it themselves
      newText = newText + " ";
    }
    // return our new value
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
