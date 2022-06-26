import 'package:flutter/material.dart';

class StateButtonView extends StatefulWidget {
  const StateButtonView(this.state, this.onSelected, {Key? key})
      : super(key: key);

  final ButtonStates state;
  final VoidCallback onSelected;

  @override
  State<StatefulWidget> createState() => StateButtonViewState();
}

class StateButtonViewState extends State<StateButtonView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _getColor(),
        ),
        child: TextButton(
          child: const Text(""),
          onPressed: () {},
        ),
      ),
    );
  }

  void _onPressed() {}

  Color _getColor() {
    switch (widget.state) {
      case ButtonStates.tentative:
        return Colors.yellow;
      case ButtonStates.confirmed:
        return Colors.green;
      case ButtonStates.absent:
        return Colors.black26;
    }
  }
}

enum ButtonStates {
  tentative,
  confirmed,
  absent,
}
