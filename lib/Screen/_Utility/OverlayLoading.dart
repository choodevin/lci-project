import 'package:LCI/Screen/_Utility/BaseTheme.dart';
import 'package:flutter/material.dart';

import 'PrimaryLoading.dart';

class OverlayLoading extends StatelessWidget {
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BaseTheme.DEFAULT_BORDER_RADIUS,
          color: BaseTheme.OVERLAY_BACKGROUND_COLOR,
        ),
        child: Align(
          alignment: Alignment.center,
          child: PrimaryLoading(),
        ),
      ),
    );
  }
}
