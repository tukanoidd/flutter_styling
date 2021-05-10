part of '../tukanoid_styling.dart';

/// [List] extension helper functions
extension ListExtension on List {
  /// Return a sorted list with optional [compare] function to do the sorting
  List sorted([int Function(dynamic, dynamic)? compare]) {
    List newList = List.from(this);
    newList.sort(compare);

    return newList;
  }
}