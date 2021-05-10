part of '../tukanoid_styling.dart';

/// [Size] extension helper functions
extension SizeExtension on Size {
  /// Multiply 2 sizes together and get a new size with each respective value
  /// multiplied by each other
  Size mult(other) => Size(
        this.width * other.width,
        this.height * other.height,
      );
}
