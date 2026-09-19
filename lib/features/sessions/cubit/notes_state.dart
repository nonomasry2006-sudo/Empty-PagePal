import 'package:equatable/equatable.dart';

import '../models/note_model.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesEmpty extends NotesState {}

class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object?> get props => [message];
}

class NotesLoaded extends NotesState {
  final List<NoteModel> notes;

  const NotesLoaded(this.notes);

  @override
  List<Object?> get props => [notes];
}