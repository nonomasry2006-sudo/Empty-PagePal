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
import '../widgets/edit_progress_sheet.dart';

<<<<<<< HEAD
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_background.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});
=======
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
>>>>>>> dev

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('My Library'),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
          tabs: const [
            Tab(text: 'Reading'),
            Tab(text: 'Want'),
            Tab(text: 'Finished'),
          ],
        ),
      ),
      body: GradientBackground(
        showFireflies: false,
        child: SafeArea(
          child: TabBarView(
            controller: _tabs,
            children: const [
              _ShelfList(),
              _ShelfList(),
              _ShelfList(),
=======
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.read<LibraryCubit>().addDummyBook();
          },
          backgroundColor: Colors.amber,
          icon: const Icon(Icons.add, color: Colors.black),
          label: const Text(
            'Add Test Book', 
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
          ),
        ),
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
>>>>>>> dev
            ],
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
}

class _ShelfList extends StatelessWidget {
  const _ShelfList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => GlassCard(
        child: Row(
          children: [
            Container(
              width: 46,
              height: 66,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.secondary
                    .withValues(alpha: 0.25),
              ),
              child: const Icon(Icons.book_outlined),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shelf Book ${i + 1}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  const LinearProgressIndicator(
                    value: 0.5,
                    minHeight: 5,
                    borderRadius: BorderRadius.all(Radius.circular(99)),
                  ),
                ],
              ),
            ),
=======

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
        return GestureDetector(
          onLongPress: () => _showMoveBookBottomSheet(context, book),
          child: ShelfBookCard(
            shelfBook: book,
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: const Color(0xFF1a1a1a),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => EditProgressSheet(shelfBook: book),
              );
            },
          ),
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
>>>>>>> dev
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

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
>>>>>>> dev
}