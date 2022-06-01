import 'package:LCI/Screen/_Utility/BaseTheme.dart';
import 'package:flutter/material.dart';

class PageViewWithIndicator extends StatefulWidget {
  final List<Widget> children;
  final EdgeInsets? margin;
  final Function? onPageChanged;
  final int? selectedPage;

  PageViewWithIndicator({required this.children, this.margin, this.onPageChanged, this.selectedPage});

  StatePageViewWithIndicator createState() => StatePageViewWithIndicator();
}

class StatePageViewWithIndicator extends State<PageViewWithIndicator> {
  get children => widget.children;

  get margin => widget.margin;

  get onPageChanged => widget.onPageChanged;

  get selectedPage => widget.selectedPage;

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 12),
              child: PageView(
                onPageChanged: onPageChanged,
                children: children,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < children.length; i++)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  child: PageIndicatorBullet(
                    isActive: i == selectedPage ? true : false,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class PageIndicatorBullet extends StatelessWidget {
  final bool isActive;

  const PageIndicatorBullet({required this.isActive});

  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 8,
      width: 8,
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isActive ? BaseTheme.PRIMARY_COLOR : BaseTheme.LIGHT_OUTLINE_COLOR,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
