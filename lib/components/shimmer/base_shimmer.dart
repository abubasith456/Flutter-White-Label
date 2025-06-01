import 'package:flutter/material.dart';

// class BaseShimmer extends StatefulWidget {
//   final Widget? child;

//   const BaseShimmer({super.key}) : child = null;

//   const BaseShimmer.child({super.key, required this.child});

//   @override
//   State<BaseShimmer> createState() => _BaseShimmerState();
// }

// class _BaseShimmerState extends State<BaseShimmer>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     )..repeat();
//     _animation = Tween<double>(begin: -2, end: 2).animate(_controller);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _buildShimmerEffect(child: widget.child ?? Container());
//   }

//   Widget _buildShimmerEffect({
//     required Widget child,
//     EdgeInsetsGeometry? margin,
//   }) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Container(
//           margin: margin,
//           child: ShaderMask(
//             blendMode: BlendMode.srcATop,
//             shaderCallback: (bounds) {
//               return LinearGradient(
//                 colors: const [
//                   Color(0xFFE0E0E0),
//                   Color(0xFFF5F5F5),
//                   Color(0xFFE0E0E0),
//                 ],
//                 stops: const [0.1, 0.3, 0.4],
//                 begin: Alignment(_animation.value, -1),
//                 end: const Alignment(-1, 1),
//                 tileMode: TileMode.clamp,
//               ).createShader(bounds);
//             },
//             child: child,
//           ),
//         );
//       },
//       child: child,
//     );
//   }
// }

class BaseShimmerEffect extends StatefulWidget {
  final Widget child;
  const BaseShimmerEffect({super.key, required this.child});

  @override
  State<BaseShimmerEffect> createState() => _BaseShimmerEffectState();
}

class _BaseShimmerEffectState extends State<BaseShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(_controller);
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
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                Color(0xFFE0E0E0),
                Color(0xFFF5F5F5),
                Color(0xFFE0E0E0),
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
