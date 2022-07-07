import 'package:LCI/Screen/_Utility/BaseTheme.dart';
import 'package:LCI/Screen/_Utility/CircleImage.dart';
import 'package:LCI/Screen/_Utility/CustomIcon.dart';
import 'package:LCI/Screen/_Utility/Labels.dart';
import 'package:LCI/Screen/_Utility/PageLoading.dart';
import 'package:LCI/ViewModel/HomeViewModel.dart';
import 'package:LCI/ViewModel/SevenThingsViewModel.dart';
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

    if (homeViewModel.user.id == null) homeViewModel.loadCurrentUser();
    if (homeViewModel.user.id != null && homeViewModel.sevenThings == null) homeViewModel.loadSevenThings();

    if (homeViewModel.user.id != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIcon(iconSource: CustomSvg.settings, size: 24, padding: EdgeInsets.zero),
              ProfilePicture(
                margin: EdgeInsets.zero,
                source: homeViewModel.user.profilePictureBits,
                size: 52,
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
