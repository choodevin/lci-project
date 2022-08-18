import 'package:LCI/Screen/_Utility/BaseTheme.dart';
import 'package:LCI/Screen/_Utility/CustomSvg.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../ViewModel/HomeContainerViewModel.dart';

class BaseScreen extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool? resizeToAvoidBottomInset;
  final bool? scrollable;
  final Color? backgroundColor;
  final bool? bottomNavigationBar;
  final HomeContainerViewModel? homeContainerViewModel;
  final PageController? pageController;
  final bool? homeScreens;

  const BaseScreen({
    required this.child,
    this.resizeToAvoidBottomInset,
    this.padding,
    this.scrollable,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.homeContainerViewModel,
    this.pageController,
    this.homeScreens,
  });

  StateBaseScreen createState() => StateBaseScreen();
}

class StateBaseScreen extends State<BaseScreen> {
  get child => widget.child;

  get padding => widget.padding ?? BaseTheme.DEFAULT_SCREEN_MARGIN;

  get resizeToAvoidBottomInset => widget.resizeToAvoidBottomInset ?? true;

  get scrollable => widget.scrollable ?? false;

  get backgroundColor => widget.backgroundColor;

  get bottomNavigationBar => widget.bottomNavigationBar ?? false;

  get homeContainerViewModel => widget.homeContainerViewModel;

  get pageController => widget.pageController;

  get homeScreens => widget.homeScreens ?? false;

  Widget build(BuildContext context) {
    Widget body = SafeArea(
      child: Container(
        height: homeScreens
            ? MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - kBottomNavigationBarHeight
            : MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );

    if (scrollable) body = SingleChildScrollView(child: body);

    return GestureDetector(
      onTap: () {
        setState(() {
          FocusScope.of(context).unfocus();
        });
      },
      child: Scaffold(
        backgroundColor: backgroundColor ?? BaseTheme.BACKGROUND_COLOR,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        bottomNavigationBar: bottomNavigationBar
            ? BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedItemColor: BaseTheme.PRIMARY_COLOR,
                type: BottomNavigationBarType.fixed,
                backgroundColor: BaseTheme.BACKGROUND_COLOR,
                currentIndex: homeContainerViewModel.currentPage,
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(CustomSvg.wheelOfLife, height: 26, color: BaseTheme.DEFAULT_DISPLAY_COLOR),
                    activeIcon: SvgPicture.asset(CustomSvg.wheelOfLife_bold, height: 26, color: BaseTheme.PRIMARY_COLOR),
                    label: "LCI",
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(CustomSvg.tasks, height: 26, color: BaseTheme.DEFAULT_DISPLAY_COLOR),
                    activeIcon: SvgPicture.asset(CustomSvg.tasks_bold, height: 26, color: BaseTheme.PRIMARY_COLOR),
                    label: "7 Things",
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(CustomSvg.home, height: 26, color: BaseTheme.DEFAULT_DISPLAY_COLOR),
                    activeIcon: SvgPicture.asset(CustomSvg.home_bold, height: 26, color: BaseTheme.PRIMARY_COLOR),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(CustomSvg.campaign, height: 26, color: BaseTheme.DEFAULT_DISPLAY_COLOR),
                    activeIcon: SvgPicture.asset(CustomSvg.campaign_bold, height: 26, color: BaseTheme.PRIMARY_COLOR),
                    label: "Campaign",
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(CustomSvg.user, height: 26, color: BaseTheme.DEFAULT_DISPLAY_COLOR),
                    activeIcon: SvgPicture.asset(CustomSvg.user_bold, height: 26, color: BaseTheme.PRIMARY_COLOR),
                    label: "Profile",
                  ),
                ],
                onTap: (index) => homeContainerViewModel.updateCurrentPage(index, pageController),
              )
            : null,
        body: body,
      ),
    );
  }
}
