import 'package:certain/models/question_model.dart';
import 'package:certain/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchesRepository {
  final FirebaseFirestore _firestore;

  MatchesRepository({FirebaseFirestore firebaseFirestore})
      : _firestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMatchList(userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('matchList')
        .snapshots();
  }

  Future<UserModel> getUserDetails(userId) async {
    UserModel _user = UserModel();
    var data;

    await _firestore.collection('users').doc(userId).get().then((user) {
      data = user.data();
      _user.uid = user.id;
      _user.name = data['name'];
      _user.photo = data['photoUrl'];
      _user.birthdate = data['birthdate'];
      _user.location = data['location'];
      _user.gender = data['gender'];
      _user.interestedIn = data['interestedIn'];
      List<QuestionModel> mcq = [];
      for (var question in data['mcq']) {
        mcq.add(new QuestionModel(
            question: question['question'],
            option1: question['correct_answer'],
            option2: question['option_2'],
            option3: question['option_3']));
      }
      _user.mcq = mcq;
    });

    return _user;
  }

  openChat({currentUserId, selectedUserId}) async {
    var usersCollection = _firestore.collection('users');
    var currentUserDoc = usersCollection.doc(currentUserId);
    var timestampField = {'timestamp': DateTime.now()};

    await currentUserDoc
        .collection('chats')
        .doc(selectedUserId)
        .set(timestampField);
    await currentUserDoc.collection('matchList').doc(selectedUserId).delete();
  }

  removeMatch(currentUserId, selectedUserId) async {
    var usersCollection = _firestore.collection('users');
    var currentUserDoc = usersCollection.doc(currentUserId);
    var selectedUserDoc = usersCollection.doc(selectedUserId);

    await currentUserDoc.collection('matchList').doc(selectedUserId).delete();
    await currentUserDoc
        .collection('notToShowList')
        .doc(selectedUserId)
        .set({});

    await selectedUserDoc.collection('matchList').doc(currentUserId).delete();
    await selectedUserDoc
        .collection('notToShowList')
        .doc(currentUserId)
        .set({});
  }
}
