import 'package:LCI/Screen/_Utility/BaseTheme.dart';
import 'package:flutter/material.dart';

class PrimaryLoading extends StatelessWidget {
  final Color? color;
  final double? size;

  const PrimaryLoading({this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 12,
      width: size ?? 12,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        color: color ?? BaseTheme.PRIMARY_COLOR,
      ),
    );
  }
}
