import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/quiz.dart';

class Wrongnotescreen extends StatefulWidget {
  const Wrongnotescreen({super.key});

  @override
  State<Wrongnotescreen> createState() => _WrongnotescreenState();
}

class _WrongnotescreenState extends State<Wrongnotescreen> {
  late Future<List<Quiz>> wrongQuestions;
  @override
  void initState() {
    super.initState();
    wrongQuestions = fetchWrongQuestions();
    getQuestion();
  }

  void getQuestion() async {
    List<Quiz> result = await fetchWrongQuestions();
    for (var q in result) {
      print("StartPrint");
      print(q.question);
      // 👈 각 오답 문제의 question 출력
    }
  }

  Future<List<Quiz>> fetchWrongQuestions() async {
    final user = FirebaseAuth.instance.currentUser;
    print("Current UID: ${user?.uid}");
    if (user == null) {
      print("NULL!!!!");
      return [];
    }
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('wrong')
            .get();
    print("Fetched ${snapshot.docs.length} documents");
    for (var doc in snapshot.docs) {
      print("Raw Firestore Data: ${doc.data()}");
    }
    return snapshot.docs.map((doc) => Quiz.fromMap(doc.data())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '오답 List',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
      ),
      body: FutureBuilder<List<Quiz>>(
        future: wrongQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Empty'));
          }
          final quiz = snapshot.data!;
          return ListView.builder(
            itemCount: quiz.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(quiz[index].question));
            },
          );
        },
      ),
    );
  }
}
