import 'package:flutter/material.dart';
import 'dart:math';

class DoveTrail extends StatefulWidget {
  final double width;
  final double height;
  final Duration loopDuration;
  final Color glow;
  const DoveTrail({super.key, required this.width, required this.height, this.loopDuration = const Duration(seconds: 6), this.glow = Colors.white});

  @override
  State<DoveTrail> createState() => _DoveTrailState();
}

class _DoveTrailState extends State<DoveTrail> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_TrailPoint> _trail = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.loopDuration)..repeat();
    _controller.addListener(() {
      final t = _controller.value;
      final p1 = _posOnRect(t, widget.width, widget.height);
      final p2 = _posOnRect((t + 0.5) % 1.0, widget.width, widget.height);
      final now = DateTime.now().millisecondsSinceEpoch;
      setState(() {
        _trail.add(_TrailPoint(p1, now));
        _trail.add(_TrailPoint(p2, now));
        final cutoff = now - widget.loopDuration.inMilliseconds * 2;
        _trail.removeWhere((e) => e.timestamp < cutoff);
      });
    });
  }

  Offset _posOnRect(double t, double w, double h) {
    final per = 2 * (w + h);
    final dist = per * t;
    double x=0,y=0;
    if (dist <= w) { x = dist; y = 0; }
    else if (dist <= w + h) { x = w; y = dist - w; }
    else if (dist <= w + h + w) { x = w - (dist - w - h); y = h; }
    else { x = 0; y = h - (dist - w - h - w); }
    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(widget.width, widget.height), painter: _DovePainter(_trail, widget.glow));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _TrailPoint { final Offset pos; final int timestamp; _TrailPoint(this.pos, this.timestamp); }

class _DovePainter extends CustomPainter {
  final List<_TrailPoint> trail;
  final Color glow;
  _DovePainter(this.trail, this.glow);

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now().millisecondsSinceEpoch;
    for (int i=0;i<trail.length;i++){
      final p = trail[i];
      final age = (now - p.timestamp).clamp(0,3000);
      final opacity = 1.0 - (age/3000.0);
      final paint = Paint()..color = glow.withOpacity(opacity * 0.85)..style = PaintingStyle.stroke..strokeWidth = 3;
      canvas.drawCircle(p.pos, 2.0 + (opacity * 1.5), paint);
    }
    if (trail.isNotEmpty) {
      final last = trail.last.pos;
      final paint = Paint()..color = glow..style = PaintingStyle.fill;
      canvas.drawCircle(last, 6.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DovePainter old) => true;
}
