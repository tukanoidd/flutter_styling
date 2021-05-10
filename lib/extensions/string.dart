part of '../tukanoid_styling.dart';

/// [String] extension helper functions
extension StringExtensio on String {
  /// Parse this string as double and return the value, can throw an [Exception]
  double get toDouble => double.parse(this);
  /// Try to parse this string as double and return either parsed and converted
  /// value or null if parsing failed
  double? get toDoubleNull => double.tryParse(this);

  /// Parse this string as int and return the value, can throw an [Exception]
  int get toInt => int.parse(this);
  /// Try to parse this string as int and return either parsed and converted
  /// value or null if parsing failed
  int? get toIntNull => int.tryParse(this);
}