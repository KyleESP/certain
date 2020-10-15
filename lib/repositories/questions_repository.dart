import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionsRepository {
  final String uid;

  QuestionsRepository({this.uid});

  Future<void> addData(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print(e);
    });
  }

  getQuizData() {
    return FirebaseFirestore.instance.collection("quiz").snapshots();
  }

  Future<void> addQuizData(Map quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("quiz")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addQuestionData(quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("quiz")
        .doc(quizId)
        .collection("qna")
        .add(quizData)
        .catchError((e) {
      print(e);
    });
  }

  getQuestionData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("quiz")
        .doc(quizId)
        .collection("qna")
        .get();
  }
}
