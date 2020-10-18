import 'package:certain/models/question_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuestionsRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  QuestionsRepository(
      {FirebaseAuth firebaseAuth, FirebaseFirestore firebaseFirestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<QuestionModel>> getQuestions() async {
    List<QuestionModel> questionList = [];
    var data;
    await _firebaseFirestore.collection("questions").get().then((questions) {
      for (var question in questions.docs) {
        data = question.data();
        questionList.add(new QuestionModel(
            id: question.id,
            question: data['question'],
            option1: data['option_1'],
            option2: data['option_2'],
            option3: data['option_3']));
      }
    });

    return questionList;
  }

  createMcq(List<Map<String, String>> mcq) async {
    await _firebaseFirestore
        .collection("users")
        .doc(_firebaseAuth.currentUser.uid)
        .update({"mcq": mcq});
  }

  getQuestionData(String quizId) async {
    return null;
  }
}
