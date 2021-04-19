part of '../tukanoid_styling.dart';

extension StringExtensio on String {
  double get toDouble => double.parse(this);
  double? get toDoubleNull => double.tryParse(this);
}