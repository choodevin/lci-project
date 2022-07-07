import 'package:LCI/Screen/_Utility/BaseScreen.dart';
import 'package:LCI/Screen/sevenThings/SevenThings.dart';
import 'package:LCI/ViewModel/HomeContainerViewModel.dart';
import 'package:LCI/ViewModel/SevenThingsViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/HomeViewModel.dart';
import '../Home.dart';
import 'PageLoading.dart';

class HomeContainer extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeContainerViewModel()),
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(create: (context) => SevenThingsViewModel()),
      ],
      child: _HomeContainer(),
    );
  }
}

class _HomeContainer extends StatefulWidget {
  StateHomeContainer createState() => StateHomeContainer();
}

class StateHomeContainer extends State<_HomeContainer> {
  PageController pageController = PageController(initialPage: 2);

  Widget build(BuildContext context) {
    HomeContainerViewModel homeContainerViewModel = Provider.of<HomeContainerViewModel>(context);

    return BaseScreen(
      bottomNavigationBar: true,
      homeContainerViewModel: homeContainerViewModel,
      pageController: pageController,
      scrollable: true,
      child: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          PageLoading(),
          SevenThings(),
          Home(),
          PageLoading(),
          PageLoading(),
        ],
      ),
    );
  }
}
