import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_me_flutter/app/app.dart';
import 'package:task_me_flutter/app/configs.dart';

void main() {
  if (kIsWeb) {
    runApp(TaskMyApp(config: releaseWebConfig));
  } else {
    runApp(TaskMyApp(config: releaseMobileConfig));
  }
}
