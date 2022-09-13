import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_app/domain/util/note_order.dart';

import '../../domain/model/note.dart';

part 'notes_event.freezed.dart';

@freezed
class NotesEvent<T> with _$NotesEvent<T> {
  const factory NotesEvent.loadNotes() = LoadNotes;
  const factory NotesEvent.deleteNote(Note note) = DeleteNote;
  const factory NotesEvent.restoreNote() = RestoreNote;
  const factory NotesEvent.changeOrder(NoteOrder noteOrder) = ChangeOrder;
  const factory NotesEvent.toggleOrderSection() = ToggleOrderSection;
}
