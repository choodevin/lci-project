import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BaseTheme.dart';

class ProfilePicture extends StatelessWidget {
  final profilePicture;
  final double? size;

  const ProfilePicture({required this.profilePicture, this.size});

  Widget build(BuildContext context) {
    return Container(
      margin: BaseTheme.DEFAULT_CONTENT_MARGIN,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: BaseTheme.LIGHT_OUTLINE_COLOR,
          width: 1,
        ),
      ),
      height: size ?? 150,
      width: size ?? 150,
      child: ClipOval(
        child: profilePicture != null
            ? profilePicture is Uint8List
                ? Image.memory(
                    profilePicture,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    profilePicture,
                    fit: BoxFit.cover,
                  )
            : Icon(Icons.add, color: BaseTheme.DEFAULT_OUTLINE_COLOR, size: 28),
      ),
    );
  }
}
