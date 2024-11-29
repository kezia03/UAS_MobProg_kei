import 'package:flutter/material.dart';
import 'dart:async';

class QuizSpanishPage extends StatefulWidget {
  @override
  _QuizSpanishPageState createState() => _QuizSpanishPageState();
}

class _QuizSpanishPageState extends State<QuizSpanishPage> {
  int _splashScreenStep = 0;
  bool _isFading = false;

  @override
  void initState() {
    super.initState();
    _startSplashSequence();
  }

  void _startSplashSequence() async {
    for (int i = 0; i <= 4; i++) {
      setState(() {
        _splashScreenStep = i;
        _isFading = true;
      });

      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _isFading = false;
      });

      await Future.delayed(Duration(milliseconds: 500));
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SpanishQuizContent()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: AnimatedOpacity(
          opacity: _isFading ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: _buildSplashScreenContent(),
        ),
      ),
    );
  }

  Widget _buildSplashScreenContent() {
    String text;
    switch (_splashScreenStep) {
      case 0:
        text = "Spanish Quiz Test";
        break;
      case 1:
        text = "1";
        break;
      case 2:
        text = "2";
        break;
      case 3:
        text = "3";
        break;
      case 4:
        text = "¡EMPIEZA!";
        break;
      default:
        text = "";
    }

    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class SpanishQuizContent extends StatefulWidget {
  @override
  _SpanishQuizContentState createState() => _SpanishQuizContentState();
}

class _SpanishQuizContentState extends State<SpanishQuizContent> {
  int _currentQuestionIndex = 0;
  int? _selectedIndex;
  int _score = 0;
  bool _isSubmitted = false;
  bool _isAnswerCorrect = false;
  bool _showFeedback = false;

  final List<Map<String, dynamic>> _questions = [
    {
      "question": "¿Qué significa 'hola' en inglés?",
      "options": ["Hello", "Goodbye", "Thank you", "Good night"],
      "answer": 0,
    },
    {
      "question": "¿Cuál es la pronunciación correcta de 'gracias'?",
      "options": ["Grasias", "Gracias", "Grathias", "Grasies"],
      "answer": 1,
    },
    {
      "question": "¿Qué significa 'adiós' en inglés?",
      "options": ["Hello", "Goodbye", "Thank you", "Good morning"],
      "answer": 1,
    },
    {
      "question": "¿Qué significa 'buenas noches'?",
      "options": ["Good night", "Good morning", "Good afternoon", "Goodbye"],
      "answer": 0,
    },
    {
      "question": "¿Qué significa 'mucho gusto'?",
      "options": ["Nice to meet you", "See you later", "Thank you", "You're welcome"],
      "answer": 0,
    },
  ];

  void _submitAnswer(BuildContext context) {
    if (_selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an option before continuing.")),
      );
      return;
    }

    setState(() {
      _isSubmitted = true;
      _isAnswerCorrect =
          _selectedIndex == _questions[_currentQuestionIndex]["answer"];
      if (_isAnswerCorrect) {
        _score++;
      }
      _showFeedback = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _showFeedback = false;
      });
    });
  }

  void _nextQuestion(BuildContext context) {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _selectedIndex = null;
        _isSubmitted = false;
        _isAnswerCorrect = false;
        _showFeedback = false;
      } else {
        _showFinalScore(context);
      }
    });
  }

  void _showFinalScore(BuildContext context) {
    int totalScore = ((_score / _questions.length) * 100).toInt();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Quiz completed!"),
          content: Text("Your score is $totalScore/100."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("Back to course"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF4A6DFF),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Quiz ${_currentQuestionIndex + 1} of ${_questions.length}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 16),
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / _questions.length,
                backgroundColor: Colors.grey[300],
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(0xFF4A6DFF)),
              ),
              SizedBox(height: 32),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Question ${_currentQuestionIndex + 1} of ${_questions.length}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      currentQuestion["question"],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: currentQuestion["options"].length,
                  itemBuilder: (context, index) {
                    return _buildOption(
                      currentQuestion["options"][index],
                      index,
                      currentQuestion["answer"],
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed:
                        !_isSubmitted ? () => _submitAnswer(context) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          !_isSubmitted ? Color(0xFF4A6DFF) : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "Submit",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isSubmitted ? () => _nextQuestion(context) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isSubmitted ? Color(0xFF4A6DFF) : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        _currentQuestionIndex < _questions.length - 1
                            ? "Next"
                            : "Finish",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
          if (_showFeedback)
            AnimatedOpacity(
              opacity: _showFeedback ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: Container(
                color: _isAnswerCorrect
                    ? Colors.green.withOpacity(0.7)
                    : Colors.red.withOpacity(0.7),
                child: Center(
                  child: Text(
                    _isAnswerCorrect ? "C O R R E C T" : "F A L S E",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOption(String text, int index, int correctAnswer) {
    Color getOptionColor() {
      if (!_isSubmitted) {
        return _selectedIndex == index ? Color(0xFF4A6DFF) : Colors.grey[200]!;
      }
      if (index == correctAnswer) return Colors.green;
      if (index == _selectedIndex) return Colors.red;
      return Colors.grey[200]!;
    }

    return GestureDetector(
      onTap: () {
        if (!_isSubmitted) {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: getOptionColor(),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: (_isSubmitted || _selectedIndex == index)
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
