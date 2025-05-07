import 'package:flutter/material.dart';
import 'package:flutter_app/button.dart';
import 'package:flutter_app/quiz.dart';
import 'package:flutter_app/textbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Secondchance extends StatefulWidget {
  const Secondchance({super.key});

  @override
  State<Secondchance> createState() => _ComponentsState();
}

class _ComponentsState extends State<Secondchance> {
  Future<Quiz>? quiz;
  Quiz? selectedQuiz;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Quiz) {
      selectedQuiz = args;
      quiz = Future.value(selectedQuiz);
    }
  }

  Future<void> removeData(String question) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('wrong')
            .where('question', isEqualTo: question) // 문제 텍스트 일치
            .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete(); // 각 문서 삭제
    }
  }

  Future<void> addData() async {
    final q = await quiz;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || q == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('correct')
        .add(q.toMap());
  }

  @override
  void initState() {
    super.initState();
    // initState에서는 더 이상 loadQuiz()를 호출하지 않습니다.
  }

  void loadQuiz() async {
    setState(() {
      quiz = fetching();
    });
  }

  void onPressed(
    String selectedAnswer,
    String correctAnswer,
    BuildContext context,
  ) {
    if (selectedAnswer == correctAnswer) {
      addData();
      removeData(selectedQuiz!.question);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text('Correct!')),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 100),
        ),
      );
      Future.delayed(Duration(milliseconds: 300), () {
      Navigator.pop(context);
    });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text('Wrong!')),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 100),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '다시 풀기',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
        
      ),
      body: FutureBuilder<Quiz>(
        future: quiz,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data'));
          } else {
            final quiz = snapshot.data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),
                    Textbox(question: quiz!.question),
                    for (int i = 0; i < 4; i++)
                      Button(
                        text: quiz.answers[i],
                        flag: false,
                        isCo: quiz.answers[i] == quiz.coanswer,
                        onPressed:
                            () => onPressed(
                              quiz.answers[i],
                              quiz.coanswer,
                              context,
                            ),
                      ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      backgroundColor: Color(0xFFFFF5FD),
    );
  }
}
