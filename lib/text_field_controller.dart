// this is sort of like shared state between two views
import 'package:flutter/material.dart';

class TextFieldController extends ChangeNotifier {
  bool inputEnabled = false;
  late TextEditingController _controller;

  TextFieldController();

  void setController(TextEditingController controller) {
    _controller = controller;
  }

  String get text => _controller.text;

  void disableInput() {
    inputEnabled = false;
    notifyListeners();
  }
}

class TextFieldValue {}
