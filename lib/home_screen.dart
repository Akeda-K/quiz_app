import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 問題画面へ移動
            Navigator.pushNamed(context, '/question');
          },
          child: const Text('一問一答を始める'),
        ),
      ),
    );
  }
}