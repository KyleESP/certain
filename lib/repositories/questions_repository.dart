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
    List<Question> questionList;
    var data;
    await _firebaseFirestore.collection("mcq").get().then((questions) {
      for (var question in questions.docs) {
        data = question.data();
        questionList.add(new Question(
            question: data['question'],
            option1: data['option1'],
            option2: data['option2'],
            option3: data['option3']));
      }
    });

    return questionList;
  }

  Future<void> addQuizData(Map quizData) async {
    await _firebaseFirestore
        .collection("users")
        .doc(_firebaseAuth.currentUser.uid)
        .set(quizData);
  }

  Future<void> addQuestionData(quizData) async {
    /*await _firebaseFirestore
        .collection("quiz")
        .doc(quizId)
        .collection("qna")
        .add(quizData);*/
  }

  getQuestionData(String quizId) async {
    return await _firebaseFirestore
        .collection("quiz")
        .doc(quizId)
        .collection("qna")
        .get();
  }
}
