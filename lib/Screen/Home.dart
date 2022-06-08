import 'package:LCI/Screen/_Utility/CircleImage.dart';
import 'package:LCI/Screen/_Utility/PrimaryButton.dart';
import 'package:LCI/ViewModel/HomeViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '_Utility/BaseScreen.dart';

class Home extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
      ],
      child: _Home(),
    );
  }
}

class _Home extends StatefulWidget {
  StateHome createState() => StateHome();
}

class StateHome extends State<_Home> {
  Widget build(BuildContext context) {
    HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context);

    if (homeViewModel.user.id == null) homeViewModel.loadCurrentUser();

    return homeViewModel.user.id != null ? BaseScreen(
      scrollable: true,
      child: Column(
        children: [
          PrimaryButton(
            text: homeViewModel.user.name.toString(),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
          ProfilePicture(
            profilePicture: homeViewModel.user.profilePictureBits,
            size: 120,
          ),
        ],
      ),
    ) : Text("loading");
  }
}
