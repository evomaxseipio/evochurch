
import 'package:flutter/material.dart';

extension Path on String {


  String get _capitalizeFirst {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  String get capitalize =>
      trim().split(' ').map((e) => e.trim()._capitalizeFirst).join(' ');

  String get route =>
      trim().split('-').map((e) => e.trim()._capitalizeFirst).join(' ');
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

extension Context on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// similar to [Theme.of(context)]
  ThemeData get theme => Theme.of(this);

  /// similar to [Theme.of(context).colorScheme]
  ColorScheme get color => Theme.of(this).colorScheme;

  /// The same of [MediaQuery.of(context).size]
  Size get size => MediaQuery.of(this).size;

  /// The same of [MediaQuery.of(context).size.height]
  double get height => MediaQuery.of(this).size.height;

  /// The same of [MediaQuery.of(context).size.width]
  double get width => MediaQuery.of(this).size.width;
}
