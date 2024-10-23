import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Winner_Selection_Screen.dart';
import 'package:ELA/models/contest.dart';

class AdminContestScreen extends StatefulWidget {
  @override
  _AdminContestScreenState createState() => _AdminContestScreenState();
}

class _AdminContestScreenState extends State<AdminContestScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  DateTime _resultDate = DateTime.now().add(const Duration(days: 14));
  String _imageUrl = '';
  List<Contest> _contests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contest Management'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _contests.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: _contests.length,
                    itemBuilder: (context, index) {
                      final contest = _contests[index];
                      return _buildContestCard(contest);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _showAddContestDialog,
              child: const Text('Add New Contest'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note, size: 100, color: Colors.grey),
          SizedBox(height: 16),
          Text('No contests added yet',
              style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildContestCard(Contest contest) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(contest.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(contest.description),
            Text(
                'Start: ${DateFormat('yyyy-MM-dd').format(contest.startDate)}'),
            Text('End: ${DateFormat('yyyy-MM-dd').format(contest.endDate)}'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: contest.isEnded
              ? () => _navigateToWinnerSelection(contest)
              : null,
          child: const Text('Pick Winners'),
        ),
      ),
    );
  }

  void _showAddContestDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Contest'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  label: 'Contest Title',
                  onSaved: (value) => _title = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a title' : null,
                ),
                _buildTextField(
                  label: 'Description', // Added description field
                  onSaved: (value) => _description = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                  maxLines: 3, // Allow multiple lines for description
                ),
                _buildDatePicker('Start Date', _startDate, (date) {
                  setState(() => _startDate = date);
                }),
                _buildDatePicker('End Date', _endDate, (date) {
                  setState(() => _endDate = date);
                }),
                _buildDatePicker('Result Date', _resultDate, (date) {
                  setState(() => _resultDate = date);
                }),
                _buildTextField(
                  label: 'Image URL',
                  onSaved: (value) => _imageUrl = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an image URL' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if (_validateDates()) {
                  _addContest();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('End date should be after start date')),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        onSaved: onSaved,
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDatePicker(
      String label, DateTime selectedDate, Function(DateTime) onDateChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          TextButton(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null && picked != selectedDate) {
                onDateChanged(picked);
              }
            },
            child: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
          ),
        ],
      ),
    );
  }

  bool _validateDates() {
    return _startDate.isBefore(_endDate) && _endDate.isBefore(_resultDate);
  }

  void _addContest() {
    setState(() {
      _contests.add(Contest(
        title: _title,
        description: _description,
        startDate: _startDate,
        endDate: _endDate,
        resultDate: _resultDate,
        imageUrl: _imageUrl,
      ));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contest added successfully')),
    );
  }

  void _navigateToWinnerSelection(Contest contest) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            WinnerSelectionScreen(contestTitle: contest.title),
      ),
    );
  }
}
