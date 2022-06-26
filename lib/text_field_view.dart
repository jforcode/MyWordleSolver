import 'package:flutter/material.dart';
import 'package:my_wordle_solver/text_field_controller.dart';

class TextFieldView extends StatefulWidget {
  const TextFieldView({
    Key? key,
    required this.controller,
    required this.id,
    required this.onTextFieldTapped,
  }) : super(key: key);

  final int id;
  final Function(int) onTextFieldTapped;
  final TextFieldController controller;

  @override
  State<StatefulWidget> createState() => TextFieldViewState();
}

class TextFieldViewState extends State<TextFieldView> {
  TextEditingController textController = TextEditingController();
  bool editingEnabled = false;
  late FocusNode focusNode;

  @override
  void initState() {
    widget.controller.setController(textController);
    widget.controller.addListener(_listenForController);
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.only(left: 16),
      child: TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        focusNode: focusNode,
        readOnly: !editingEnabled,
        controller: textController,
        onTap: _onTap,
        keyboardType: TextInputType.text,
        maxLength: 1,
      ),
    );
  }

  void _onTap() {
    print("on tap inside ${widget.onTextFieldTapped}");
    widget.onTextFieldTapped(widget.id);
    focusNode.requestFocus();

    setState(() {
      editingEnabled = true;
    });
  }

  void _listenForController() {
    setState(() {
      // could have directly used the controller variable, but looked a bit weird to avoid the listener logic
      editingEnabled = widget.controller.inputEnabled;
    });
  }
}
