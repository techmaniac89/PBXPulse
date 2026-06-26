import 'package:flutter/material.dart';

class PBXBeatingIcon extends StatefulWidget {
  const PBXBeatingIcon({
    required this.icon,
    required this.color,
    this.size,
    this.duration = const Duration(milliseconds: 1800),
    this.beginScale = 0.92,
    this.endScale = 1.1,
    super.key,
  });

  final IconData icon;
  final Color color;
  final double? size;
  final Duration duration;
  final double beginScale;
  final double endScale;

  @override
  State<PBXBeatingIcon> createState() => _PBXBeatingIconState();
}

class _PBXBeatingIconState extends State<PBXBeatingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
    _scale = Tween<double>(
      begin: widget.beginScale,
      end: widget.endScale,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Icon(widget.icon, color: widget.color, size: widget.size),
    );
  }
}
