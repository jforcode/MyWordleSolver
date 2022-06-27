import 'package:flutter/material.dart';
import 'package:my_wordle_solver/letter_view.dart';
import 'package:my_wordle_solver/solver.dart';
import 'package:my_wordle_solver/word_data.dart';

class WordView extends StatefulWidget {
  const WordView({Key? key, required this.wordData, required this.shouldEdit})
      : super(key: key);

  final bool shouldEdit;
  final WordData wordData;

  @override
  State<StatefulWidget> createState() => WordViewState();
}

class WordViewState extends State<WordView> {
  List<SolverLetterState> statesInOrder = [
    SolverLetterState.tentative,
    SolverLetterState.confirmed,
    SolverLetterState.notInWord,
  ];

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    var len = widget.wordData.word.length;

    for (int i = 0; i < len; i++) {
      var letter = widget.wordData.word[i];
      var state = widget.wordData.letterStates[i];

      children.add(SizedBox(
        width: 50,
        height: 50,
        child: InkWell(
          onTap: () {
            _onTap(i);
          },
          child: LetterView(
            letter: letter,
            state: state,
          ),
        ),
      ));
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }

  void _onTap(int letterInd) {
    if (!widget.shouldEdit) {
      return;
    }

    var letterState = widget.wordData.letterStates[letterInd];
    var pos = statesInOrder.indexOf(letterState);
    var newState = statesInOrder[(pos + 1) % statesInOrder.length];
    widget.wordData.letterStates[letterInd] = newState;

    setState(() {});
  }
}
