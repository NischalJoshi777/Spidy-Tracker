import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/theme.dart';

class SpideySenseMeter extends StatefulWidget {
  final int level; // 0..100
  const SpideySenseMeter({super.key, required this.level});

  @override
  State<SpideySenseMeter> createState() => _SpideySenseMeterState();
}

class _SpideySenseMeterState extends State<SpideySenseMeter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _caption {
    if (widget.level < 25) return 'All quiet across town';
    if (widget.level < 50) return 'A little chatter on the scanners';
    if (widget.level < 75) return 'Something\'s definitely swinging around';
    return 'Tingling off the charts — stay alert!';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final pulse = 1.0 + sin(_controller.value * pi) * 0.03;
        return Column(
          children: [
            Transform.scale(
              scale: pulse,
              child: SizedBox(
                width: 160,
                height: 160,
                child: CustomPaint(
                  painter: _GaugePainter(level: widget.level / 100),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${widget.level}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: AppColors.inkNavy,
                          ),
                        ),
                        const Text(
                          'SPIDEY-SENSE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: AppColors.heroRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _caption,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double level; // 0..1
  _GaugePainter({required this.level});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 8;

    final track = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final progress = Paint()
      ..shader = const SweepGradient(
        colors: [AppColors.heroBlue, AppColors.heroRed, AppColors.alertAmber],
        startAngle: 0,
        endAngle: pi * 1.5,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    const startAngle = -pi / 2 - (pi * 0.75);
    const sweepFull = pi * 1.5;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepFull,
      false,
      track,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepFull * level,
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.level != level;
}
