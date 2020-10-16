class Question {
  String question;
  String option1;
  String option2;
  String option3;
  String correctOption;
  bool answered;

  Question({this.question, this.option1, this.option2, this.option3}) {
    answered = false;
    correctOption = option1;
  }
}
