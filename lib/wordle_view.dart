import 'package:flutter/material.dart';
import 'package:my_wordle_solver/solver.dart';

class WordleView extends StatefulWidget {
  const WordleView(this.numLetters, {Key? key}) : super(key: key);

  final int numLetters;

  @override
  State<StatefulWidget> createState() => WordleViewState();
}

class WordleViewState extends State<WordleView> {
  bool showPopup = false;

  @override
  Widget build(BuildContext context) {
    var popupView = showPopup ? _getConfirmationPopup() : Container();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(),
          popupView,
        ],
      ),
    );
  }

  int value = 0;

  Widget _getConfirmationPopup() {
    // create state buttons to tap on. like a radio button
    // and a confirm and cancel button to submit
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 300,
          height: 150,
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                height: 50,
                child: ListTile(
                  title: Text(_getTextForLetterState(index!)),
                  leading: Radio<int>(
                    value: index,
                    groupValue: value,
                    onChanged: (newValue) {
                      setState(() {
                        value = newValue!;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.only(left: 16),
              child:
                  IconButton(onPressed: () {}, icon: const Icon(Icons.check)),
            ),
            Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.only(left: 16),
              child:
                  IconButton(onPressed: () {}, icon: const Icon(Icons.cancel)),
            ),
          ],
        ),
      ],
    );
  }

  String _getTextForLetterState(int index) {
    switch (SolverLetterState.values[index]) {
      case SolverLetterState.confirmed:
        return "Confirmed";
      case SolverLetterState.notInWord:
        return "Not In Word";
      case SolverLetterState.tentative:
        return "In Word but in different position";
    }
  }

  void _onTap(int pos) {
    print("on tap");
    setState(() {
      showPopup = true;
    });
    // show the popup to select colour for the text
    // and a submit and cancel button
    // also disable the other text fields for input
    // mark this text field as currently selected
  }

  void _onSubmitPressed() {
    // validation for the currently selected text field
    // add it to the computation logic
    // update the list of recommended words and all words
    // enable editing of all text fields
    // create a list of values below the text field for available options
  }

  void _onCancelPressed() {
    // reset to as it was.
    // remove text field text
    // enable all text fields to be editable
  }
}
