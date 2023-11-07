import 'package:flutter/material.dart';

class ScaleAnimatedContainer extends StatefulWidget {
  const ScaleAnimatedContainer({
    required this.child,
    this.repeat = false,
    this.duration = const Duration(milliseconds: 200),
    this.lowSize = 0,
    this.upSize = 1,
    Key? key,
  }) : super(key: key);
  final Widget child;
  final double upSize;
  final double lowSize;
  final Duration duration;
  final bool repeat;

  @override
  State<ScaleAnimatedContainer> createState() => _ScaleAnimatedContainerState();
}

class _ScaleAnimatedContainerState extends State<ScaleAnimatedContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: widget.duration,
    lowerBound: widget.lowSize,
    upperBound: widget.upSize,
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.decelerate,
  );

  @override
  void initState() {
    widget.repeat ? _controller.repeat(reverse: true) : _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
