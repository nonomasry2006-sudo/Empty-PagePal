import 'package:hive/hive.dart';

import '../models/note_model.dart';

class NoteLocalDataSource {
  Box<NoteModel> get _notesBox => Hive.box<NoteModel>('notes');

  List<NoteModel> getAllNotes() {
    return _notesBox.values.toList();
  }

  List<NoteModel> getNotesForBook(String bookId) {
    return _notesBox.values
        .where((note) => note.bookId == bookId)
        .toList();
  }

  Future<void> addNote(NoteModel note) async {
    await _notesBox.put(note.id, note);
    await _notesBox.flush();
  }

  Future<void> updateNote(NoteModel note) async {
    await _notesBox.put(note.id, note);
    await _notesBox.flush();
  }

  Future<void> deleteNote(String id) async {
    await _notesBox.delete(id);
    await _notesBox.flush();
  }
}