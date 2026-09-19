import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../data/note_repository.dart';
import '../models/note_model.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final NoteRepository _repository;
  final Uuid _uuid = const Uuid();

  NotesCubit(this._repository) : super(NotesInitial());

  Future<void> loadForBook(String bookId) async {
    emit(NotesLoading());
    final (notes, failure) = await _repository.getNotesForBook(bookId);
    if (isClosed) return;

    if (failure != null) {
      emit(NotesError(failure.message));
    } else if (notes == null || notes.isEmpty) {
      emit(NotesEmpty());
    } else {
      notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(NotesLoaded(notes));
    }
  }

  Future<void> loadAll() async {
    emit(NotesLoading());
    final (notes, failure) = await _repository.getAllNotes();
    if (isClosed) return;

    if (failure != null) {
      emit(NotesError(failure.message));
    } else if (notes == null || notes.isEmpty) {
      emit(NotesEmpty());
    } else {
      notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(NotesLoaded(notes));
    }
  }

  Future<void> addNote({
    required String bookId,
    required String bookTitle,
    required String text,
  }) async {
    final note = NoteModel(
      id: _uuid.v4(),
      bookId: bookId,
      bookTitle: bookTitle,
      text: text,
      createdAt: DateTime.now(),
    );

    final failure = await _repository.addNote(note);
    if (isClosed) return;

    if (failure != null) {
      emit(NotesError(failure.message));
    } else {
      await loadForBook(bookId);
    }
  }

  Future<void> deleteNote({
    required String id,
    required String bookId,
  }) async {
    final failure = await _repository.deleteNote(id);
    if (isClosed) return;

    if (failure != null) {
      emit(NotesError(failure.message));
    } else {
      await loadForBook(bookId);
    }
  }
}