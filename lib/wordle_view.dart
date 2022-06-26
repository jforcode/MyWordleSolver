import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_wordle_solver/solver.dart';
import 'package:my_wordle_solver/word_view.dart';

class WordleView extends StatefulWidget {
  const WordleView(this.numLetters, {Key? key}) : super(key: key);

  final int numLetters;

  @override
  State<StatefulWidget> createState() => WordleViewState();
}

class WordleViewState extends State<WordleView> {
  bool showPopup = false;
  TextEditingController wordTextCtrl = TextEditingController();
  WordData? currEditingWord;
  List<WordData> guessHistory = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    wordTextCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _getWordInputWidget(),
          currEditingWord == null ? Container() : _getLettersInputWidget(),
          guessHistory.isEmpty ? Container() : _getLettersHistoryWidget(),
        ],
      ),
    );
  }

  Widget _getWordInputWidget() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[a-z]")),
            ],
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: _submitWord,
                icon: const Icon(Icons.check),
              ),
              labelText: "Your guess!",
            ),
            // textCapitalization: TextCapitalization.characters,
            controller: wordTextCtrl,
            maxLength: widget.numLetters,
          ),
        ),
      ],
    );
  }

  Widget _getLettersInputWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Mark Letter State",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: _discardEditing,
                    icon: const Icon(Icons.close),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    child: IconButton(
                      onPressed: _confirmEditing,
                      icon: const Icon(Icons.check),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        WordView(
          wordData: currEditingWord!,
          shouldEdit: true,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
        )
      ],
    );
  }

  Widget _getLettersHistoryWidget() {
    var children = <Widget>[
      Container(
        margin: const EdgeInsets.only(top: 16),
        child: Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            "Guess history",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ];

    children.addAll(
        guessHistory.map((e) => WordView(wordData: e, shouldEdit: false)));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: children,
    );
  }

  void _submitWord() {
    if (currEditingWord == null) {
      setState(() {
        currEditingWord = WordData.fromWord(wordTextCtrl.text);
        wordTextCtrl.text = "";
      });
    } else {
      const snackBar = SnackBar(
        content: Text(
          "A word is already being edited. Discard or confirm editing to add a new word!",
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _discardEditing() {
    if (currEditingWord == null) {
      throw Exception(
        "Currently editing word is null when submit is called! Should be an impossible scenario!",
      );
    }

    setState(() {
      currEditingWord = null;
    });
  }

  void _confirmEditing() {
    if (currEditingWord == null) {
      throw Exception(
        "Currently editing word is null when submit is called! Should be an impossible scenario!",
      );
    }

    setState(() {
      guessHistory.insert(0, currEditingWord!);
      currEditingWord = null;
    });
  }
}

class WordData {
  String word = "";
  List<SolverLetterState> letterStates = [];

  WordData();

  WordData.fromWord(this.word) {
    letterStates.clear();
    for (int i = 0; i < word.length; i++) {
      letterStates.add(SolverLetterState.notInWord);
    }
  }

  @override
  String toString() {
    return "$word : ${letterStates.join(", ")} ";
  }
}
