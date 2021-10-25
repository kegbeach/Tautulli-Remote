import 'package:flutter/material.dart';

class NewListHeader extends StatelessWidget {
  final String headingText;
  final double topPadding;

  const NewListHeader({
    Key? key,
    required this.headingText,
    this.topPadding = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        left: 16,
      ),
      child: Text(
        headingText,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
