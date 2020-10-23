import 'package:certain/models/question_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionsRepository {
  final FirebaseFirestore _firebaseFirestore;

  QuestionsRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

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

  Future<List<QuestionModel>> getMcq(String userId) async {
    List<QuestionModel> questionList = [];
    await _firebaseFirestore.collection("users").doc(userId).get().then((user) {
      for (var question in user.data()['mcq']) {
        questionList.add(new QuestionModel(
            question: question['question'],
            option1: question['correct_answer'],
            option2: question['option_2'],
            option3: question['option_3']));
      }
    });

    return questionList;
  }

  editMcq({String userId, List<Map<String, String>> userQuestions}) async {
    await _firebaseFirestore
        .collection("users")
        .doc(userId)
        .update({"mcq": userQuestions});
  }
}
