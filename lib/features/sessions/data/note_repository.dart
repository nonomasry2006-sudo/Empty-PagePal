import '../../../../core/errors/failures.dart';
import '../models/note_model.dart';
import 'note_local_data_source.dart';

abstract class NoteRepository {
  Future<(List<NoteModel>?, Failure?)> getAllNotes();
  Future<(List<NoteModel>?, Failure?)> getNotesForBook(String bookId);
  Future<Failure?> addNote(NoteModel note);
  Future<Failure?> updateNote(NoteModel note);
  Future<Failure?> deleteNote(String id);
}

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource _local;

  NoteRepositoryImpl(this._local);

  @override
  Future<(List<NoteModel>?, Failure?)> getAllNotes() async {
    try {
      final notes = _local.getAllNotes();
      return (notes, null);
    } catch (e) {
      return (null, const ServerFailure('Failed to load notes'));
    }
  }

  @override
  Future<(List<NoteModel>?, Failure?)> getNotesForBook(String bookId) async {
    try {
      final notes = _local.getNotesForBook(bookId);
      return (notes, null);
    } catch (e) {
      return (null, const ServerFailure('Failed to load notes'));
    }
  }

  @override
  Future<Failure?> addNote(NoteModel note) async {
    try {
      await _local.addNote(note);
      return null;
    } catch (e) {
      return const ServerFailure('Failed to save note');
    }
  }

  @override
  Future<Failure?> updateNote(NoteModel note) async {
    try {
      await _local.updateNote(note);
      return null;
    } catch (e) {
      return const ServerFailure('Failed to update note');
    }
  }

  @override
  Future<Failure?> deleteNote(String id) async {
    try {
      await _local.deleteNote(id);
      return null;
    } catch (e) {
      return const ServerFailure('Failed to delete note');
    }
  }
}