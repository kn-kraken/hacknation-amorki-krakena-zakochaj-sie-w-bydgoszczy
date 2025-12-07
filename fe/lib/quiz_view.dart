// quiz_view_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/quiz/fun_fact.dart';
import 'header.dart';
import 'main_app_bar.dart';

class QuizViewScreen extends StatefulWidget {
  final int locationIndex;

  const QuizViewScreen({super.key, required this.locationIndex});

  @override
  State<QuizViewScreen> createState() => _QuizViewScreenState();
}

class _QuizViewScreenState extends State<QuizViewScreen> {
  int? _selectedAnswer;
  bool _hasAnswered = false;
  int _globalScore = 0;
  bool _isCompleted = false;

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

  Future<int> _getGlobalScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_scoreKey) ?? 0;
  }

  Future<void> _setGlobalScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_scoreKey, score);
  }

  Future<bool> _isQuizCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getString(_completedQuizzesKey) ?? '';
    return completed.contains('quiz_${widget.locationIndex}');
  }

  Future<void> _markQuizCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getString(_completedQuizzesKey) ?? '';
    final quizzes = completed.isEmpty ? [] : completed.split(',');
    if (!quizzes.contains('quiz_${widget.locationIndex}')) {
      quizzes.add('quiz_${widget.locationIndex}');
      await prefs.setString(_completedQuizzesKey, quizzes.join(','));
    }
  }

  Future<void> _loadQuizState() async {
    final isCompleted = await _isQuizCompleted();
    final globalScore = await _getGlobalScore();

    if (isCompleted) {
      final prefs = await SharedPreferences.getInstance();
      final savedAnswer = prefs.getString('quiz_${widget.locationIndex}_answer');
      setState(() {
        _hasAnswered = true;
        _selectedAnswer = savedAnswer != null ? int.tryParse(savedAnswer) : null;
        _isCompleted = isCompleted;
        _globalScore = globalScore;
      });
    } else {
      setState(() {
        _isCompleted = isCompleted;
        _globalScore = globalScore;
      });
    }
  }

  Future<void> _saveQuizAnswer(int answer) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quiz_${widget.locationIndex}_answer', answer.toString());
  }

  Future<void> _checkAnswer(int selectedIndex) async {
    if (_isCompleted) return;

    setState(() {
      _selectedAnswer = selectedIndex;
      _hasAnswered = true;
    });

    final correctAnswer = _quizData[widget.locationIndex]['correctAnswer'];
    if (selectedIndex == correctAnswer) {
      final currentScore = await _getGlobalScore();
      final newScore = currentScore + 1;
      await _setGlobalScore(newScore);
      setState(() {
        _globalScore = newScore;
      });
    }

    await _markQuizCompleted();
    await _saveQuizAnswer(selectedIndex);

    setState(() {
      _isCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuiz = _quizData[widget.locationIndex];
    final correctAnswerIndex = currentQuiz['correctAnswer'] as int;

    return Scaffold(
      backgroundColor: const Color(0xFFdbdad8),
      appBar: buildCustomAppBar(
        context: context,
        isInitialPage: false,
        showBackButton: true,
        showRefreshButton: false,
      ),
      body:  Material( child:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Header(text: currentQuiz['name']),
              const SizedBox(height: 16),
              // TODO: insert photo

              // Answer Options
              ...List.generate(currentQuiz['options'].length, (index) {
                final isSelected = _selectedAnswer == index;
                final isCorrect = index == correctAnswerIndex;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AnswerOption(
                    letter: String.fromCharCode(65 + index),
                    text: currentQuiz['options'][index],
                    isSelected: isSelected,
                    isCorrect: isCorrect,
                    hasAnswered: _hasAnswered,
                    onTap: (_hasAnswered || _isCompleted)
                        ? null
                        : () => _checkAnswer(index),
                  ),
                );
              }),

              const SizedBox(height: 16),

              FunFactCard(
                funFact: currentQuiz['funFact'],
                wikipediaUrl: currentQuiz['wikipediaUrl'],
              ),

              // if (_isCompleted)
              //   Text(
              //     'Global Owl Score: $_globalScore',
              //     style: const TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.bold,
              //       color: Color(0xFF5C2E2E),
              //       fontFamily: 'Serif',
              //     ),
              //   ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

// ============================================
// widgets/answer_option.dart
// ============================================

class AnswerOption extends StatelessWidget {
  final String letter;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool hasAnswered;
  final VoidCallback? onTap;

  const AnswerOption({
    super.key,
    required this.letter,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.hasAnswered,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingIcon;

    if (hasAnswered) {
      if (isCorrect) {
        leadingIcon = const Icon(
          Icons.check_circle,
          color: Color(0xFF2E5C2E),
          size: 20,
        );
      } else if (isSelected && !isCorrect) {
        leadingIcon = const Icon(
          Icons.cancel,
          color: Color(0xFF8B0000),
          size: 20,
        );
      }
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFdbdad8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF6B1D27),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(
              '$letter.',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B1D27),
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(width: 12),
            if (leadingIcon != null) ...[
              leadingIcon,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,

                  color: Color(0xFF6B1D27),
                  fontFamily: 'Serif',

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// Optional: utils/vintage_colors.dart
// ============================================

class VintageColors {
  static const Color background = Color(0xFFD4CECA);
  static const Color primary = Color(0xFF5C2E2E);
  static const Color textDark = Color(0xFF3E1F1F);
  static const Color success = Color(0xFF2E5C2E);
  static const Color error = Color(0xFF8B0000);
}