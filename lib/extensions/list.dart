part of '../tukanoid_styling.dart';

extension ListExtension on List {
  List sorted([int Function(dynamic, dynamic)? compare]) {
    List newList = List.from(this);
    newList.sort(compare);

    return newList;
  }
}