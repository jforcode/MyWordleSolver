class Solver {
  // this class handles the logic part
  final int numLetters;
  final List<String> recommended = [];
  final List<String> all = [];

  Solver(this.numLetters) {
    // get word list for num letters
  }

  // mark a letter at a particular position at a particular state
  // if something is not present at all, send position as -1
  // if there are conflicts, notify that there is a conflict, but still take the latest as true
  // example can be notifying a is not present at 0, but then saying a is present at 0
  // since it's a tool, people will just use this as undo.
  // the exceptions thrown here are important.
  void mark() {}
}

enum SolverLetterState {
  confirmed,
  notInWord,
  tentative,
}

enum SolverExceptionTypes {
  conflict, // expand more types of conflict maybe. exception should have other data
}
