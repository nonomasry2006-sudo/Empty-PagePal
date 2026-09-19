import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/glow_button.dart';
import '../../../library/cubit/library_cubit.dart';
import '../../../library/cubit/library_state.dart';
import '../../../library/models/shelf_book_model.dart';
import '../../models/book_model.dart';

class AddToLibraryButton extends StatelessWidget {
  final BookModel book;
  const AddToLibraryButton({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryCubit, LibraryState>(
      builder: (context, state) {
        final shelfName = _shelfNameOf(state, book.id);

        if (shelfName != null) {
          return _AddedIndicator(shelfName: shelfName);
        }

        return GlowButton(
          label: 'Add to Library',
          icon: Icons.add_rounded,
          onPressed: () => _showShelfPicker(context, book),
        );
      },
    );
  }

  String? _shelfNameOf(LibraryState state, String bookId) {
    if (state is! LibraryLoaded) return null;
    if (state.wantToRead.any((b) => b.book.id == bookId)) return 'Want to Read';
    if (state.reading.any((b) => b.book.id == bookId)) return 'Reading';
    if (state.finished.any((b) => b.book.id == bookId)) return 'Finished';
    return null;
  }

  void _showShelfPicker(BuildContext context, BookModel book) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ShelfPickerSheet(book: book),
    );
  }
}

class _ShelfPickerSheet extends StatelessWidget {
  final BookModel book;
  const _ShelfPickerSheet({required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF14281D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              'Add to Shelf',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              book.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),

            // Shelf options
            _ShelfOption(
              icon: Icons.bookmark_border_rounded,
              label: 'Want to Read',
              color: const Color(0xFFF2CC8F),
              onTap: () => _addTo(context, ShelfStatus.wantToRead, 'Want to Read'),
            ),
            const SizedBox(height: 10),
            _ShelfOption(
              icon: Icons.menu_book_rounded,
              label: 'Reading',
              color: const Color(0xFF52B788),
              onTap: () => _addTo(context, ShelfStatus.reading, 'Reading'),
            ),
            const SizedBox(height: 10),
            _ShelfOption(
              icon: Icons.check_circle_outline_rounded,
              label: 'Finished',
              color: const Color(0xFF95D5B2),
              onTap: () => _addTo(context, ShelfStatus.finished, 'Finished'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _addTo(BuildContext context, ShelfStatus status, String label) {
    final shelfBook = ShelfBookModel(
      book: book,
      status: status,
      currentPage: 0,
      addedAt: DateTime.now(),
    );

    context.read<LibraryCubit>().addBook(shelfBook);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "${book.title}" to $label'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _ShelfOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShelfOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddedIndicator extends StatelessWidget {
  final String shelfName;
  const _AddedIndicator({required this.shelfName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            'Added to $shelfName',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}