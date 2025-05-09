import 'package:flutter/material.dart';
import 'package:flutter_app/button.dart';
import 'package:flutter_app/quiz.dart';
import 'package:flutter_app/textbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class Components extends StatefulWidget {
  const Components({super.key});

  @override
  State<Components> createState() => _ComponentsState();
}

class _ComponentsState extends State<Components> {
  Future<Quiz>? quiz;
  //FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  Future<void> addWData() async {
    final q = await quiz;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || q == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('wrong')
        .add(q.toMap());
  }

  @override
  void initState() {
    super.initState();
    loadQuiz();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text('Correct!')),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 100),
        ),
      );
    } else {
      addWData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text('Wrong!')),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 100),
        ),
      );
    }
    loadQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '랜덤 퀴즈',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/wronganswers');
          },
          icon: Icon(Icons.dataset),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                Navigator.pushNamed(context, '/sign-in');
              } else {
                Navigator.pushNamed(context, '/profile');
              }
            },
            icon: Icon(Icons.perm_identity),
          ),
        ],
      ),
      body: FutureBuilder<Quiz>(
        future: quiz,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Button(
                    text: '새로 고침',
                    flag: false,
                    isCo: false,
                    isRe: true,
                    onPressed: () {
                      loadQuiz();
                    },
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data'));
          } else {
            final quiz = snapshot.data;
            //print(quiz);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularCountDownTimer(
                      duration: 10,
                      width: 100,
                      height: 100,
                      fillColor: Color.fromRGBO(232, 157, 157, 1),
                      ringColor: Color.fromRGBO(0, 0, 0, 0),
                      isReverse: true,
                      isReverseAnimation: true,
                      onComplete: () {
                        addWData();
                        // Here, do whatever you want
                        loadQuiz();
                      },
                    ),
                    SizedBox(height: 50),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Button(
                        text: '새로운 문제',
                        flag: false,
                        isCo: false,
                        isRe: true,
                        onPressed: () {
                          loadQuiz();
                        },
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
