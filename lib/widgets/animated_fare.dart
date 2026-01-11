 import 'package:flutter/material.dart';

class AnimatedLine extends StatefulWidget {
  final double progress;
  final Color color;
  final double height;

  const AnimatedLine({
    super.key,
    required this.progress,
    this.color = Colors.green,
    this.height = 4,
  });

  @override
  State<AnimatedLine> createState() => _AnimatedLineState();
}

class _AnimatedLineState extends State<AnimatedLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return FractionallySizedBox(
          widthFactor: widget.progress * _animation.value,
          child: Container(
            height: widget.height,
            color: widget.color,
          ),
        );
      },
    );
  }
}
