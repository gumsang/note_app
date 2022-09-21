import 'package:flutter/material.dart';
import 'package:note_app/presentation/add_edit_note/add_edit_note_screen.dart';
import 'package:note_app/presentation/notes/components/note_item.dart';
import 'package:note_app/presentation/notes/components/order_section.dart';
import 'package:note_app/presentation/notes/notes_event.dart';
import 'package:note_app/presentation/notes/notes_view_model.dart';
import 'package:provider/provider.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotesViewModel>();
    final state = viewModel.state;
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (
            BuildContext context,
          ) {
            return AlertDialog(
              title: const Text(
                '끝내시겠습니까?',
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('끝내기'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('아니요'),
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Your note',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                viewModel.onEvent(const NotesEvent.toggleOrderSection());
              },
              icon: const Icon(Icons.sort),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool? isSaved = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddEditNoteScreen(),
              ),
            );

            if (isSaved != null && isSaved == true) {
              viewModel.onEvent(const NotesEvent.loadNotes());
            }
          },
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(children: [
            AnimatedSwitcher(
              duration: const Duration(microseconds: 300),
              child: state.isOrderSectionVisible
                  ? OrderSection(
                      noteOrder: state.noteOrder,
                      onOrderChanged: (noteOrder) {
                        viewModel.onEvent(NotesEvent.changeOrder(noteOrder));
                      },
                    )
                  : Container(),
            ),
            ...state.notes
                .map(
                  (note) => GestureDetector(
                    onTap: () async {
                      bool? isSaved = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditNoteScreen(
                            note: note,
                          ),
                        ),
                      );
                      if (isSaved != null && isSaved == true) {
                        viewModel.onEvent(const NotesEvent.loadNotes());
                      }
                    },
                    child: NoteItem(
                      note: note,
                      onDeleteTap: () {
                        viewModel.onEvent(NotesEvent.deleteNote(note));
                        final snackBar = SnackBar(
                          content: const Text('노트가 삭제되었습니다.'),
                          action: SnackBarAction(
                            label: '취소',
                            onPressed: () {
                              viewModel.onEvent(
                                const NotesEvent.restoreNote(),
                              );
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                  ),
                )
                .toList(),
          ]),
        ),
      ),
    );
  }
}
