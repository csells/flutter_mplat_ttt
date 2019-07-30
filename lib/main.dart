import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride, kIsWeb;

void _desktopInitHack() {
  if (kIsWeb) return;

  if (Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  } else if (Platform.isFuchsia) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _desktopInitHack();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> moves = List<String>(9);
  String currentPlayer;

  @override
  void initState() {
    initGame();
    super.initState();
  }

  void initGame() {
    for (int i = 0; i < 9; i++) moves[i] = '';
    currentPlayer = 'X';
  }

  bool get gameOver => gameWon || gameTie;
  bool get gameTie => !moves.any((m) => m == '');
  bool check(int i, int j, int k) => moves[i] != '' && moves[j] == moves[i] && moves[k] == moves[i];
  bool get gameWon {
    if (check(0, 1, 2)) return true;
    if (check(3, 4, 5)) return true;
    if (check(6, 7, 8)) return true;

    if (check(0, 3, 6)) return true;
    if (check(1, 4, 7)) return true;
    if (check(2, 5, 8)) return true;

    if (check(0, 4, 8)) return true;
    if (check(2, 4, 6)) return true;

    return false;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('tic-tac-toe')),
        body: SafeArea(
          child: CustomPaint(
            painter: LinesPainter(),
            child: Column(
              children: [
                for (var i = 0; i < 3; i++)
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        for (int j = 0; j < 3; j++)
                          Cell(moves[j + i * 3], () => onCellTap(j + i * 3)),
                      ],
                    ),
                  ),
                Text(
                  "it's $currentPlayer's turn",
                  style: TextStyle(fontSize: 32, backgroundColor: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );

  onCellTap(int i) async {
    if (moves[i] != '') return;
    setState(() {
      moves[i] = currentPlayer;
    });

    if (!gameOver) {
      setState(() {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      });
      return;
    }

    await showDialog(
      context: this.context,
      builder: (_) => AlertDialog(
        title: Center(child: Text(gameWon ? '$currentPlayer won!' : 'tie game')),
      ),
    );

    setState(() => initGame());
  }
}

class LinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..strokeWidth = 4;
    var dx = size.width / 3;
    var dy = size.height / 3;
    canvas.drawLine(Offset(0, dy), Offset(dx * 3, dy), paint);
    canvas.drawLine(Offset(0, dy * 2), Offset(dx * 3, dy * 2), paint);
    canvas.drawLine(Offset(dx, 0), Offset(dx, dy * 3), paint);
    canvas.drawLine(Offset(dx * 2, 0), Offset(dx * 2, dy * 3), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Cell extends StatelessWidget {
  final String move;
  final Function onTap;
  const Cell(this.move, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: Text(
            move,
            style: TextStyle(fontSize: 48),
          ),
        ),
      ),
    );
  }
}
