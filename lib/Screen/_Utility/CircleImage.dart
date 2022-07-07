import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'BaseTheme.dart';

class ProfilePicture extends StatelessWidget {
  final source;
  final double? size;
  final EdgeInsets? margin;

  const ProfilePicture({required this.source, this.size, this.margin});

  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? BaseTheme.DEFAULT_CONTENT_MARGIN,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: BaseTheme.LIGHT_OUTLINE_COLOR,
          width: 0.5,
        ),
      ),
      height: size ?? 150,
      width: size ?? 150,
      child: ClipOval(
        child: source != null
            ? source is Uint8List
                ? Image.memory(
                    source,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    source,
                    fit: BoxFit.cover,
                  )
            : Icon(Icons.add, color: BaseTheme.DEFAULT_OUTLINE_COLOR, size: 28),
      ),
    );
  }
}
