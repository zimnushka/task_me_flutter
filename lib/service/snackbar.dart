import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum OverlayType { error, success, info, none }

class OverlayManager {
  static OverlayEntry showOverlayMessage({
    required OverlayState overlayState,
    required String messageText,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 4),
    Color textColor = Colors.black,
  }) {
    OverlayEntry? overlayScreen;
    overlayScreen = OverlayEntry(builder: (context) {
      return Positioned(
        top: 20,
        right: 20,
        child: GestureDetector(
          onTap: overlayScreen?.remove,
          child: Material(
            color: backgroundColor,
            child: SizedBox(
              width: 360,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(messageText),
              ),
            ),
          ),
        ),
      );
    });
    overlayState.insert(overlayScreen);
    Future.delayed(duration).then(
      (value) {
        try {
          overlayScreen?.remove();
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      },
    );

    return overlayScreen;
  }
}
