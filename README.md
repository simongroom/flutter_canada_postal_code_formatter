# canada_postal_code_formatter
![Dart CI](https://github.com/simongroom/flutter_canada_postal_code_formatter/workflows/Dart%20CI/badge.svg)

A handy TextInputFormatter that ensures adherence to the Canadian Postal Code Format.

## Getting Started

In the pubspec.yaml of your flutter project, add the following dependency:
```markdown
dependencies:
  canada_postal_code_formatter: "^0.0.1"
```

## Usage

```markdown
TextFormField(
  inputFormatters: List<TextInputFormatter> [
    LengthLimitingTextInputFormatter(7),
    CanadaPostalCodeFormatter(),
   ],
),
```
