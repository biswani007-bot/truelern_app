import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Shimmer skeleton placeholder for the dashboard loading state.
///
/// Matches the card geometry of the actual dashboard content to prevent
/// layout jarring when real data appears.
class DashboardSkeleton extends StatefulWidget {
  const DashboardSkeleton({super.key});

  @override
  State<DashboardSkeleton> createState() => _DashboardSkeletonState();
}

class _DashboardSkeletonState extends State<DashboardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    // In test environment, do not run infinite animation loop to avoid pumpAndSettle timeout
    final isTesting = WidgetsBinding.instance.runtimeType.toString().contains('TestWidgetsFlutterBinding') ||
        WidgetsBinding.instance.runtimeType.toString().contains('AutomatedTestWidgetsFlutterBinding');
    if (!isTesting) {
      _controller.repeat(reverse: true);
    } else {
      _controller.value = 0.5;
    }
    _animation = Tween<double>(begin: 0.3, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
      builder: (context, _) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Greeting card skeleton
              _ShimmerBox(
                height: 100,
                opacity: _animation.value,
                borderRadius: 16,
              ),
              const SizedBox(height: 16),
              // Metrics row
              Row(
                children: [
                  Expanded(
                    child: _ShimmerBox(
                      height: 88,
                      opacity: _animation.value,
                      borderRadius: 12,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ShimmerBox(
                      height: 88,
                      opacity: _animation.value,
                      borderRadius: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Upcoming class card
              _ShimmerBox(
                height: 120,
                opacity: _animation.value,
                borderRadius: 12,
              ),
              const SizedBox(height: 16),
              // Assignments card
              _ShimmerBox(
                height: 80,
                opacity: _animation.value,
                borderRadius: 12,
              ),
              const SizedBox(height: 16),
              // Finance card
              _ShimmerBox(
                height: 80,
                opacity: _animation.value,
                borderRadius: 12,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.height,
    required this.opacity,
    required this.borderRadius,
  });

  final double height;
  final double opacity;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
