import 'package:LCI/Screen/_Utility/PrimaryCheckbox.dart';
import 'package:LCI/Screen/_Utility/PrimaryLoading.dart';
import 'package:flutter/material.dart';

import '../../ViewModel/BaseViewModel.dart';

class SimpleSevenThingsList extends StatefulWidget {
  final BaseViewModel viewModel;

  const SimpleSevenThingsList({required this.viewModel});

  StateSimpleSevenThingsList createState() => StateSimpleSevenThingsList();
}

class StateSimpleSevenThingsList extends State<SimpleSevenThingsList> {
  get viewModel => widget.viewModel;

  Widget build(BuildContext context) {
    if (viewModel.sevenThings == null) {
      return Container(
        margin: EdgeInsets.only(top: 14),
        constraints: BoxConstraints(
          minHeight: 200,
        ),
        child: Center(
          child: PrimaryLoading(),
        ),
      );
    }

    if (viewModel.checkContentAvailable()) {
      return Container(
        margin: EdgeInsets.only(top: 14),
        child: Text("You do not have any 7 things added today"),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 14),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: viewModel.sevenThings!.contentList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => viewModel.updateSevenThingsContent(index),
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
                            value: viewModel.sevenThings!.contentList.elementAt(index).status,
                            onChanged: (_) => viewModel.updateSevenThingsContent(index),
                          ),
                        ),
                      ),
                      Text(
                        viewModel.sevenThings!.contentList.elementAt(index).content!,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
