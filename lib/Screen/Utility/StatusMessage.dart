import 'package:LCI/Notifier/StateNotifier.dart';
import 'package:LCI/Screen/Utility/BaseTheme.dart';
import 'package:flutter/material.dart';

class StatusMessage extends StatelessWidget {
  final StateNotifier stateNotifier;

  const StatusMessage({required this.stateNotifier});

  Widget build(BuildContext context) {
    if (stateNotifier.currentState == StateNotifier.STATE_NORMAL) {
      return SizedBox.shrink();
    } else if (stateNotifier.currentState == StateNotifier.STATE_ERROR) {
      return Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, color: BaseTheme.DEFAULT_ERROR_COLOR),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 3),
                margin: EdgeInsets.only(left: 4),
                child: Text(
                  stateNotifier.errorMessage,
                  style: TextStyle(
                    color: BaseTheme.DEFAULT_ERROR_COLOR,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox.shrink();
  }
}
