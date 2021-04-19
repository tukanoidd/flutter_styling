part of '../tukanoid_styling.dart';

extension SizeExtension on Size {
  Size mult(other) => Size(
        this.width * other.width,
        this.height * other.height,
      );
}
