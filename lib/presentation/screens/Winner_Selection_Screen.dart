import 'package:flutter/material.dart';
import 'dart:math';

class WinnerSelectionScreen extends StatefulWidget {
  final String contestTitle;

  const WinnerSelectionScreen({Key? key, required this.contestTitle})
      : super(key: key);

  @override
  _WinnerSelectionScreenState createState() => _WinnerSelectionScreenState();
}

class _WinnerSelectionScreenState extends State<WinnerSelectionScreen> {
  List<String> participants =
      []; // In a real app, this would be fetched from a database
  List<String> winners = [];
  int numberOfWinners = 1;

  @override
  void initState() {
    super.initState();
    // Simulate fetching participants from a database
    participants = List.generate(50, (index) => 'Participant ${index + 1}');
  }

  void _selectWinners() {
    if (numberOfWinners > participants.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Cannot select more winners than participants')),
      );
      return;
    }

    setState(() {
      winners = [];
      final random = Random();
      List<String> tempParticipants = List.from(participants);
      for (int i = 0; i < numberOfWinners; i++) {
        int index = random.nextInt(tempParticipants.length);
        winners.add(tempParticipants[index]);
        tempParticipants.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Winners for ${widget.contestTitle}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Participants: ${participants.length}',
                style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Number of Winners:'),
                const SizedBox(width: 16),
                DropdownButton<int>(
                  value: numberOfWinners,
                  items:
                      List.generate(10, (index) => index + 1).map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        numberOfWinners = newValue;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _selectWinners,
              child: const Text('Select Winners'),
            ),
            const SizedBox(height: 24),
            Text('Winners:', style: Theme.of(context).textTheme.headline6),
            Expanded(
              child: ListView.builder(
                itemCount: winners.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(winners[index]),
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
