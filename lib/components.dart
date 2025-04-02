import 'package:flutter/material.dart';
import 'package:flutter_app/button.dart';
import 'package:flutter_app/quiz.dart';
import 'package:flutter_app/textbox.dart';

class Components extends StatefulWidget {
  const Components({super.key});

  @override
  State<Components> createState() => _ComponentsState();
}

class _ComponentsState extends State<Components> {
  //late Quiz quiz;
  Future<Quiz>? quiz;

  @override
  void initState(){
    super.initState();
    loadQuiz();
  }
  void loadQuiz() async {
    setState(() {
      quiz = fetching();
    });
  }
  void onPressed(String selectedAnswer, String correctAnswer, BuildContext context) {
    if (selectedAnswer == correctAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text('Correct!')
            ),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 100),
        ),
      );
      loadQuiz();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text('Wrong!')
            ),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds:100),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '랜덤 퀴즈',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
      ),
      body: FutureBuilder<Quiz>(
        future: quiz,
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}', style: TextStyle(fontSize: 20)),
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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Textbox(question: quiz!.question),
                    for(int i = 0; i < 4; i++)
                      Button(
                        text: quiz.answers[i],
                        flag: false,
                        isCo: quiz.answers[i] == quiz.coanswer,
                        onPressed: () => onPressed(quiz.answers[i], quiz.coanswer,context)
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

