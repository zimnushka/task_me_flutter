import 'package:flutter/material.dart';

class LoadContainer extends StatefulWidget {
  const LoadContainer({
    this.backGroundColor = Colors.grey,
    this.lineColor = Colors.white,
    this.height = double.infinity,
    this.width = double.infinity,
    this.radius = const BorderRadius.all(Radius.circular(20)),
    super.key,
  });
  final Color backGroundColor;
  final Color lineColor;
  final double width;
  final double height;
  final BorderRadius radius;

  @override
  State<LoadContainer> createState() => _LoadContainerState();
}

class _LoadContainerState extends State<LoadContainer> with TickerProviderStateMixin {
  late final DecorationTween decorationTween = DecorationTween(
    begin: BoxDecoration(
      color: widget.backGroundColor,
      borderRadius: widget.radius,
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          widget.lineColor,
          widget.backGroundColor,
          widget.backGroundColor,
        ],
      ),
    ),
    end: BoxDecoration(
      color: widget.backGroundColor,
      borderRadius: widget.radius,
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          widget.backGroundColor,
          widget.backGroundColor,
          widget.lineColor,
        ],
      ),
    ),
  );

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBoxTransition(
      decoration: decorationTween.animate(_controller),
      child: SizedBox(width: widget.width, height: widget.height),
    );
  }
}
