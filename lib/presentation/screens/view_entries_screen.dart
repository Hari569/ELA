import 'package:flutter/material.dart';

class ViewEntriesScreen extends StatelessWidget {
  final String contestName;

  ViewEntriesScreen({required this.contestName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entries for $contestName'),
      ),
      body: Center(
        child: const Text('List of entries will be displayed here.'),
      ),
    );
  }
}
