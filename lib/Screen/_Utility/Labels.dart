import 'package:LCI/Screen/_Utility/CustomIcon.dart';
import 'package:flutter/material.dart';

import 'BaseTheme.dart';

class PageTitle extends StatelessWidget {
  final String text;
  final EdgeInsets? margin;
  final bool backButton;

  const PageTitle({required this.text, this.margin, this.backButton = false});

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Row(
        children: [
          backButton
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).maybePop();
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
                fontSize: 28,
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
      margin: margin ?? BaseTheme.DEFAULT_META_TEXT_MARGIN,
      child: Text(
        text,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: BaseTheme.META_TEXT_COLOR),
      ),
    );
  }
}

class CardTitle extends StatelessWidget {
  final String text;
  final EdgeInsets? margin;

  const CardTitle({required this.text, this.margin});

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: BaseTheme.DEFAULT_DISPLAY_COLOR,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class CardText extends StatelessWidget {
  final String text;
  final EdgeInsets? margin;

  const CardText({required this.text, this.margin});

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(
          color: BaseTheme.DEFAULT_DISPLAY_COLOR,
          fontSize: 16,
        ),
      ),
    );
  }
}

class PriceLabel extends StatelessWidget {
  final Color? color;
  final String currency;
  final double price;
  final String recurringType;
  final EdgeInsets? margin;

  const PriceLabel({this.color, required this.currency, required this.price, required this.recurringType, this.margin});

  static const String RECURRING_MONTH = "/mo.";
  static const String RECURRING_YEAR = "/yr.";

  static const String CURRENCY_MYR = "RM";

  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "$currency${price.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 36,
              color: color ?? BaseTheme.PRIMARY_COLOR,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            recurringType,
            style: TextStyle(
              fontSize: 12,
              color: color ?? BaseTheme.PRIMARY_COLOR,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeTitle extends StatelessWidget {
  final String text;

  const HomeTitle({required this.text});

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Hi, ',
              style: BaseTheme.defaultTextStyle.merge(
                TextStyle(fontSize: 28),
              ),
              children: [
                TextSpan(
                  text: text,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 4),
            child: Text(
              'Welcome to 4ward LCI Life Compass',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeLabel extends StatelessWidget {
  final String text;
  final EdgeInsets? margin;
  final dynamic iconSource;

  const HomeLabel({required this.text, this.margin, this.iconSource});

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Row(
        children: [
          CustomIcon(iconSource: iconSource, padding: EdgeInsets.only(right: 12), size: 22,),
          Text(
            text,
            style: TextStyle(
              color: BaseTheme.DEFAULT_DISPLAY_COLOR,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class ModalTitle extends StatelessWidget {
  final EdgeInsets? margin;
  final String text;

  const ModalTitle({this.margin, required this.text});

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: BaseTheme.DEFAULT_DISPLAY_COLOR,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
