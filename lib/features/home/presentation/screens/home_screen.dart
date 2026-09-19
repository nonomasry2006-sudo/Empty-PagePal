import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../library/cubit/library_cubit.dart';
import '../../../library/cubit/library_state.dart';
import '../../../library/models/shelf_book_model.dart';
import '../../../library/presentation/widgets/progress_sheet.dart';
import '../../../sessions/cubit/notes_cubit.dart';
import '../../../sessions/cubit/notes_state.dart';
import '../../../sessions/presentation/widgets/note_card.dart';
import '../../../sessions/presentation/widgets/note_form_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('PagePal'),
        actions: [
          IconButton(
            onPressed: () => context.push(RouteNames.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: GradientBackground(
        showFireflies: false,
        child: SafeArea(
          child: BlocBuilder<LibraryCubit, LibraryState>(
            builder: (context, state) {
              if (state is LibraryInitial || state is LibraryLoading) {
                return const LoadingWidget();
              }

              if (state is LibraryError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                );
              }

              if (state is LibraryEmpty) {
                return const _EmptyHome();
              }

              if (state is LibraryLoaded) {
                return _LoadedHome(state: state);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _LoadedHome extends StatelessWidget {
  final LibraryLoaded state;
  const _LoadedHome({required this.state});

  @override
  Widget build(BuildContext context) {
    final booksRead = state.finished.length;
    final wantToReadCount = state.wantToRead.length;

    final currentlyReading =
        state.reading.isNotEmpty ? state.reading.first : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good evening, Reader',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Books Read',
                  value: '$booksRead',
                  icon: Icons.check_circle_outline_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Want to Read',
                  value: '$wantToReadCount',
                  icon: Icons.bookmark_border_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          Text(
            'Currently Reading',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (currentlyReading != null) ...[
            _CurrentlyReadingCard(shelfBook: currentlyReading),
            const SizedBox(height: 24),
            _RecentNotesSection(
              bookId: currentlyReading.book.id,
              bookTitle: currentlyReading.book.title,
            ),
          ] else
            const _NoReadingPlaceholder(),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _CurrentlyReadingCard extends StatelessWidget {
  final ShelfBookModel shelfBook;

  const _CurrentlyReadingCard({required this.shelfBook});

  @override
  Widget build(BuildContext context) {
    final book = shelfBook.book;
    final theme = Theme.of(context);

    final totalPages = book.pageCount ?? 0;
    final currentPage = shelfBook.currentPage;
    final progress = totalPages > 0
        ? (currentPage / totalPages).clamp(0.0, 1.0)
        : 0.0;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 88,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withValues(alpha: 0.08),
                ),
                clipBehavior: Clip.antiAlias,
                child: book.coverUrl != null
                    ? Image.network(
                        book.coverUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.book,
                          color: Colors.white54,
                        ),
                      )
                    : const Icon(Icons.book, color: Colors.white54),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.authors.isEmpty
                          ? 'Unknown author'
                          : book.authors.join(', '),
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress', style: theme.textTheme.bodySmall),
              Text(
                totalPages > 0
                    ? 'Page $currentPage of $totalPages'
                    : 'Page $currentPage',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation(
                theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => ProgressSheet.show(context, shelfBook),
            icon: const Icon(Icons.edit_rounded, size: 18),
            label: const Text('Update Progress'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentNotesSection extends StatefulWidget {
  final String bookId;
  final String bookTitle;

  const _RecentNotesSection({
    required this.bookId,
    required this.bookTitle,
  });

  @override
  State<_RecentNotesSection> createState() => _RecentNotesSectionState();
}

class _RecentNotesSectionState extends State<_RecentNotesSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NotesCubit>().loadForBook(widget.bookId);
      }
    });
  }

  void _openAddNoteSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => NoteFormSheet(
        bookTitle: widget.bookTitle,
        onSave: (text) {
          context.read<NotesCubit>().addNote(
                bookId: widget.bookId,
                bookTitle: widget.bookTitle,
                text: text,
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Notes', style: theme.textTheme.titleLarge),
            TextButton.icon(
              onPressed: _openAddNoteSheet,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add Note'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<NotesCubit, NotesState>(
          builder: (context, state) {
            if (state is NotesLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is NotesEmpty || state is NotesInitial) {
              return GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.note_alt_outlined,
                      size: 28,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No notes yet for this book',
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap "Add Note" to write your thoughts',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (state is NotesError) {
              return GlassCard(
                padding: const EdgeInsets.all(16),
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            }

            if (state is NotesLoaded) {
              final recent = state.notes.take(2).toList();
              return Column(
                children: recent
                    .map((note) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: NoteCard(note: note),
                        ))
                    .toList(),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _NoReadingPlaceholder extends StatelessWidget {
  const _NoReadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(
            Icons.auto_stories_outlined,
            size: 32,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No book in progress',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Add a book from Explore to start reading',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHome extends StatelessWidget {
  const _EmptyHome();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories_rounded,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Your library is empty',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Head to Explore and add your first book',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () => context.go(RouteNames.explore),
              icon: const Icon(Icons.explore_rounded),
              label: const Text('Go to Explore'),
            ),
          ],
        ),
      ),
    );
  }
}