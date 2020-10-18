class QuestionModel {
  String id;
  String question;
  String option1;
  String option2;
  String option3;

  QuestionModel(
      {this.id, this.question, this.option1, this.option2, this.option3});

  String questionAsString() {
    return '#${this.id} ${this.question}';
  }

  bool isEqual(QuestionModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => question;
}
