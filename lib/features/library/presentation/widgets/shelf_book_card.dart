import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Added to use context.read
import 'package:page_pal/features/library/cubit/library_cubit.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../models/shelf_book_model.dart';


class ShelfBookCard extends StatelessWidget {
  final ShelfBookModel shelfBook;
  final VoidCallback onTap;

  const ShelfBookCard({
    super.key,
    required this.shelfBook,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final book = shelfBook.book;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      // Wrapped the card in Dismissible for swipe-to-delete
      child: Dismissible(
        key: Key(book.id), // Unique key so Flutter knows exactly which book is being swiped
        direction: DismissDirection.endToStart, // Only allow swiping from right to left
        
        // The red background that reveals underneath as you swipe
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red.shade800.withOpacity(0.9), // Matches the dark theme aesthetic
            borderRadius: BorderRadius.circular(16), // Matches typical GlassCard radius
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 30,
          ),
        ),
        
        // The action triggered when the swipe is fully completed
        onDismissed: (direction) {
          context.read<LibraryCubit>().removeBook(book.id);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${book.title} removed from library'),
              backgroundColor: Colors.grey[900],
              duration: const Duration(seconds: 2),
            ),
          );
        },
        
        // Your original UI remains completely untouched here
        child: GestureDetector(
          onTap: onTap,
          child: GlassCard(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Book Cover
                  Container(
                    width: 65,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black26,
                    ),
                    child: book.coverUrl != null && book.coverUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              book.coverUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.book, color: Colors.white54),
                            ),
                          )
                        : const Icon(Icons.book, color: Colors.white54),
                  ),
                  const SizedBox(width: 16),

                  // Book Info & Progress
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book.author,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),

                        // Golden Progress Indicator
                        Row(
                          children: [
                            const Icon(Icons.menu_book, color: Colors.amber, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'Page ${shelfBook.currentPage}',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
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
}