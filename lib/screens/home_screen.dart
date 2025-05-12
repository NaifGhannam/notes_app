import 'package:flutter/material.dart';
import '../db/notes_database.dart';
import '../model/note.dart';
import '../widgets/note_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  void _refreshNotes() async {
    final data = await NotesDatabase.instance.readAllNotes();
    setState(() => _notes = data);
  }

  void _addNote() async {
    if (_controller.text.isEmpty) return;
    await NotesDatabase.instance.create(Note(content: _controller.text));
    _controller.clear();
    _refreshNotes();
  }

  void _deleteNote(int id) async {
    await NotesDatabase.instance.delete(id);
    _refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Notes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter note...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(onPressed: _addNote, child: const Text('Add Note')),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                return NoteTile(
                  note: _notes[index],
                  onDelete: () => _deleteNote(_notes[index].id!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
