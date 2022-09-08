import 'package:flutter/material.dart';
import 'package:note_app/domain/repository/note_repository.dart';

class NoteViewModel with ChangeNotifier {
  final NoteRepository repository;

  NoteViewModel(this.repository);

  
}
