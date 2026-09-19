import 'dart:math' as math;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/library_cubit.dart';
import '../../models/shelf_book_model.dart';

class ProgressSheet extends StatefulWidget {
  final ShelfBookModel shelfBook;

  const ProgressSheet({super.key, required this.shelfBook});

  static Future<void> show(BuildContext context, ShelfBookModel shelfBook) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: false,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (_) => ProgressSheet(shelfBook: shelfBook),
    );
  }

  @override
  State<ProgressSheet> createState() => _ProgressSheetState();
}

class _ProgressSheetState extends State<ProgressSheet>
    with TickerProviderStateMixin {
  late int _currentPage;
  late int _totalPages;

  late final AnimationController _fireflyController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.shelfBook.currentPage;
    _totalPages = widget.shelfBook.book.pageCount ?? 100;

    _fireflyController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _fireflyController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  double get _progress {
    if (_totalPages <= 0) return 0;
    return (_currentPage / _totalPages).clamp(0.0, 1.0);
  }

  int get _percent => (_progress * 100).round();

  void _save() {
    context.read<LibraryCubit>().updateBookProgress(
          widget.shelfBook,
          _currentPage,
        );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Progress updated to page $_currentPage'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final book = widget.shelfBook.book;
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;

    return Stack(
      children: [
        // 1. Blurred cover backdrop
        if (book.coverUrl != null)
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Opacity(
                opacity: 0.18,
                child: CachedNetworkImage(
                  imageUrl: book.coverUrl!,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),

        // 2. Main sheet
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F2419),
                Color(0xFF0B1F14),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: primary.withValues(alpha: 0.25),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: -10,
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Stack(
              children: [
                // 3. Fireflies
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _fireflyController,
                      builder: (context, _) => CustomPaint(
                        painter: _FireflyPainter(
                          progress: _fireflyController.value,
                          color: secondary,
                        ),
                      ),
                    ),
                  ),
                ),

                // 4. Main content
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Handle
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primary.withValues(alpha: 0.7),
                                secondary.withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Header
                      _buildHeader(theme, book),
                      const SizedBox(height: 28),

                      // Progress ring with pulse
                      Center(
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, _) => _ProgressRing(
                            progress: _progress,
                            percent: _percent,
                            pulse: _pulseController.value,
                            primary: primary,
                            secondary: secondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Page counter with gradient
                      _buildPageCounter(theme, primary),
                      const SizedBox(height: 24),

                      // Slider
                      _buildSlider(theme, primary, secondary),
                      const SizedBox(height: 16),

                      // Quick chips
                      _buildQuickChips(primary, secondary),
                      const SizedBox(height: 20),

                      // Save button
                      _buildSaveButton(theme, primary, secondary),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme, dynamic book) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 44,
            height: 64,
            child: book.coverUrl != null
                ? CachedNetworkImage(
                    imageUrl: book.coverUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _coverPlaceholder(),
                    errorWidget: (_, __, ___) => _coverPlaceholder(),
                  )
                : _coverPlaceholder(),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 12,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'UPDATE PROGRESS',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                book.title,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (book.authors.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  book.authors.join(', '),
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageCounter(ThemeData theme, Color primary) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodyMedium,
          children: [
            TextSpan(
              text: '$_currentPage',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: primary,
                shadows: [
                  Shadow(
                    color: primary.withValues(alpha: 0.5),
                    blurRadius: 12,
                  ),
                ],
              ),
            ),
            TextSpan(
              text: '  /  $_totalPages pages',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(ThemeData theme, Color primary, Color secondary) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 6,
        activeTrackColor: primary,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.08),
        thumbColor: secondary,
        overlayColor: secondary.withValues(alpha: 0.2),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
      ),
      child: Slider(
        value: _currentPage.toDouble(),
        min: 0,
        max: _totalPages.toDouble(),
        onChanged: (value) {
          setState(() {
            _currentPage = value.round();
          });
        },
      ),
    );
  }

  Widget _buildQuickChips(Color primary, Color secondary) {
    return Row(
      children: [
        Expanded(
          child: _QuickChip(
            label: 'Start',
            icon: Icons.first_page_rounded,
            onTap: () => setState(() => _currentPage = 0),
            accent: primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _QuickChip(
            label: 'Half',
            icon: Icons.horizontal_rule_rounded,
            onTap: () => setState(
              () => _currentPage = (_totalPages / 2).round(),
            ),
            accent: primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _QuickChip(
            label: 'Finish',
            icon: Icons.last_page_rounded,
            onTap: () => setState(() => _currentPage = _totalPages),
            accent: secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(ThemeData theme, Color primary, Color secondary) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: secondary.withValues(alpha: 0.2),
            blurRadius: 40,
            spreadRadius: -8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _save,
          borderRadius: BorderRadius.circular(16),
          child: const SizedBox(
            height: 54,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_rounded, color: Colors.black87),
                  SizedBox(width: 8),
                  Text(
                    'Save Progress',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _coverPlaceholder() {
    return Container(
      color: Colors.white.withValues(alpha: 0.08),
      child: const Icon(Icons.book, color: Colors.white54, size: 20),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAGICAL PROGRESS RING
// ─────────────────────────────────────────────────────────────────────────────

class _ProgressRing extends StatelessWidget {
  final double progress;
  final int percent;
  final double pulse;
  final Color primary;
  final Color secondary;

  const _ProgressRing({
    required this.progress,
    required this.percent,
    required this.pulse,
    required this.primary,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    // Pulse interpolates 0.0 → 1.0 for a soft breathing glow
    final glowSize = 30 + (pulse * 20);
    final glowOpacity = 0.2 + (pulse * 0.25);

    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow halo
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  primary.withValues(alpha: glowOpacity),
                  secondary.withValues(alpha: glowOpacity * 0.4),
                  Colors.transparent,
                ],
                stops: const [0.5, 0.75, 1.0],
              ),
            ),
          ),

          // Pulsing box shadow
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: glowOpacity * 0.6),
                  blurRadius: glowSize,
                  spreadRadius: pulse * 4,
                ),
              ],
            ),
          ),

          // Background ring
          SizedBox(
            width: 140,
            height: 140,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 8,
              valueColor: AlwaysStoppedAnimation(
                Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),

          // Foreground progress arc with gradient
          SizedBox(
            width: 140,
            height: 140,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return ShaderMask(
                  shaderCallback: (bounds) => SweepGradient(
                    startAngle: -math.pi / 2,
                    endAngle: 3 * math.pi / 2,
                    colors: [
                      primary,
                      secondary,
                      primary,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ).createShader(bounds),
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 8,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.transparent,
                  ),
                );
              },
            ),
          ),

          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.white, secondary],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: Text(
                  '$percent',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1,
                    letterSpacing: -1,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'percent',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// QUICK CHIP
// ─────────────────────────────────────────────────────────────────────────────

class _QuickChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color accent;

  const _QuickChip({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: accent.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: accent),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FIREFLY PAINTER
// ─────────────────────────────────────────────────────────────────────────────

class _FireflyPainter extends CustomPainter {
  final double progress;
  final Color color;

  _FireflyPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const count = 50;
    final rand = math.Random(7);

    for (var i = 0; i < count; i++) {
      final baseX = rand.nextDouble() * size.width;
      final baseY = rand.nextDouble() * size.height;
      final phase = rand.nextDouble() * math.pi * 2;
      final speed = 0.2 + rand.nextDouble() * 0.6;
      final radius = 1.2 + rand.nextDouble() * 1.8;

      final dx = math.sin(progress * math.pi * 2 * speed + phase) * 24;
      final dy = math.cos(progress * math.pi * 2 * speed + phase) * 16;

      final flicker =
          0.4 + 0.6 * (0.5 + 0.5 * math.sin(progress * math.pi * 8 + phase));

      // Outer glow
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.15 * flicker)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawCircle(
        Offset(baseX + dx, baseY + dy),
        radius * 3,
        glowPaint,
      );

      // Core
      final corePaint = Paint()
        ..color = color.withValues(alpha: 0.7 * flicker)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);

      canvas.drawCircle(
        Offset(baseX + dx, baseY + dy),
        radius,
        corePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FireflyPainter old) =>
      old.progress != progress;
}