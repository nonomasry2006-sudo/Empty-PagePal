import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'animated_scale.dart';

class GlowButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final Gradient? gradient;
  final Color? glowColor;

  const GlowButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.gradient,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final grad = gradient ?? AppColors.primaryGradient;
    final glow = glowColor ?? grad.colors.last.withValues(alpha: 0.5);

    return AnimatedScaleTap(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: fullWidth ? double.infinity : null,
        height: AppSizes.buttonHeight,
        decoration: BoxDecoration(
          gradient: onPressed == null ? null : grad,
          color: onPressed == null ? Colors.grey.withValues(alpha: 0.3) : null,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          boxShadow: onPressed == null
              ? null
              : [
                  BoxShadow(
                    color: glow,
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                    spreadRadius: -4,
                  ),
                  BoxShadow(
                    color: glow.withValues(alpha: 0.3),
                    blurRadius: 40,
                    spreadRadius: -8,
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}