import 'package:flutter/material.dart';

class PrimaryLoading extends StatelessWidget {
  final Color? color;

  const PrimaryLoading({this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        color: color,
      ),
    );
  }
}
