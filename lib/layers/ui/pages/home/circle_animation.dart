import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircleAnimation extends StatefulWidget {
  const CircleAnimation({super.key});

  @override
  State<CircleAnimation> createState() => _CircleAnimationState();
}

class _CircleAnimationState extends State<CircleAnimation> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _animation,
        child: SizedBox(
          width: 170,
          height: 170,
          child: CustomPaint(
            painter: _CirclePainter(context: context),
          ),
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  _CirclePainter({required this.context});
  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Theme.of(context).primaryColor
      ..strokeWidth = 1;
    final paintWhite = Paint()
      ..style = PaintingStyle.fill
      ..color = Theme.of(context).cardColor
      ..strokeWidth = 3;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      math.pi,
      math.pi,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.48, size.height * 0.51),
        height: size.height * 0.95,
        width: size.height * 0.95,
      ),
      math.pi,
      math.pi,
      false,
      paintWhite,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) => false;
}
