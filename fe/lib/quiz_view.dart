import 'package:flutter/material.dart';
import 'dart:html' as html;

class QuizViewScreen extends StatefulWidget {
  final int locationIndex;

  const QuizViewScreen({super.key, required this.locationIndex});

  @override
  State<QuizViewScreen> createState() => _QuizViewScreenState();
}

class _QuizViewScreenState extends State<QuizViewScreen> {
  int? _selectedAnswer;
  bool _hasAnswered = false;

  // Global owl score storage key
  static const String _scoreKey = 'global_owl_score';
  static const String _completedQuizzesKey = 'completed_quizzes';

  final List<Map<String, dynamic>> _quizData = [
    {
      'name': 'Old Market Square',
      'imageUrl': 'https://picsum.photos/400/300?random=1',
      'funFact':
          'The Old Market Square in Bydgoszcz was established in the 14th century and served as the heart of medieval trade routes.',
      'question': 'When was the Old Market Square in Bydgoszcz established?',
      'options': [
        '12th century',
        '14th century',
        '16th century',
        '18th century',
      ],
      'correctAnswer': 1,
      'wikipediaUrl': 'https://en.wikipedia.org/wiki/Bydgoszcz_Old_Town',
    },
    {
      'name': 'Cathedral Basilica',
      'imageUrl': 'https://picsum.photos/400/300?random=4',
      'funFact':
          'The Bydgoszcz Cathedral was originally built as a parish church in the 15th century and became a cathedral in 2004.',
      'question': 'In what year did the church become a cathedral?',
      'options': ['1945', '1989', '2004', '2010'],
      'correctAnswer': 2,
      'wikipediaUrl': 'https://en.wikipedia.org/wiki/Bydgoszcz_Cathedral',
    },
    {
      'name': 'Mill Island',
      'imageUrl': 'https://picsum.photos/400/300?random=2',
      'funFact':
          'Mill Island has been home to grain mills since medieval times, utilizing the Brda River\'s water power for centuries.',
      'question': 'What was Mill Island historically used for?',
      'options': [
        'Fishing harbor',
        'Military fortress',
        'Grain mills',
        'Royal palace',
      ],
      'correctAnswer': 2,
      'wikipediaUrl': 'https://en.wikipedia.org/wiki/Mill_Island,_Bydgoszcz',
    },
    {
      'name': 'Opera Nova',
      'imageUrl': 'https://picsum.photos/400/300?random=3',
      'funFact':
          'Opera Nova, opened in 2006, is built partially over the Brda River and features a stunning modern design with glass facades.',
      'question': 'When did Opera Nova open?',
      'options': ['1995', '2000', '2006', '2012'],
      'correctAnswer': 2,
      'wikipediaUrl': 'https://en.wikipedia.org/wiki/Opera_Nova',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadQuizState();
  }

  int _getGlobalScore() {
    final stored = html.window.localStorage[_scoreKey];
    return stored != null ? int.tryParse(stored) ?? 0 : 0;
  }

  void _setGlobalScore(int score) {
    html.window.localStorage[_scoreKey] = score.toString();
  }

  bool _isQuizCompleted() {
    final completed = html.window.localStorage[_completedQuizzesKey] ?? '';
    return completed.contains('quiz_${widget.locationIndex}');
  }

  void _markQuizCompleted() {
    final completed = html.window.localStorage[_completedQuizzesKey] ?? '';
    final quizzes = completed.isEmpty ? [] : completed.split(',');
    if (!quizzes.contains('quiz_${widget.locationIndex}')) {
      quizzes.add('quiz_${widget.locationIndex}');
      html.window.localStorage[_completedQuizzesKey] = quizzes.join(',');
    }
  }

  void _loadQuizState() {
    if (_isQuizCompleted()) {
      setState(() {
        _hasAnswered = true;
        // Load saved answer if available
        final savedAnswer =
            html.window.localStorage['quiz_${widget.locationIndex}_answer'];
        _selectedAnswer = savedAnswer != null
            ? int.tryParse(savedAnswer)
            : null;
      });
    }
  }

  void _saveQuizAnswer(int answer) {
    html.window.localStorage['quiz_${widget.locationIndex}_answer'] = answer
        .toString();
  }

  void _checkAnswer(int selectedIndex) {
    if (_isQuizCompleted()) return; // Prevent re-answering

    setState(() {
      _selectedAnswer = selectedIndex;
      _hasAnswered = true;

      final correctAnswer = _quizData[widget.locationIndex]['correctAnswer'];
      if (selectedIndex == correctAnswer) {
        // Add 1 to global score
        final currentScore = _getGlobalScore();
        _setGlobalScore(currentScore + 1);
      }

      // Save this quiz as completed
      _markQuizCompleted();
      _saveQuizAnswer(selectedIndex);
    });
  }

  void _showCompletionMessage() {
    final globalScore = _getGlobalScore();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('🦉', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Text(
              'Global Owl Score: $globalScore',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _launchWikipedia() async {
    final url = _quizData[widget.locationIndex]['wikipediaUrl'];
    html.window.open(url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    final currentQuiz = _quizData[widget.locationIndex];
    final correctAnswerIndex = currentQuiz['correctAnswer'] as int;
    final globalScore = _getGlobalScore();
    final isCompleted = _isQuizCompleted();

    return Scaffold(
      appBar: AppBar(title: Text(currentQuiz['name']), elevation: 2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Place Image
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(currentQuiz['imageUrl']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(16),
                child: Text(
                  currentQuiz['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Owl Score
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.green.withOpacity(0.2)
                          : Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCompleted ? Colors.green : Colors.amber,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🦉', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(
                          'Global Owl Score: $globalScore',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isCompleted) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 24,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Fun Fact
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.lightbulb, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Historic Fun Fact',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentQuiz['funFact'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Question
                  Text(
                    currentQuiz['question'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Answer Options
                  ...List.generate(currentQuiz['options'].length, (index) {
                    final isSelected = _selectedAnswer == index;
                    final isCorrect = index == correctAnswerIndex;

                    Color? backgroundColor;
                    Color? borderColor;

                    if (_hasAnswered) {
                      if (isCorrect) {
                        backgroundColor = Colors.green.withOpacity(0.2);
                        borderColor = Colors.green;
                      } else if (isSelected && !isCorrect) {
                        backgroundColor = Colors.red.withOpacity(0.2);
                        borderColor = Colors.red;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: (_hasAnswered || isCompleted)
                            ? null
                            : () {
                                _checkAnswer(index);
                                _showCompletionMessage();
                              },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: backgroundColor ?? Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: borderColor ?? Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: borderColor ?? Colors.grey[400],
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + index),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  currentQuiz['options'][index],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              if (_hasAnswered && isCorrect)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              if (_hasAnswered && isSelected && !isCorrect)
                                const Icon(Icons.cancel, color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Completion message
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Quiz completed! Visit other locations to earn more owls.',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (isCompleted) const SizedBox(height: 24),

                  // Wikipedia Link Button
                  OutlinedButton.icon(
                    onPressed: _launchWikipedia,
                    icon: const Icon(Icons.public),
                    label: const Text('Read More on Wikipedia'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
