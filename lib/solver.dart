import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_wordle_solver/word_data.dart';

// TODO: getRecommendedWord - which analyses all remaining words and gives one with highest probability
// plus it checks which word can eliminate most amount of remaining words
// TODO: make solver as a package.
// if I make a bot, it can use this solver package
class Solver {
  // this class handles the logic part
  final int numLetters;
  final List<String> recommended = [];
  final List<String> all = [];

  // this is proper, it shouldn't be presentInWord
  // as, the states can be present, not present, not tested for presence
  List<SolverLetterState> letterStates = [];
  List<PositionData> positionData = [];

  static Future<Solver> create(int numLetters) async {
    var solver = Solver._(numLetters);
    await solver._initRecommended();
    return solver;
  }

  Solver._(this.numLetters) {
    for (int i = 0; i < 26; i++) {
      letterStates.add(SolverLetterState.none);
    }
    for (int i = 0; i < numLetters; i++) {
      positionData.add(PositionData());
    }
  }

  Future<void> _initRecommended() async {
    var f = await rootBundle.loadString("assets/words/words_$numLetters.txt");

    f.split("\n").forEach((element) {
      if (element.isNotEmpty) {
        recommended.add(element);
      }
    });
  }

  void addWord(WordData wordData) {
    _updateLetterStates(wordData);
    _updateRecommended();
  }

  void _updateRecommended() {
    print("before removal ${recommended.length}");

    recommended.removeWhere((element) => _containsNotPresentLetter(element));
    recommended.removeWhere((element) => _containsLettersInInvalidPositions(element));
    recommended.removeWhere((element) => _notContainsPresentLetter(element));
    print("after removal ${recommended.length}");
  }

  int ii = 0;
  bool _containsNotPresentLetter(String word) {
    for (var x in word.characters) {
      if (letterStates[_getIndexForChar(x)] == SolverLetterState.notInWord) {
        return true;
      }
    }

    return false;
  }

  bool _containsLettersInInvalidPositions(String word) {
    for (int i = 0; i < numLetters; i++) {
      var posData = positionData[i];
      if (!_charEquals("-", posData.confirmedLetter) &&
          !_charEquals(word[i], posData.confirmedLetter)) {
        print("removing $word ${ii++}");
        return true;
      }

      if (posData.nonConfirmedLetters.map((e) => e.toUpperCase()).contains(word[i].toUpperCase())) {
        print("removing $word ${ii++}");
        return true;
      }
    }

    return false;
  }

  bool _notContainsPresentLetter(String word) {
    for (int i = 0; i < letterStates.length; i++) {
      if (letterStates[i] == SolverLetterState.tentative && !word.contains(_getCharForIndex(i))) {
        return true;
      }
    }

    return false;
  }

  void _updateLetterStates(WordData wordData) {
    if (wordData.word.length != numLetters) {
      throw Exception(
        "Solver is initialized with $numLetters letters. But given word is of ${wordData.word.length} letters",
      );
    }

    for (int i = 0; i < numLetters; i++) {
      var letter = wordData.word[i];
      var state = wordData.letterStates[i];
      var ind = _getIndexForChar(letter);

      switch (state) {
        case SolverLetterState.none:
          break;

        case SolverLetterState.confirmed:
          _validateConfirmed(i, letter);
          positionData[i].confirmedLetter = letter;
          letterStates[ind] = SolverLetterState.confirmed;
          break;

        case SolverLetterState.notInWord:
          _validateNotInWord(letter);
          letterStates[ind] = SolverLetterState.notInWord;
          break;

        case SolverLetterState.tentative:
          _validateTentative(i, letter);
          if (!positionData[i].nonConfirmedLetters.contains(letter)) {
            positionData[i].nonConfirmedLetters.add(letter);
          }
          if (letterStates[ind] != SolverLetterState.confirmed) {
            letterStates[ind] = SolverLetterState.tentative;
          }
          break;
      }
    }
  }

  void _validateNotInWord(String letter) {
    var currState = letterStates[_getIndexForChar(letter)];
    if (currState == SolverLetterState.tentative || currState == SolverLetterState.confirmed) {
      throw Exception(
        "Invalid state! Letter $letter is already marked as present in word.",
      );
    }
  }

  void _validateConfirmed(int pos, String letter) {
    if (letterStates[_getIndexForChar(letter)] == SolverLetterState.notInWord) {
      throw Exception(
        "Invalid state! Letter $letter is already marked as not present in word.",
      );
    }

    var posData = positionData[pos];
    for (var c in posData.nonConfirmedLetters) {
      if (_charEquals(c, letter)) {
        // already marked as non-confirmed
        throw Exception(
          "Invalid state! Letter $letter is already marked as not present at position ${pos + 1}",
        );
      }
    }

    if (!_charEquals(posData.confirmedLetter, "-") &&
        !_charEquals(posData.confirmedLetter, letter)) {
      // some other letter is already marked as confirmed
      throw Exception(
        "Invalid state! Letter ${posData.confirmedLetter} is already marked as confirmed at position ${pos + 1}.",
      );
    }
  }

  void _validateTentative(int pos, String letter) {
    if (letterStates[_getIndexForChar(letter)] == SolverLetterState.notInWord) {
      throw Exception(
        "Invalid state! Letter $letter is already marked as not present in word.",
      );
    }

    var posData = positionData[pos];
    if (_charEquals(posData.confirmedLetter, letter)) {
      // already marked as confirmed in this position
      throw Exception(
        "Invalid state! Letter $letter is already marked as confirmed at position ${pos + 1}",
      );
    }
  }

  String _getCharForIndex(int x) => String.fromCharCode("A".codeUnitAt(0) + x);

  int _getIndexForChar(String x) =>
      x == "-" ? -1 : (x.toUpperCase().codeUnitAt(0) - "A".codeUnitAt(0));

  bool _charEquals(String x, String y) => x.toUpperCase() == y.toUpperCase();
}

class PositionData {
  String confirmedLetter = "-";
  List<String> nonConfirmedLetters = [];

  @override
  String toString() {
    return "$confirmedLetter, ${nonConfirmedLetters.join(', ')}";
  }
}

enum SolverLetterState {
  none,
  confirmed,
  notInWord,
  tentative,
}

extension SolverLetterStateExtension on SolverLetterState {
  String get name {
    switch (this) {
      case SolverLetterState.none:
        return "N/A";
      case SolverLetterState.confirmed:
        return "IN WORD AND IN THE SAME POSITION";
      case SolverLetterState.notInWord:
        return "NOT IN WORD";
      case SolverLetterState.tentative:
        return "IN WORD BUT IN A DIFFERENT POSITION";
    }
  }
}
