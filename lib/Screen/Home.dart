import 'package:LCI/Screen/_Utility/CircleImage.dart';
import 'package:LCI/Screen/_Utility/CustomIcon.dart';
import 'package:LCI/Screen/_Utility/Labels.dart';
import 'package:LCI/Screen/_Utility/PageLoading.dart';
import 'package:LCI/ViewModel/HomeViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'sevenThings/SimpleSevenThingsList.dart';
import '_Utility/CustomSvg.dart';
import '_Utility/PrimaryCard.dart';

class Home extends StatefulWidget {
  StateHome createState() => StateHome();
}

class StateHome extends State<Home> with AutomaticKeepAliveClientMixin {
  Widget build(BuildContext context) {
    super.build(context);

    HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context, listen: true);
    homeViewModel.onWidgetBuilt(context);

    if (homeViewModel.user.id != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(onTap: () {}, child: CustomIcon(iconSource: CustomSvg.settings, size: 24, padding: EdgeInsets.zero)),
              GestureDetector(
                onTap: () => homeViewModel.showProfileMenu(context),
                child: ProfilePicture(
                  margin: EdgeInsets.zero,
                  source: homeViewModel.user.profilePictureBits,
                  size: 52,
                ),
              ),
            ],
          ),
          Container(margin: EdgeInsets.only(top: 18), child: HomeTitle(text: homeViewModel.user.name!)),
          PrimaryCard(
            outlined: false,
            margin: EdgeInsets.only(top: 24),
            contentMargin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HomeLabel(iconSource: CustomSvg.tasks, text: 'Today\'s 7 Things List'),
                SimpleSevenThingsList(viewModel: homeViewModel),
              ],
            ),
          ),
        ],
      );
    } else {
      return PageLoading();
    }
  }

  bool get wantKeepAlive => false;
}
