import 'package:flutter/material.dart';

import 'package:certain/repositories/questions_repository.dart';

import 'package:certain/views/pages/create_mcq.dart';
import 'package:certain/views/pages/quiz_play.dart';

class Mcq extends StatefulWidget {
  @override
  _McqState createState() => _McqState();
}

class _McqState extends State<Mcq> {
  Stream quizStream;
  QuestionsRepository questionsRepository = new QuestionsRepository();

  Widget quizList() {
    return Container(
      child: Column(
        children: [
          StreamBuilder(
            stream: quizStream,
            builder: (context, snapshot) {
              return snapshot.data == null
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return QuizTile(
                          noOfQuestions: snapshot.data.documents.length,
                          imageUrl: snapshot.data.documents[index]
                              .data()['quizImgUrl'],
                          title: snapshot.data.documents[index]
                              .data()['quizTitle'],
                          description:
                              snapshot.data.documents[index].data()['quizDesc'],
                          id: snapshot.data.documents[index].documentID,
                        );
                      });
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    quizStream = questionsRepository.getQuizData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("hey"),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //brightness: Brightness.li,
      ),
      body: quizList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateQuiz()));
        },
      ),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String imageUrl, title, id, description;
  final int noOfQuestions;

  QuizTile(
      {@required this.title,
      @required this.imageUrl,
      @required this.description,
      @required this.id,
      @required this.noOfQuestions});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => QuizPlay(id)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                color: Colors.black26,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
