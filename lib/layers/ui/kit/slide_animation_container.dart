import 'package:flutter/material.dart';

class SlideAnimatedContainer extends StatefulWidget {
  const SlideAnimatedContainer({
    required this.child,
    this.start = Offset.zero,
    this.end = const Offset(1, 1),
    this.repeat = false,
    this.curve = Curves.elasticIn,
    this.duration = const Duration(milliseconds: 300),
    this.replayInBuild = true,
    Key? key,
  }) : super(key: key);
  final Widget child;
  final Offset start;
  final Offset end;
  final Duration duration;
  final bool repeat;
  final bool replayInBuild;
  final Curve curve;

  @override
  State<SlideAnimatedContainer> createState() => _SlideAnimatedContainerState();
}

class _SlideAnimatedContainerState extends State<SlideAnimatedContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _offsetAnimation = Tween<Offset>(
      begin: widget.start,
      end: widget.end,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );
    widget.repeat ? _controller.repeat(reverse: true) : _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.replayInBuild) {
      if (_controller.isCompleted) {
        _controller.reset();
      }
      _controller.forward();
    }

    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child,
    );
  }
}
