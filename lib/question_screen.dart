import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final List<Map<String, Object>> questions = [
    {
      'questionText': 'SRI(Socially Responsible Investment)を説明したものはどれか。',
      'answers': [
        '企業が社会的責任を果たすために、環境保護への投資を行う。', 
        '財務評価だけでなく、社会的責任への取組みも評価して、企業への投資を行う。',
        '先端技術開発への貢献度が高いベンチャー企業に対して、投資を行う',
        '地域経済の活性化のために、大型の公共事業への投資を積極的に行う。'
      ],
      'correctAnswer': '財務評価だけでなく、社会的責任への取組みも評価して、企業への投資を行う。',
    },
    {
      'questionText': 'Dartは何に使われる？',
      'answers': ['モバイル開発', '画像編集', 'ネットワーク管理'],
      'correctAnswer': 'モバイル開発',
    },
    // 次の問題
  ];

  int questionIndex = 0;
  int score = 0;

  void _answerQuestion(String selectedAnswer) {
    final correct = questions[questionIndex]['correctAnswer'] as String;
    if (selectedAnswer == correct) {
      setState(() {
        score += 1;
      });
    }

    setState(() {
      questionIndex += 1;
    });

    if (questionIndex >= questions.length) {
      Navigator.pushNamed(context, '/result', arguments: score);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questionIndex >= questions.length) {
      return const SizedBox(); // 空表示（ナビゲートされるまで）
    }

    final currentQuestion = questions[questionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('問題画面'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion['questionText'] as String,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            ...(currentQuestion['answers'] as List<String>).map((answer) {
              return ElevatedButton(
                onPressed: () => _answerQuestion(answer),
                child: Text(answer),
              );
            }),
          ],
        ),
      ),
    );
  }
}