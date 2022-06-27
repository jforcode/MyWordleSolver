import 'package:my_wordle_solver/solver.dart';

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
