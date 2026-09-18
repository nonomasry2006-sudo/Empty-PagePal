import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_pal/features/library/cubit/library_cubit.dart';
import 'package:page_pal/features/library/cubit/library_state.dart';
import 'package:page_pal/features/library/models/shelf_book_model.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../widgets/shelf_book_card.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LibraryCubit>().loadLibrary();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: GradientBackground(
          child: Column(
            children: [
              const CustomAppBar(title: 'My Library'),
              const TabBar(
                indicatorColor: Colors.amber,
                tabs: [
                  Tab(text: 'Reading'),
                  Tab(text: 'Want to Read'),
                  Tab(text: 'Finished'),
                ],
              ),
              Expanded(
                child: BlocBuilder<LibraryCubit, LibraryState>(
                  builder: (context, state) {
                    if (state is LibraryLoading) {
                      return const LoadingWidget();
                    } else if (state is LibraryEmpty) {
                      return const EmptyWidget(title: 'Your library is empty. Go explore!');
                    } else if (state is LibraryError) {
                      return Center(
                        child: Text(state.message, style: const TextStyle(color: Colors.red)),
                      );
                    } else if (state is LibraryLoaded) {
                      return TabBarView(
                        children: [
                          _buildShelf(state.reading),
                          _buildShelf(state.wantToRead),
                          _buildShelf(state.finished),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShelf(List<ShelfBookModel> books) {
    if (books.isEmpty) {
      return const Center(
        child: Text('No books here yet.', style: TextStyle(color: Colors.white70)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return ShelfBookCard(
          shelfBook: book,
          onTap: () => _showMoveBookBottomSheet(context, book),
        );
      },
    );
  }

  void _showMoveBookBottomSheet(BuildContext context, ShelfBookModel book) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Move "${book.book.title}" to:',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildShelfOption(
              context,
              'Reading',
              ShelfStatus.reading,
              book,
            ),
            _buildShelfOption(
              context,
              'Want to Read',
              ShelfStatus.wantToRead,
              book,
            ),
            _buildShelfOption(
              context,
              'Finished',
              ShelfStatus.finished,
              book,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildShelfOption(
    BuildContext context,
    String label,
    ShelfStatus status,
    ShelfBookModel book,
  ) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward, color: Colors.amber),
      onTap: () {
        context.read<LibraryCubit>().updateShelfStatus(book, status);
        Navigator.pop(context);
      },
    );
  }
}