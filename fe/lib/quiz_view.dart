// quiz_view_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/quiz/fun_fact.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/api.dart' as api;
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
  bool _isLoading = true;
  api.Step? _stepData;
  final api.ApiClient _apiClient = api.ApiClient();

  static const String _scoreKey = 'global_owl_score';
  static const String _completedQuizzesKey = 'completed_quizzes';

  @override
  void initState() {
    super.initState();
    _loadStepData();
  }

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }

  Future<void> _loadStepData() async {
    try {
      // Assuming scenario ID 1 and using locationIndex + 1 as stepId
      final response = await _apiClient.api.getStep(1, widget.locationIndex + 1);
      
      if (response.body != null) {
        setState(() {
          _stepData = response.body;
          _isLoading = false;
        });
        await _loadQuizState();
      }
    } catch (e) {
      print('Error loading step data: $e');
      setState(() {
        _isLoading = false;
      });
    }
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
    if (_isCompleted || _stepData == null) return;

    setState(() {
      _selectedAnswer = selectedIndex;
      _hasAnswered = true;
    });

    int? correctAnswer;
    if (_stepData is api.Question) {
      correctAnswer = (_stepData as api.Question).validAnswerIndex;
    }
    
    if (correctAnswer != null && selectedIndex == correctAnswer) {
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
    return Scaffold(
      backgroundColor: const Color(0xFFdbdad8),
      appBar: buildCustomAppBar(
        context: context,
        isInitialPage: false,
        showBackButton: true,
        showRefreshButton: false,
      ),
      body: Material(
        child: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading quiz...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )
            : _stepData == null
                ? const Center(
                    child: Text(
                      'Unable to load quiz data',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : _buildQuizContent(),
      ),
    );
  }

  Widget _buildQuizContent() {
    // If the step is a quiz question
    if (_stepData is api.Question) {
      final question = _stepData as api.Question;
      final correctAnswerIndex = question.validAnswerIndex;

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Header(text: 'Przystanek ${question.id}'),
              const SizedBox(height: 16),

              Text(
                question.question,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B1D27),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              ...List.generate(question.answers.length, (index) {
                final isSelected = _selectedAnswer == index;
                final isCorrect = index == correctAnswerIndex;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AnswerOption(
                    letter: String.fromCharCode(65 + index),
                    text: question.answers[index],
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
                funFact: question.curiocity,
                wikipediaUrl: 'https://visitbydgoszcz.pl/pl/',
              ),
            ],
          ),
        ),
      );
    }

    // If the step is NOT a quiz → Display task-style screen
    final step = _stepData as api.Task; // Guaranteed not null here
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              step.task ?? "No task available.",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B1D27),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            FunFactCard(
              funFact: step.curiocity ?? "Interesting place fact!",
              wikipediaUrl: 'https://visitbydgoszcz.pl/pl/',
            ),
          ],
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
          vertical: 12,
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