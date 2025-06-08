import 'package:flutter/material.dart';

class BaseShimmerEffect extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color? baseColor;
  final Color? highlightColor;
  final Color? shadowColor;

  const BaseShimmerEffect({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor,
    this.highlightColor,
    this.shadowColor,
  });

  @override
  State<BaseShimmerEffect> createState() => _BaseShimmerEffectState();
}

class _BaseShimmerEffectState extends State<BaseShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                widget.baseColor ?? Colors.grey[300]!,
                widget.highlightColor ?? Colors.grey[100]!,
                widget.baseColor ?? Colors.grey[300]!,
              ],
              stops: const [0.1, 0.3, 0.4],
              begin: Alignment(_animation.value, -1),
              end: const Alignment(-1, 1),
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// Brand-specific shimmer variants
class ShimmerVariants {
  static BaseShimmerEffect forCurrentBrand({
    required Widget child,
    Duration? duration,
  }) {
    return BaseShimmerEffect(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      shadowColor: Colors.grey[400],
      duration: duration ?? const Duration(milliseconds: 1500),
      child: child,
    );
  }

  static BaseShimmerEffect subtle({required Widget child, Duration? duration}) {
    return BaseShimmerEffect(
      baseColor: Colors.grey[200],
      highlightColor: Colors.white,
      shadowColor: Colors.grey[300],
      duration: duration ?? const Duration(milliseconds: 2000),
      child: child,
    );
  }

  static BaseShimmerEffect prominent({
    required Widget child,
    Duration? duration,
  }) {
    return BaseShimmerEffect(
      baseColor: Colors.grey[400],
      highlightColor: Colors.grey[200],
      shadowColor: Colors.grey[500],
      duration: duration ?? const Duration(milliseconds: 1200),
      child: child,
    );
  }
}
