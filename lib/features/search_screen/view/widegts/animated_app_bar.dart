import 'package:flutter/material.dart';
import 'package:zoyo_bathware/constants/app_colors.dart';
import 'package:zoyo_bathware/widgets/custom_widgets/back_botton.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class AnimatedAppBar extends StatelessWidget {
  const AnimatedAppBar({
    super.key,
    required Animation<double> fadeAnimation,
    required Animation<double> scaleAnimation,
    required this.context,
    required this.responsive,
  }) : _fadeAnimation = fadeAnimation, _scaleAnimation = scaleAnimation;

  final Animation<double> _fadeAnimation;
  final Animation<double> _scaleAnimation;
  final BuildContext context;
  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: responsive.hp(12),
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primaryColor,
      leading: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: backButton(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            "Search Products",
            style: TextStyle(
              fontSize: responsive.sp(20),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
