import 'package:flutter/material.dart';
import 'Question_Container.dart';
import 'Question_Submission_Form.dart';

class QAScreen extends StatefulWidget {
  @override
  _QAScreenState createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  List<Map<String, String>> qaList = [
    {
      'question': 'How often should I water my indoor plants?',
      'answer':
          'Watering frequency depends on the type of plant, size of the pot, and the indoor climate. Generally, most indoor plants should be watered once a week. However, it\'s important to check the soil moisture first. If the top 1-2 inches of soil are dry, it\'s time to water.'
    },
    {
      'question': 'What is the best soil mix for growing succulents?',
      'answer':
          'Succulents thrive in well-draining soil. A good mix includes one part potting soil, one part sand, and one part perlite or pumice. This combination ensures proper drainage, which is crucial for preventing root rot.'
    },
  ];

  void addNewQuestion(String question) {
    setState(() {
      qaList.insert(0,
          {'question': question, 'answer': 'Pending answer from our experts.'});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expert Q&A'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: qaList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    QuestionContainer(
                      question: qaList[index]['question']!,
                      answer: qaList[index]['answer']!,
                    ),
                    const SizedBox(height: 16.0),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QuestionSubmissionForm(onSubmit: addNewQuestion),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text(
                'ASK A QUESTION',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
