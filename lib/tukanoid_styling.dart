/// My package for helping me and people who work with me on flutter project to
/// style applications in a way that doesn't require setting all the styling
/// parameters inside of the initialization of each widget but rather in a
/// separate objects that can then turn into those widgets
library tukanoid_styling;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'styling/imports.dart';

part 'styling/divider.dart';
part 'styling/edge_insets.dart';
part 'styling/icon.dart';
part 'styling/container_image.dart';
part 'styling/position.dart';
part 'styling/text.dart';
part 'extensions/widget.dart';

part 'extensions/size.dart';
part 'extensions/string.dart';
part 'extensions/list.dart';

class Styling {
  static String globalFontFamily = 'Sen';
}