import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool? resizeToAvoidBottomInset;

  const BaseScreen({required this.child, this.resizeToAvoidBottomInset, this.padding});

  StateBaseScreen createState() => StateBaseScreen();
}

class StateBaseScreen extends State<BaseScreen> {
  get child => widget.child;

  get padding => widget.padding ?? EdgeInsets.symmetric(horizontal: 18, vertical: 12);

  get resizeToAvoidBottomInset => widget.resizeToAvoidBottomInset ?? true;

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          FocusScope.of(context).unfocus();
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: SafeArea(
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
