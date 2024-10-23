import 'package:flutter/material.dart';

class QuestionSubmissionForm extends StatefulWidget {
  final Function(String) onSubmit;

  const QuestionSubmissionForm({Key? key, required this.onSubmit})
      : super(key: key);

  @override
  _QuestionSubmissionFormState createState() => _QuestionSubmissionFormState();
}

class _QuestionSubmissionFormState extends State<QuestionSubmissionForm> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();

  void _submitQuestion() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_questionController.text);
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Your question has been submitted successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Return to the previous screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit a Question'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(
                  labelText: 'Your Question',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your question';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'SUBMIT',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
