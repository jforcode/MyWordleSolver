import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_wordle_solver/solver.dart';
import 'package:my_wordle_solver/word_data.dart';
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
  Solver? solver;
  FocusNode wordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _postBuild());
  }

  void _postBuild() async {
    solver = await Solver.create(widget.numLetters);
    setState(() {});
  }

  @override
  void dispose() {
    wordTextCtrl.dispose();
    wordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: solver == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _getWordInputWidget(),
                  guessHistory.isEmpty ? Container() : _getRecommendedWords(),
                  currEditingWord == null ? Container() : _getLettersInputWidget(),
                  guessHistory.isEmpty ? Container() : _getLettersHistoryWidget(),
                ],
              ),
      ),
    );
  }

  Widget _getWordInputWidget() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
              TextInputFormatter.withFunction((oldValue, newValue) {
                return TextEditingValue(
                  text: newValue.text.toUpperCase(),
                  selection: newValue.selection,
                );
              }),
            ],
            focusNode: wordFocusNode,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: _submitWord,
                icon: const Icon(Icons.check),
              ),
              labelText: "Your guess!",
            ),
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
              _getTitleWidget("Mark Letter State"),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: _discardEditing,
                    icon: const Icon(Icons.close),
                  ),
                  Container(width: 16),
                  IconButton(
                    onPressed: _confirmEditing,
                    icon: const Icon(Icons.check),
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
    var children = <Widget>[_getTitleWidget("Guess history")];
    children.addAll(
      guessHistory.map((e) => WordView(wordData: e, shouldEdit: false)),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: children,
    );
  }

  Widget _getRecommendedWords() {
    var toShow = min(solver!.recommended.length, 10);
    var remaining = solver!.recommended.length - toShow;
    var children = solver!.recommended
        .getRange(0, toShow)
        .map(
          (e) => Chip(
            label: Text(e),
            deleteIcon: const Icon(Icons.add_circle, size: 20),
            onDeleted: () {
              if (currEditingWord == null) {
                wordTextCtrl.text = e;
                _submitWord();
              } else {
                _showSnackbar(
                  "A word is already being edited! Discard or confirm editing to add a new word!",
                );
              }
            },
          ),
        )
        .toList();

    if (remaining > 0) {
      children.add(Chip(label: Text("+$remaining")));
    }
    if (toShow == 0) {
      children.add(const Chip(label: Text("no matching words")));
    }

    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        children: [
          _getTitleWidget("Matching words"),
          Container(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: children,
          ),
        ],
      ),
    );
  }

  Widget _getTitleWidget(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _submitWord() {
    if (wordFocusNode.hasFocus) {
      wordFocusNode.unfocus();
    }

    if (currEditingWord == null) {
      var text = wordTextCtrl.text;
      if (text.length < 5) {
        _showSnackbar("Enter a 5 letter word!");
        return;
      }

      setState(() {
        currEditingWord = WordData.fromWord(wordTextCtrl.text);
        wordTextCtrl.text = "";
      });
    } else {
      _showSnackbar(
          "A word is already being edited. Discard or confirm editing to add a new word!");
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
    try {
      solver!.addWord(currEditingWord!);
      setState(() {
        guessHistory.add(currEditingWord!);
        currEditingWord = null;
      });
    } catch (e) {
      _showSnackbar(e.toString());
    }
  }

  void _showSnackbar(String message) {
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
