import 'package:flutter/material.dart';

class ScoreBar extends StatefulWidget {
  final num currentScore;
  final num maxScore;
  final double barSize;
  final double textSize;
  final String? labelText;
  final double scoreBarWidth;
  final Color backgroundColor;
  final Color valueColor;
  final double screenWidth;
  final double screenHeight;

  const ScoreBar({
    super.key,
    required this.currentScore,
    this.maxScore = 20.0,
    this.barSize = 30,
    this.textSize = 25,
    this.labelText,
    this.scoreBarWidth = 0.9,
    this.backgroundColor = const Color(0xFF96AABA),
    this.valueColor = const Color(0xFF1B3548),
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<ScoreBar> createState() => _ScoreBarState();
}

class _ScoreBarState extends State<ScoreBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue =
    widget.maxScore != 0
        ? (widget.currentScore / widget.maxScore).clamp(0.0, 1.0)
        : 0.0;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: _previousValue,
      end:
      widget.maxScore != 0
          ? (widget.currentScore / widget.maxScore).clamp(0.0, 1.0)
          : 0.0,
    ).animate(_controller)..addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void didUpdateWidget(ScoreBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentScore != widget.currentScore) {
      _previousValue = _animation.value;
      _animation = Tween<double>(
        begin: _previousValue,
        end:
        widget.maxScore != 0
            ? (widget.currentScore / widget.maxScore).clamp(0.0, 1.0)
            : 0.0,
      ).animate(_controller)..addListener(() {
        setState(() {});
      });
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.screenHeight * 0.048,
      width: MediaQuery.of(context).size.width * widget.scoreBarWidth,
      padding: EdgeInsets.symmetric(horizontal: widget.screenHeight * 0.006),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: LinearProgressIndicator(
                  backgroundColor: widget.backgroundColor,
                  valueColor: AlwaysStoppedAnimation(widget.valueColor),
                  value: _animation.value,
                  minHeight: widget.barSize,
                ),
              ),
              if (widget.labelText != null)
                Center(
                  child: Text(
                    widget.labelText!,
                    style: TextStyle(
                      fontSize: widget.textSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
