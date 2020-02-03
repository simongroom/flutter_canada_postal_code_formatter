import 'package:canada_postal_code_formatter/canada_postal_code_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const List<String> _invalidFirstCharacters = ["D","F","I","O","Q","W","Z"];
  const List<String> _invalidCharacters = ["D", "F", "I", "O", "Q"];
  final formatter = CanadaPostalCodeFormatter();

  /// Tests that the result the formatter outputs matches the supplied
  /// [expected] [String]
  void _test(
      TextEditingValue oldText, TextEditingValue newText, String expected) {
    TextEditingValue _result = formatter.formatEditUpdate(oldText, newText);
    expect(_result.text, expected);
  }

  group("Canada Postal Code Formatter Test", () {
    test("Test first character is a valid character", () {
      TextEditingValue _oldValue = TextEditingValue(text: "");
      TextEditingValue _validNewValue = TextEditingValue(text: "N");
      TextEditingValue _invalidNewValue = TextEditingValue(text: "8");

      _test(_oldValue, _validNewValue, _validNewValue.text);
      _test(_oldValue, _invalidNewValue, _oldValue.text);

      _invalidFirstCharacters.forEach((String _char) {
        TextEditingValue _oldValue = TextEditingValue(text: "");
        TextEditingValue _invalidNewValue = TextEditingValue(text: _char);
        _test(_oldValue, _invalidNewValue, _oldValue.text);
      });
    });

    test("Test first two characters are valid characters", () {
      TextEditingValue _oldValue = TextEditingValue(text: "N");
      TextEditingValue _validNewValue = TextEditingValue(text: "N8");
      TextEditingValue _invalidNewValue = TextEditingValue(text: "NN");

      _test(_oldValue, _validNewValue, _validNewValue.text);
      _test(_oldValue, _invalidNewValue, _oldValue.text);
    });

    test("Test first three characters are valid characters", () {
      TextEditingValue _oldValue = TextEditingValue(text: "N8");
      TextEditingValue _validNewValue = TextEditingValue(text: "N8Y");
      TextEditingValue _invalidNewValue = TextEditingValue(text: "N88");

      TextEditingValue _validResult =
      formatter.formatEditUpdate(_oldValue, _validNewValue);
      // special case here, since the formatter adds a space for us
      expect(_validResult.text, isNot(_validNewValue.text));
      expect(_validResult.text, _validNewValue.text + " ");

      TextEditingValue _invalidResult =
      formatter.formatEditUpdate(_oldValue, _invalidNewValue);
      expect(_invalidResult.text, _oldValue.text);

      _invalidCharacters.forEach((String _char) {
        TextEditingValue _oldValue = TextEditingValue(text: "N8");
        TextEditingValue _invalidNewValue =
        TextEditingValue(text: "N8" + _char);
        _test(_oldValue, _invalidNewValue, _oldValue.text);
      });
    });

    test("Test first four characters are valid characters", () {
      TextEditingValue _oldValue = TextEditingValue(text: "N8Y");
      TextEditingValue _validNewValue = TextEditingValue(text: "N8Y ");
      TextEditingValue _invalidNewValue = TextEditingValue(text: "N88G");

      _test(_oldValue, _validNewValue, _validNewValue.text);
      _test(_oldValue, _invalidNewValue, _oldValue.text);
    });

    test("Test first five characters are valid characters", () {
      TextEditingValue _oldValue = TextEditingValue(text: "N8Y ");
      TextEditingValue _validNewValue = TextEditingValue(text: "N8Y 1");
      TextEditingValue _invalidNewValue = TextEditingValue(text: "N8Y G");

      _test(_oldValue, _validNewValue, _validNewValue.text);
      _test(_oldValue, _invalidNewValue, _oldValue.text);
    });

    test("Test first six characters are valid characters", () {
      TextEditingValue _oldValue = TextEditingValue(text: "N8Y 1");
      TextEditingValue _validNewValue = TextEditingValue(text: "N8Y 1M");
      TextEditingValue _invalidNewValue = TextEditingValue(text: "N8Y 17");

      _test(_oldValue, _validNewValue, _validNewValue.text);
      _test(_oldValue, _invalidNewValue, _oldValue.text);

      _invalidCharacters.forEach((String _char) {
        TextEditingValue _oldValue = TextEditingValue(text: "N8Y 1");
        TextEditingValue _invalidNewValue =
        TextEditingValue(text: "N8Y 1" + _char);
        _test(_oldValue, _invalidNewValue, _oldValue.text);
      });
    });

    test("Test full postal code is valid", () {
      TextEditingValue _oldValue = TextEditingValue(text: "N8Y 1M");
      TextEditingValue _validNewValue = TextEditingValue(text: "N8Y 1M7");
      TextEditingValue _invalidNewValue = TextEditingValue(text: "N88 1MM");

      _test(_oldValue, _validNewValue, _validNewValue.text);
      _test(_oldValue, _invalidNewValue, _oldValue.text);
    });
  });
}
