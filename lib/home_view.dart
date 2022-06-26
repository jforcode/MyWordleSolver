import 'package:flutter/material.dart';
import 'package:my_wordle_solver/wordle_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  List<int> puzzleTypes = [5, 6, 7, 8, 9];
  int selectedType = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle Solver'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              _getDropDown(),
              _getRefreshButton(),
            ],
          ),
          WordleView(selectedType)
        ],
      )
    );
  }

  Widget _getRefreshButton() {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _getDropDown() {
    return DropdownButton(
      value: selectedType,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: puzzleTypes.map((e) {
        return DropdownMenuItem(
          value: e,
          child: Text("$e letter wordle"),
        );
      }).toList(),
      onChanged: (int? selected) {
        setState(() {
          selectedType = selected ?? 5;
        });
      },
    );
  }
}
