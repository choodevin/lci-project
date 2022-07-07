import 'package:LCI/Model/SevenThings/SevenThingsModel.dart';
import 'package:LCI/Screen/_Utility/BaseTheme.dart';
import 'package:LCI/Screen/_Utility/CustomIcon.dart';
import 'package:LCI/Screen/_Utility/Labels.dart';
import 'package:LCI/Screen/_Utility/PrimaryButton.dart';
import 'package:LCI/Screen/_Utility/PrimaryCheckbox.dart';
import 'package:LCI/ViewModel/HomeViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/SevenThingsViewModel.dart';

class SevenThings extends StatefulWidget {
  StateSevenThings createState() => StateSevenThings();
}

class StateSevenThings extends State<SevenThings> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    SevenThingsViewModel sevenThingsViewModel = Provider.of<SevenThingsViewModel>(context, listen: true);
    HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context);

    sevenThingsViewModel.homeViewModel = homeViewModel;

    if (sevenThingsViewModel.user.id == null) sevenThingsViewModel.user = homeViewModel.user;

    if (sevenThingsViewModel.currentSevenThings == null) {
      if (homeViewModel.sevenThings != null) {
        sevenThingsViewModel.currentSevenThings = homeViewModel.sevenThings;
      } else {
        sevenThingsViewModel.currentSevenThings = SevenThingsModel();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageTitle(text: "7 Things"),
        Container(
          margin: EdgeInsets.only(top: 18),
          child: GestureDetector(
            onTap: () => sevenThingsViewModel.selectDate(context),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(18)),
                color: BaseTheme.SECONDARY_COLOR,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sevenThingsViewModel.getSevenThingsDateDisplay(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: BaseTheme.DEFAULT_DISPLAY_COLOR,
                    ),
                  ),
                  CustomIcon(
                    iconSource: Icons.date_range,
                    size: 20,
                    padding: EdgeInsets.only(left: 8),
                    backgroundColor: Colors.transparent,
                    color: BaseTheme.DEFAULT_DISPLAY_COLOR,
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 18),
          child: ReorderableListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: sevenThingsViewModel.currentSevenThings!.contentList.length,
            onReorder: sevenThingsViewModel.reorderSevenThings,
            itemBuilder: (context, index) {
              bool contentIsEmpty = sevenThingsViewModel.currentSevenThings!.contentList.elementAt(index).content.isEmpty ? true : false;

              return GestureDetector(
                key: Key(index.toString()),
                onTap: contentIsEmpty ? null : () => sevenThingsViewModel.updateTempSevenThingsContent(index),
                onLongPress: contentIsEmpty ? null : () => sevenThingsViewModel.showSevenThingsContentMenu(context),
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Container(
                          height: 24,
                          width: 24,
                          margin: EdgeInsets.only(right: 8),
                          child: PrimaryCheckbox(
                            value: sevenThingsViewModel.currentSevenThings!.contentList.elementAt(index).status,
                            onChanged: contentIsEmpty ? null : (_) => sevenThingsViewModel.updateTempSevenThingsContent(index),
                          ),
                        ),
                      ),
                      Text(
                        sevenThingsViewModel.currentSevenThings!.contentList.elementAt(index).content,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Spacer(),
        sevenThingsViewModel.currentSevenThings!.contentList.every((element) => element.content.isNotEmpty)
            ? SizedBox.shrink()
            : PrimaryButton(
                text: "Add Seven Things",
                onPressed: () => sevenThingsViewModel.addSevenThingsContent(context),
              ),
      ],
    );
  }

  bool get wantKeepAlive => true;
}
