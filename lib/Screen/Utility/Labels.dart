import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BaseTheme.dart';

class PageTitle extends StatelessWidget {
  final String text;
  final EdgeInsets? margin;
  final bool backButton;

  const PageTitle({required this.text, this.margin, this.backButton = false});

  Widget build(BuildContext context) {
    return Container(
      padding: margin,
      child: Row(
        children: [
          backButton
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back_sharp),
                )
              : SizedBox.shrink(),
          Container(
            margin: backButton ? EdgeInsets.only(left: 12) : null,
            child: Text(
              text.toUpperCase(),
              style: TextStyle(
                color: BaseTheme.DEFAULT_HEADINGS_COLOR,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MetaText extends StatelessWidget {
  final String text;
  final EdgeInsets? margin;

  const MetaText({required this.text, this.margin});

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Text(
        text,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: BaseTheme.META_TEXT_COLOR),
      ),
    );
  }
}
