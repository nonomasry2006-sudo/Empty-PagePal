import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blur;
  final Color? tint;
  final Border? border;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;
  final Gradient? glowGradient;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSizes.p16),
    this.margin,
    this.width,
    this.height,
    this.borderRadius = AppSizes.r24,
    this.blur = 18,
    this.tint,
    this.border,
    this.onTap,
    this.boxShadow,
    this.glowGradient,
  });

  @override
  Widget build(BuildContext context) {
    final glassColor = tint ?? AppColors.glassStrong;
    final glassBorder = border ?? Border.all(color: AppColors.glassBorder, width: 1.2);
    final shadows = boxShadow ??
        [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ];

    final content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: glassColor,
            gradient: glowGradient,
            borderRadius: BorderRadius.circular(borderRadius),
            border: glassBorder,
            boxShadow: shadows,
          ),
          child: child,
        ),
      ),
    );

    if (onTap == null) {
      return Padding(padding: margin ?? EdgeInsets.zero, child: content);
    }

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: AppColors.primary.withValues(alpha: 0.12),
          highlightColor: AppColors.primary.withValues(alpha: 0.06),
          child: content,
        ),
      ),
    );
  }
}