import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note_app/presentation/add_edit_note/add_edit_note_event.dart';
import 'package:note_app/presentation/add_edit_note/add_edit_note_view_model.dart';
import 'package:note_app/ui/colors.dart';
import 'package:provider/provider.dart';

import '../../domain/model/note.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;
  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  StreamSubscription? _streamSubscription;

  final List<Color> noteColor = [
    roseBud,
    primrose,
    wisteria,
    skyBlue,
    illusion,
  ];

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }

    Future.microtask(() {
      final viewModel = context.read<AddEditNoteViewModel>();

      _streamSubscription = viewModel.eventStream.listen((event) {
        event.when(
          saveNote: () {
            Navigator.pop(context, true);
          },
          showSnackBar: (String message) {
            final snackBar = SnackBar(
              content: Text(message),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        );
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<AddEditNoteViewModel>();
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            viewmodel.onEvent(
              AddEditNoteEvent.saveNote(
                widget.note == null ? null : widget.note!.id,
                _titleController.text,
                _contentController.text,
              ),
            );
          },
          child: const Icon(Icons.save),
        ),
        body: AnimatedContainer(
          padding: const EdgeInsets.all(16),
          duration: const Duration(microseconds: 500),
          // curve: Curves.fastOutSlowIn,
          color: Color(viewmodel.color),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: noteColor
                    .map((color) => InkWell(
                        onTap: () {
                          viewmodel.onEvent(
                              AddEditNoteEvent.changeColor(color.value));
                        },
                        child: _buildBackgroundColor(
                            color: color,
                            selected: viewmodel.color == color.value)))
                    .toList(),
              ),
              TextField(
                controller: _titleController,
                maxLines: 1,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: darkGray,
                    ),
                decoration: const InputDecoration(
                  hintText: '제목을 입력하세요',
                  border: InputBorder.none,
                ),
              ),
              TextField(
                controller: _contentController,
                maxLines: null,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: darkGray,
                    ),
                decoration: const InputDecoration(
                  hintText: '내용을 입력하세요',
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundColor({
    required Color color,
    required bool selected,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
        ],
        border: selected
            ? Border.all(
                color: Colors.black,
                width: 2.0,
              )
            : null,
      ),
    );
  }
}
