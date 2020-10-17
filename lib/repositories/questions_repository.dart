import 'package:certain/models/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuestionsRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  QuestionsRepository(
      {FirebaseAuth firebaseAuth, FirebaseFirestore firebaseFirestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<Question>> getQuestions() async {
    List<Question> questionList = [];
    var data;
    await _firebaseFirestore.collection("questions").get().then((questions) {
      for (var question in questions.docs) {
        data = question.data();
        questionList.add(new Question(
            id: question.id,
            question: data['question'],
            option1: data['option_1'],
            option2: data['option_2'],
            option3: data['option_3']));
      }
    });

    return questionList;
  }

  createMcq(Map<String, Map<String, dynamic>> mcq) async {
    await Future.forEach(mcq.entries, (MapEntry entry) async {
      await _firebaseFirestore
          .collection("users")
          .doc(_firebaseAuth.currentUser.uid)
          .collection("mcq")
          .doc(entry.key)
          .set(entry.value);
    });
  }

  getQuestionData(String quizId) async {
    return null;
  }
}
