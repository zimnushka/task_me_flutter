import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(AppIcons icon, {Key? key, this.color, this.size})
      : _icon = icon,
        super(key: key);
  final Color? color;
  final AppIcons _icon;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/${_icon.name}.svg',
      width: size ?? 20,
      height: size ?? 20,
      color: color ?? Theme.of(context).iconTheme.color,
    );
  }
}

enum AppIcons { logo }

class AppAnimatedIcon extends StatelessWidget {
  const AppAnimatedIcon(
    AppAnimatedIcons icon, {
    Key? key,
    this.color,
    this.size,
  })  : _icon = icon,
        super(key: key);
  final Color? color;
  final AppAnimatedIcons _icon;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/animations/${_icon.name}.gif',
      width: size ?? 200,
      height: size ?? 200,
    );
  }
}

enum AppAnimatedIcons { global, place }
