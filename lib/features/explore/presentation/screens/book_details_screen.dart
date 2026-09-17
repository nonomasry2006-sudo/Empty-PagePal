import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../cubit/book_details_cubit.dart';
import '../../cubit/book_details_state.dart';
import '../../models/book_model.dart';

class BookDetailsScreen extends StatelessWidget {
  final BookModel book;
  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookDetailsCubit(
        client: DioClient(),
        initialBook: book,
      )..fetchFullDetails(),
      child: const _BookDetailsView(),
    );
  }
}

class _BookDetailsView extends StatelessWidget {
  const _BookDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: BlocBuilder<BookDetailsCubit, BookDetailsState>(
        builder: (context, state) {
          final book = _bookFromState(state);

          return Stack(
            children: [
              // Blurred cover background
              if (book.coverUrl != null)
                Positioned.fill(
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                    child: Opacity(
                      opacity: 0.20,
                      child: CachedNetworkImage(
                        imageUrl: book.coverUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),

              // Main content
              GradientBackground(
                showGlowOrbs: true,
                showFireflies: false,
                child: SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        pinned: true,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back_rounded),
                          onPressed: () => context.pop(),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _buildContent(context, book, state),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  BookModel _bookFromState(BookDetailsState state) {
    if (state is BookDetailsLoading) return state.book;
    if (state is BookDetailsError) return state.book;
    return (state as BookDetailsLoaded).book;
  }

  Widget _buildContent(
    BuildContext context,
    BookModel book,
    BookDetailsState state,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Cover
          Center(
            child: Hero(
              tag: 'book-${book.id}',
              child: Container(
                width: 200,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
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
            ),
          ),
          const SizedBox(height: 28),

          // ── Title
          Text(
            book.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),

          // ── Authors
          Text(
            book.authors.isEmpty ? 'Unknown author' : book.authors.join(', '),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 28),

          // ── Info row
          Row(
            children: [
              if (book.firstPublishYear != null)
                Expanded(
                  child: _InfoTile(
                    value: '${book.firstPublishYear}',
                    label: 'Published',
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
              if (book.firstPublishYear != null && book.pageCount != null)
                const SizedBox(width: 12),
              if (book.pageCount != null)
                Expanded(
                  child: _InfoTile(
                    value: '${book.pageCount}',
                    label: 'Pages',
                    icon: Icons.menu_book_outlined,
                  ),
                ),
            ],
          ),

          // ── Loading indicator while fetching full details
          if (state is BookDetailsLoading) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],

          // ── Description
          if (book.description != null && book.description!.isNotEmpty) ...[
            const SizedBox(height: 28),
            Text('Overview', style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.all(18),
              child: Text(
                book.description!,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
            ),
          ],

          // ── Subjects
          if (book.subjects.isNotEmpty) ...[
            const SizedBox(height: 28),
            Text('Subjects', style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: book.subjects
                  .take(10)
                  .map(
                    (s) => Chip(
                      label: Text(
                        s,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],

          // ── Placeholder footer
          const SizedBox(height: 40),
          Center(
            child: Text(
              'More features coming soon',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _coverPlaceholder() {
    return Container(
      color: Colors.white.withValues(alpha: 0.08),
      child: const Icon(Icons.book, size: 64),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _InfoTile({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}