import 'package:flutter/material.dart';

class AnimatedDragon extends StatefulWidget {
  final String emoji;
  final double size;
  final VoidCallback? onTap;

  const AnimatedDragon({
    Key? key,
    required this.emoji,
    this.size = 120,
    this.onTap,
  }) : super(key: key);

  @override
  _AnimatedDragonState createState() => _AnimatedDragonState();
}

class _AnimatedDragonState extends State<AnimatedDragon>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _scaleController;
  late Animation<double> _floatAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _floatAnimation = Tween<double>(
      begin: -5.0,
      end: 5.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          _scaleController.forward().then((_) {
            _scaleController.reverse();
          });
          widget.onTap!();
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_floatAnimation, _scaleAnimation]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  widget.emoji,
                  style: TextStyle(fontSize: widget.size),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}