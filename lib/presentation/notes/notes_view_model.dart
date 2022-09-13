import 'package:flutter/material.dart';
import 'package:note_app/presentation/notes/notes_state.dart';

import '../../domain/model/note.dart';
import '../../domain/use_case/use_cases.dart';
import 'notes_event.dart';

class NotesViewModel with ChangeNotifier {
  final UseCases useCases;

  NotesState _state = const NotesState(notes: []);

  NotesViewModel(this.useCases) {
    _loadNotes();
  }

  NotesState get state => _state;

  Note? _recentlyDeletedNote;

  void onEvent(NotesEvent event) {
    event.when(
      loadNotes: _loadNotes,
      deleteNote: _deleteNote,
      restoreNote: _restoreNote,
    );
  }

  Future<void> _loadNotes() async {
    List<Note> notes = await useCases.getNotesUseCase();
    _state = state.copyWith(notes: notes);
    notifyListeners();
  }

  Future<void> _deleteNote(Note note) async {
    await useCases.deleteNoteUseCase(note);
    _recentlyDeletedNote = note;

    await _loadNotes();
  }

  Future<void> _restoreNote() async {
    if (_recentlyDeletedNote != null) {
      await useCases.addNoteUseCase(_recentlyDeletedNote!);
      _recentlyDeletedNote = null;
    }

    await _loadNotes();
  }
}
