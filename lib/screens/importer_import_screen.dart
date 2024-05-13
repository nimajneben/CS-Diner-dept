import 'package:flutter/material.dart';
import 'package:manju_three/forms/importer_import_widget.dart';

class ImporterImportScreen extends StatelessWidget {
  const ImporterImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import Food')),
      body: const ImporterImportWidget(), // <-- Form is inside this function!
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.check),
          onPressed: () {
            // TODO: Form validation.
            // TODO: actually add the backend stuff
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pop(context);
          }),
    );
  }
}

const snackBar = SnackBar(
  content: Text('Form Submit OK'),
);
