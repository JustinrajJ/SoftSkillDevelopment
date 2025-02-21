import 'package:flutter/material.dart';

class AssessmentPage extends StatefulWidget {
  final VoidCallback onComplete;

  const AssessmentPage({required this.onComplete, Key? key}) : super(key: key);

  @override
  _AssessmentPageState createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedOption;

  final List<Map<String, dynamic>> _questions = [
    {
      "question": "How do you ensure clarity when explaining complex ideas to others?",
      "options": [
        "Use technical jargon and assume everyone understands",
        "Break the information into simple, digestible points and encourage questions",
        "Speak quickly and avoid pausing",
        "Focus on one part of the idea and ignore the rest"
      ],
      "answer": 1
    },
    {
      "question": "When you give feedback to a colleague, what is your primary focus?",
      "options": [
        "Highlighting only their mistakes",
        "Providing constructive feedback in a way that helps them improve",
        "Ignoring the positives and focusing only on the negatives",
        "Speaking as quickly as possible to avoid an awkward conversation"
      ],
      "answer": 1
    },
    // Add more questions here
  ];

  void _nextQuestion() {
    if (_selectedOption == _questions[_currentQuestionIndex]['answer']) {
      _score++;
    }

    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _selectedOption = null; // Reset for next question
      } else {
        _showResults(); // Show results after the last question
      }
    });
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Assessment Complete"),
          content: Text("Your score is $_score/${_questions.length}."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                widget.onComplete(); // Notify parent and navigate to homepage
              },
              child: Text("Go to Homepage"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _confirmExit() async {
    return (await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Exit Assessment"),
          content: Text("Are you sure you want to exit the assessment? Your progress will be lost."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Return false if user cancels
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true), // Return true if user confirms
              child: Text("Exit"),
            ),
          ],
        );
      },
    )) ??
        false; // Default to false if dialog result is null
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmExit,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Assessment"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _confirmExit()) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / _questions.length,
              ),
              SizedBox(height: 10),
              Text(
                "Question ${_currentQuestionIndex + 1} of ${_questions.length}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              Text(
                _questions[_currentQuestionIndex]['question'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ..._questions[_currentQuestionIndex]['options']
                  .asMap()
                  .entries
                  .map((entry) {
                int index = entry.key;
                String option = entry.value;
                return RadioListTile<int>(
                  value: index,
                  groupValue: _selectedOption,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedOption = value;
                    });
                  },
                  title: Text(option),
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectedOption != null
                    ? _nextQuestion
                    : null, // Disable button until an option is selected
                child: Text(
                  _currentQuestionIndex < _questions.length - 1
                      ? "Next"
                      : "Finish",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
