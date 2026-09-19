import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/library_cubit.dart';
import '../../models/shelf_book_model.dart';

class EditProgressSheet extends StatefulWidget {
  final ShelfBookModel shelfBook;
  // Let's pass the max pages. If Noor's API doesn't have max pages, we can default to 300 for testing.
  final int totalPages; 

  const EditProgressSheet({
    super.key,
    required this.shelfBook,
    this.totalPages = 300, 
  });

  @override
  State<EditProgressSheet> createState() => _EditProgressSheetState();
}

class _EditProgressSheetState extends State<EditProgressSheet> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.shelfBook.currentPage.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Update Progress',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.shelfBook.book.title,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // The Progress Slider
          Row(
            children: [
              const Text('0', style: TextStyle(color: Colors.white54)),
              Expanded(
                child: Slider(
                  value: _currentValue,
                  min: 0,
                  max: widget.totalPages.toDouble(),
                  activeColor: Colors.amber,
                  inactiveColor: Colors.white24,
                  divisions: widget.totalPages,
                  label: _currentValue.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _currentValue = value;
                    });
                  },
                ),
              ),
              Text('${widget.totalPages}', style: const TextStyle(color: Colors.white54)),
            ],
          ),
          
          Text(
            'Page ${_currentValue.round()} of ${widget.totalPages}',
            style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 32),
          
          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                context.read<LibraryCubit>().updateBookProgress(
                  widget.shelfBook, 
                  _currentValue.round(),
                );
                Navigator.pop(context);
              },
              child: const Text('Save Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}