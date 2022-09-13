import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_app/domain/util/note_order.dart';

import '../../domain/model/note.dart';

part 'notes_state.freezed.dart';

@freezed
class NotesState with _$NotesState {
  const factory NotesState({
    @Default([]) List<Note> notes,
    required NoteOrder noteOrder,
  }) = _NotesState;
}
