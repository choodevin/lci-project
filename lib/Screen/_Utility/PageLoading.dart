import 'package:LCI/Screen/_Utility/PrimaryLoading.dart';
import 'package:flutter/material.dart';

import 'BaseScreen.dart';

class PageLoading extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: PrimaryLoading(),
      ),
    );
  }
}