import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool? resizeToAvoidBottomInset;
  final bool? scrollable;

  const BaseScreen({required this.child, this.resizeToAvoidBottomInset, this.padding, this.scrollable});

  StateBaseScreen createState() => StateBaseScreen();
}

class StateBaseScreen extends State<BaseScreen> {
  get child => widget.child;

  get padding => widget.padding ?? EdgeInsets.symmetric(horizontal: 18, vertical: 12);

  get resizeToAvoidBottomInset => widget.resizeToAvoidBottomInset ?? true;

  get scrollable => widget.scrollable ?? false;

  Widget build(BuildContext context) {
    if (scrollable) {
      return GestureDetector(
        onTap: () {
          setState(() {
            FocusScope.of(context).unfocus();
          });
        },
        child: Scaffold(
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: SafeArea(
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
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
}
