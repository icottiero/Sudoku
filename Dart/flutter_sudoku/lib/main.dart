import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'engine/game.dart';
import 'loader/loader.dart';
import 'models/number_entry.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => GameState.empty(),
        child: MaterialApp(
          title: 'Sudoku',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: const MyHomePage(title: 'Sudoku'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: const GameGrid(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class GameGrid extends StatelessWidget {
  const GameGrid({super.key});

  @override
  Widget build(BuildContext context) {
    var gameState = context.watch<GameState>();

    print(gameState.game.printTable());

    List<Widget> gridItems = List<Widget>.empty(growable: true);
    for (int columnIndex = 0; columnIndex < 9; columnIndex++) {
      for (int rowIndex = 0; rowIndex < 9; rowIndex++) {
        gridItems.add(
          Container(
            width: 10,
            height: 10,
            color: Colors.blue.shade300,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                gameState.numbers[rowIndex][columnIndex].printValue(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 4,
                ),
              ),
            ),
          ),
        );
      }
    }
    return Container(
        decoration: BoxDecoration(
            gradient:
                RadialGradient(colors: [Colors.grey[800]!, Colors.black])),
        child: GridView.count(
          crossAxisCount: 9,
          mainAxisSpacing: 11,
          crossAxisSpacing: 1,
          children: gridItems,
        ));
  }
}

class GameState extends ChangeNotifier {
  List<List<NumberEntry>> numbers;
  Game game;

  GameState._(List<List<NumberEntry>> newNumbers)
      : numbers = newNumbers,
        game = Game(newNumbers);

  factory GameState.empty() {
    return GameState._(List<List<NumberEntry>>.generate(
        9, (ind) => List<NumberEntry>.generate(9, (index) => NumberEntry(1))));
  }

  static Future<GameState> create() async {
    var newNumbers = await Loader.loadRandomGame();

    return GameState._(newNumbers);
  }
}
