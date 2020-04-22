import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psych/UI/waitingToStart/structure.dart';
import 'dart:math';

class StartAGameButton extends StatelessWidget {
  StartAGameButton({
    @required this.playerName,
  });
  final String playerName;
  List players = [];

  Widget build(BuildContext context) {
    String generateUniqueID() {
      Random rnd;
      int min = 100000;
      int max = 999999;
      rnd = new Random();
      var r = min + rnd.nextInt(max - min);
      return r.toString();
    }

    String uniqueCode = generateUniqueID();

    void startGame() {
      players.add(playerName);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => WaitingToStart(
            playerName: playerName,
            gameID: uniqueCode,
          ),
        ),
      );

      Firestore.instance.document("test/" + uniqueCode).setData({
        "players": players,
      });
    }

    return RaisedButton(
      child: Text(
        "Start a Game",
      ),
      onPressed: () {
        startGame();
      },
    );
  }
}