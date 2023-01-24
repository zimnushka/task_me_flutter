import 'package:flutter/material.dart';
import 'package:task_me_flutter/layers/ui/styles/icons.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum AppSnackBarType { error, success, info }

class AppSnackBar {
  static void show(BuildContext context, String text, AppSnackBarType type) {
    switch (type) {
      case AppSnackBarType.error:
        showTopSnackBar(
          context,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(radius)),
                color: Theme.of(context).errorColor,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppAnimatedIcon(AppAnimatedIcons.error, size: 25),
                      const SizedBox(width: 10),
                      Text(
                        text,
                        style: const TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      case AppSnackBarType.success:
        showTopSnackBar(
          context,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(radius)),
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppAnimatedIcon(AppAnimatedIcons.done, size: 25),
                      const SizedBox(width: 10),
                      Text(
                        text,
                        style: const TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      case AppSnackBarType.info:
        showTopSnackBar(
          context,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(radius)),
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppAnimatedIcon(AppAnimatedIcons.error, size: 25),
                      const SizedBox(width: 10),
                      Text(
                        text,
                        style: const TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
        break;
    }
  }
}
