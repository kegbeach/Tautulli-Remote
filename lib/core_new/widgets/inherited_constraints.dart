import 'package:flutter/material.dart';

class InheritedConstraints extends InheritedWidget {
  final BoxConstraints constraints;

  InheritedConstraints({
    Key? key,
    required Widget child,
    required this.constraints,
  }) : super(key: key, child: child);

  static InheritedConstraints? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedConstraints>();
  }

  @override
  bool updateShouldNotify(InheritedConstraints oldWidget) {
    return true;
  }
}
