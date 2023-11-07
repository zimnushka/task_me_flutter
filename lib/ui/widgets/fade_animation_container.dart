import 'package:flutter/material.dart';

class FadeAnimatedContainer extends StatefulWidget {
  const FadeAnimatedContainer({
    required this.firstChild,
    required this.secondChild,
    this.duration = const Duration(milliseconds: 1),
    this.showFirst = true,
    this.alignment = Alignment.center,
    Key? key,
  }) : super(key: key);
  final Widget firstChild;
  final Widget secondChild;
  final Duration duration;
  final bool showFirst;
  final Alignment alignment;

  @override
  State<FadeAnimatedContainer> createState() => _FadeAnimatedContainerState();
}

class _FadeAnimatedContainerState extends State<FadeAnimatedContainer> {
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      alignment: widget.alignment,
      firstChild: widget.firstChild,
      secondChild: widget.secondChild,
      duration: widget.duration,
      crossFadeState: widget.showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
