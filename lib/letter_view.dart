import 'package:flutter/material.dart';
import 'package:my_wordle_solver/solver.dart';

class LetterView extends StatelessWidget {
  const LetterView({
    Key? key,
    required this.letter,
    required this.state,
  }) : super(key: key);

  final String letter;
  final SolverLetterState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        shape: const CircleBorder(),
        color: _getColorFromState(),
      ),
      child: Text(
        letter.toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    );
  }

  Color _getColorFromState() {
    switch (state) {
      case SolverLetterState.none:
        return Colors.grey;
      case SolverLetterState.confirmed:
        return Colors.green;
      case SolverLetterState.notInWord:
        return Colors.grey;
      case SolverLetterState.tentative:
        return Colors.yellow.shade700;
    }
  }
}
