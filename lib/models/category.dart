import 'package:flutter/material.dart';

class Category {
  const Category({
    required this.cid,
    required this.name,
    required this.color,
  });
  final int cid;
  final String name;
  final String color;

  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  static Color hexToColor(String hex) {
    try {
      String hexCode = hex.replaceAll('#', '').toUpperCase();
      if (hexCode.length == 6) {
        hexCode = 'FF$hexCode';
      }
      if (hexCode.length != 8 || !RegExp(r'^[0-9A-F]{8}$').hasMatch(hexCode)) {
        throw const FormatException('Invalid hex color format');
      }
      return Color(int.parse('0x$hexCode'));
    } catch (e) {
      print('Error parsing color: $hex. Defaulting to grey.');
      return Colors.grey;
    }
  }
}
