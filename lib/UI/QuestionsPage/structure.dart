import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psych/UI/QuestionsPage/questionCard.dart';
import 'package:psych/UI/nameInput/structure.dart';

import 'package:psych/UI/waitForSubmissions/structure.dart';

class QuestionsPage extends StatefulWidget {
  QuestionsPage({
    @required this.playerID,
    @required this.gameID,
  });
  final String playerID;
  final String gameID;

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  @override
  Widget build(BuildContext context) {
    void sendResponse(String response) {
      Firestore.instance
          .collection('roomDetails')
          .document(widget.gameID)
          .collection('responses')
          .document(widget.playerID)
          .updateData(
        {
          'response': response,
          'hasSubmitted': true,
        },
      );
    }

    void changeReadyState() {
      Firestore.instance
          .collection('roomDetails')
          .document(widget.gameID)
          .collection('playerStatus')
          .document(widget.playerID)
          .updateData(
        {
          'isReady': false,
        },
      );
    }

    String response = '';

    Future<bool> _onBackPressed() {
      return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      "NO",
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => NameInputPage(),
                        ),
                      );
                    },
                    child: Text(
                      "YES",
                    ),
                  ),
                ],
                content: Text(
                  "You sure you wanna leave the game?",
                ),
              );
            },
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            StreamBuilder(
              builder: (context, snap) {
                if (!snap.hasData) {
                  return SizedBox();
                }
                return QuestionCard(
                  question: snap.data['currentQuestion'],
                );
              },
              stream: Firestore.instance
                  .collection('roomDetails')
                  .document(widget.gameID)
                  .snapshots(),
            ),
            TextField(
              onChanged: (val) {
                response = val;
              },
            ),
            RaisedButton(
              onPressed: () {
                response != null && response != ''
                    ? sendResponse(
                        response,
                      )
                    : noResponse(
                        context,
                      );
                response != null && response != '' ? changeReadyState() : null;
                response != null && response != ''
                    ? Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => WaitForSubmissions(
                            gameID: widget.gameID,
                            playerID: widget.playerID,
                          ),
                        ),
                      )
                    : null;
              },
              child: Text(
                "Submit",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget noResponse(context) {
    //button can be disabled instead
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "OK",
              ),
            )
          ],
          content: Text(
            "Can't be empty!",
          ),
        );
      },
    );
  }
}
