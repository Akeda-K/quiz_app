import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;
  int questionIndex = 0;
  int score = 0;

  int? selectedIndex; // 🔹選択されたインデックス
  bool? isCorrect; // 🔹正解かどうか
  bool hasAnswered = false;

  @override
  void initState() {
    super.initState();
    fetchQuestions(); // 🔹Firestoreからデータ取得
  }

  Future<void> fetchQuestions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('quizzes')
        .get();
    final docs = snapshot.docs;

    setState(() {
      questions = docs.map((doc) => doc.data()).toList();
      isLoading = false;
      questionIndex = 0;
      score = 0;
      selectedIndex = null; // 🔹追加
      isCorrect = null; // 🔹追加
    });
  }

  void _answerQuestion(int index, String selectedAnswer) {
    final correct = questions[questionIndex]['answer']?.toString() ?? '';

    setState(() {
      selectedIndex = index;
      isCorrect = selectedAnswer == correct;
      hasAnswered = true;
      if (isCorrect!) score += 1;
    });

    // 🔹2秒後に次の問題へ
    // Future.delayed(const Duration(seconds: 2), () {
    //   setState(() {
    //     questionIndex += 1;
    //     selectedIndex = null;
    //     isCorrect = null;
    //   });

    //   if (questionIndex >= questions.length) {
    //     Navigator.pushNamed(context, '/result', arguments: score);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (questionIndex >= questions.length) {
      return const SizedBox(); // 空表示（ナビゲートされるまで）
    }

    final currentQuestion = questions[questionIndex];
    final options = currentQuestion['options'] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('問題画面'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion['question']?.toString() ?? '質問がありません',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            ...List.generate(options.length, (index) {
              final answer = options[index].toString();
              Color buttonColor = Colors.white;

              if (selectedIndex != null) {
                if (index == selectedIndex) {
                  buttonColor = isCorrect! ? Colors.green : Colors.red;
                } else {
                  buttonColor = Colors.grey;
                }
              }

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  side: BorderSide(
                    color: (selectedIndex == index && isCorrect == true)
                        ? Colors.green
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                onPressed: selectedIndex == null
                    ? () => _answerQuestion(index, answer.toString())
                    : null,
                child: Text(answer),
              );
            }),
            const SizedBox(height: 20), // 🔹余白追加
            // 🔹ここにメッセージ表示
            if (selectedIndex != null)
              Text(
                isCorrect! ? '正解！🎉' : '不正解…😢',
                style: TextStyle(
                  fontSize: 18,
                  color: isCorrect! ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
            if (hasAnswered)
              ElevatedButton(
                onPressed: () {
                  if (questionIndex + 1 >= questions.length) {
                    Navigator.pushNamed(context, '/result', arguments: score);
                  } else {
                    setState(() {
                      questionIndex += 1;
                      selectedIndex = null;
                      isCorrect = null;
                      hasAnswered = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  questionIndex + 1 >= questions.length ? '結果を見る' : '次の問題へ',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
