part of '../tukanoid_styling.dart';

/// [List] extension helper functions
extension ListExtension on List {
  /// Return a sorted list with optional [compare] function to do the sorting
  List<T> sorted<T>([int Function(T, T)? compare]) {
    List<T> newList = List.from(this);
    newList.sort(compare);

    return newList;
  }
}