import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/gesture_animation.dart';
import '../core/constants/finger_pose_library.dart';

class AnimatedHand extends StatefulWidget {
  final String gesture;
  final bool playing;
  final GestureAnimation? animationData;

  const AnimatedHand({
    super.key,
    required this.gesture,
    required this.playing,
    this.animationData,
  });

  @override
  State<AnimatedHand> createState() => _AnimatedHandState();
}

class _AnimatedHandState extends State<AnimatedHand>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  @override
  void initState() {
    super.initState();
    if (widget.playing) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant AnimatedHand oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.playing) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        // Base rotations mixed with Gemini AI semantic data
        double aiRotationX = 0.0;
        double aiRotationY = 0.0;
        
        if (widget.animationData?.semantic != null) {
          final s = widget.animationData!.semantic!;
          if (s.orientation == 'PALM_FORWARD') aiRotationX = 0.1;
          if (s.orientation == 'PALM_BACK') aiRotationX = -0.3;
          if (s.orientation == 'PALM_DOWN') aiRotationX = 0.5;
        }
        
        final wave = widget.gesture.toUpperCase().contains('SALOM')
            ? math.sin(_controller.value * math.pi * 2) * 0.15
            : 0.0;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(0.1 + aiRotationX)
            ..rotateY(wave + aiRotationY),
          child: CustomPaint(
            painter: _HandPainter(
              gesture: widget.gesture,
              t: _controller.value,
              animationData: widget.animationData,
            ),
            size: const Size(300, 300),
          ),
        );
      },
    );
  }
}

class _HandPainter extends CustomPainter {
  final String gesture;
  final double t;
  final GestureAnimation? animationData;

  const _HandPainter({
    required this.gesture,
    required this.t,
    this.animationData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 20);
    
    // Shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, size.height - 18), width: 170, height: 28),
      Paint()..color = Colors.black.withValues(alpha: 0.2),
    );

    final palm = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF444444), Color(0xFF111111)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: 100));

    final outline = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Drawing Palm
    final palmRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center.translate(0, 18), width: 130, height: 155),
      const Radius.circular(52),
    );
    canvas.drawRRect(palmRect, palm);
    canvas.drawRRect(palmRect, outline);

    // Fingers Logic
    final fingerXs = [-48.0, -16.0, 16.0, 48.0];
    for (var i = 0; i < 4; i++) {
      final baseY = center.dy - 40;
      
      // Determine pose per finger from semantic data
      String pose = 'RELAXED';
      if (animationData?.fingerPose != null) {
        if (i == 0) pose = animationData!.fingerPose!.index;
        if (i == 1) pose = animationData!.fingerPose!.middle;
        if (i == 2) pose = animationData!.fingerPose!.ring;
        if (i == 3) pose = animationData!.fingerPose!.pinky;
      } else {
        // Fallback to gesture-based logic
        if (gesture.toUpperCase().contains('SALOM')) pose = 'OPEN';
        if (gesture.toUpperCase().contains('SIZ')) pose = i == 0 ? 'OPEN' : 'CLOSED';
      }

      final profile = FingerPoseLibrary.getProfile(pose);
      // Simplify: use first joint for length and angle in this 2D painter
      final j0 = profile.joints[0];
      
      double len = pose == 'OPEN' ? 100.0 : (pose == 'CLOSED' ? 50.0 : 80.0);
      double angle = (i - 1.5) * 0.1 + (j0.y * 0.5);

      final base = Offset(center.dx + fingerXs[i], baseY);
      final tip = Offset(
        base.dx + math.sin(angle) * len,
        base.dy - math.cos(angle) * len,
      );

      final path = Path()..moveTo(base.dx, base.dy);
      path.cubicTo(
        base.dx - 2,
        base.dy - len * 0.45,
        tip.dx + 2,
        tip.dy + len * 0.12,
        tip.dx,
        tip.dy,
      );

      final fingerPaint = Paint()
        ..color = Colors.white.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 24
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(path, fingerPaint);
      canvas.drawCircle(tip, 12, palm);
    }

    // Thumb logic
    String thumbPose = animationData?.fingerPose?.thumb ?? 'RELAXED';
    final thumbPaint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 26
      ..strokeCap = StrokeCap.round;
    
    final thumbWave = thumbPose == 'OPEN' ? math.sin(t * math.pi * 2) * 8 : 0;
    final thumb = Path()
      ..moveTo(center.dx - 52, center.dy + 24)
      ..quadraticBezierTo(center.dx - 86, center.dy + 2 + thumbWave, center.dx - 70, center.dy - 28);
    canvas.drawPath(thumb, thumbPaint);
  }

  @override
  bool shouldRepaint(covariant _HandPainter oldDelegate) => true;
}
