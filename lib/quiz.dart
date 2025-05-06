import 'package:http/http.dart' as http;
import 'dart:convert';

class Quiz {
  String question = '';
  List<String> answers = [];
  String coanswer = '';
  Quiz({required this.answers, required this.question, required this.coanswer});
  Map<String, dynamic> toMap() {
    return {'question': question, 'answers': answers, 'coanswer': coanswer};
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      
      answers: List<String>.from(map['answers'] ?? []),
      coanswer: map['coanswer'] ?? '',
      question: map['question'] ?? '',
    );
  }
  @override
  String toString() {
    return 'Quiz(question: $question, answers: $answers, coanswer: $coanswer)';
  }
}

Future<Quiz> fetching() async {
  final uri = Uri.parse('https://opentdb.com/api.php?amount=1&type=multiple');
  final response = await http.get(uri);

  if (response.statusCode != 200) {
    throw Exception('Failed to load quiz data');
  }

  final data = json.decode(response.body);

  final result = data['results'][0];

  String question = result['question'];
  List<String> answers = List<String>.from(result['incorrect_answers']);
  String coanswer = result['correct_answer'];
  List<String> anlist = [...answers, coanswer];
  anlist.shuffle();

  return Quiz(question: question, answers: anlist, coanswer: coanswer);
}
