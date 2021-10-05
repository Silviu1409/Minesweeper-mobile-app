import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:animated_background/animated_background.dart';

enum TileState { covered, blown, open, flagged, revealed }

void main() => runApp(MineSweeper());

Color currentColor = Colors.grey.shade400;
int numOfMines = 3;
int rows = 6;
int cols = 6;
String dropdownvalue = '6x6';
int minesfound = 0;

class MineSweeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Minesweeper",
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onBackPressed1,
        child: new Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 0.0,
          ),
          body: AnimatedBackground(
            behaviour: BubblesBehaviour(),
            vsync: this,
            child: Container(
                child: Center(
                    child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 100.0),
                  child: RichText(
                    text: TextSpan(
                      text: "Minesweeper",
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(50.0, 200.0, 0.0, 0.0),
                      child: RichText(
                        text: TextSpan(
                          text: "Select board size : ",
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(25.0, 200.0, 0.0, 0.0),
                      child: DropdownButton(
                        value: dropdownvalue,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 20,
                        elevation: 0,
                        dropdownColor: Colors.transparent,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        underline: Container(
                          height: 2,
                          color: Colors.blue,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                            switch (dropdownvalue) {
                              case '6x6':
                                rows = 6;
                                cols = 6;
                                break;
                              case '7x7':
                                rows = 7;
                                cols = 7;
                                break;
                              case '8x8':
                                rows = 8;
                                cols = 8;
                                break;
                              case '9x9':
                                rows = 9;
                                cols = 9;
                                break;
                              case '10x10':
                                rows = 10;
                                cols = 10;
                                break;
                            }
                          });
                        },
                        items: <String>['6x6', '7x7', '8x8', '9x9', '10x10']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 200.0, 0.0, 50.0),
                  child: RichText(
                    text: TextSpan(
                      text: "Play now!",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.green,
                      ),
                      child: TextButton(
                          child: Text(
                            "Easy\n ${(0.15 * cols * rows).toInt()} \u2739",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                            ),
                          ),
                          onPressed: () {
                            numOfMines = (0.15 * cols * rows).toInt();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Board()),
                            );
                            return;
                          }),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.yellow,
                      ),
                      child: TextButton(
                          child: Text(
                            "Medium\n   ${(0.225 * cols * rows).toInt()} \u2739",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                            ),
                          ),
                          onPressed: () {
                            numOfMines = (0.225 * cols * rows).toInt();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Board()),
                            );
                            return;
                          }),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.red,
                      ),
                      child: TextButton(
                          child: Text(
                            "Hard\n${(0.3 * cols * rows).toInt()} \u2739",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                            ),
                          ),
                          onPressed: () {
                            numOfMines = (0.3 * cols * rows).toInt();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Board()),
                            );
                            return;
                          }),
                    ),
                  ],
                )
              ],
            ))),
          ),
        ));
  }

  Future<bool> onBackPressed1() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the app?'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => {
              Navigator.of(context).pop(false),
            },
            child: Text("No"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => {
              exit(1),
            },
            child: Text("Yes"),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }
}

class Board extends StatefulWidget {
  @override
  BoardState createState() => BoardState();
}

class BoardState extends State<Board> {
  List<List<TileState>> uiState = [];
  List<List<bool>> tiles = [];

  bool alive = false;
  bool wonGame = false;
  int flagsplaced = 0;
  Timer? timer;
  Stopwatch stopwatch = Stopwatch();

  Color pickerColor = currentColor;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void resetBoard() {
    alive = true;
    wonGame = false;
    flagsplaced = 0;
    minesfound = 0;
    stopwatch.reset();
    stopwatch.stop();

    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 0), (Timer timer) {
      setState(() {});
    });

    uiState = new List<List<TileState>>.generate(rows, (row) {
      return new List<TileState>.filled(cols, TileState.covered);
    });

    tiles = new List<List<bool>>.generate(rows, (row) {
      return new List<bool>.filled(cols, false);
    });

    Random random = Random();
    int remainingMines = numOfMines;
    while (remainingMines > 0) {
      int pos = random.nextInt(rows * cols);
      int row = pos ~/ rows;
      int col = pos % cols;
      if (!tiles[row][col]) {
        tiles[row][col] = true;
        remainingMines--;
      }
    }
  }

  @override
  void initState() {
    resetBoard();
    super.initState();
  }

  Widget buildBoard() {
    bool hasCoveredCell = false;
    List<Row> boardRow = <Row>[];
    for (int i = 0; i < rows; i++) {
      List<Widget> rowChildren = <Widget>[];
      for (int j = 0; j < cols; j++) {
        TileState state = uiState[i][j];
        bool isflagged = (state == TileState.flagged);

        ///bool isblown = tiles[i][j];
        int count = mineCount(i, j);

        if (!alive && !wonGame) {
          if (state != TileState.blown)
            state = tiles[i][j] ? TileState.revealed : state;
        }

        if (!alive) {
          if (state == TileState.flagged && !tiles[i][j]) {
            Widget text = RichText(
              text: TextSpan(),
            );
            text = buildInnerTile(RichText(
              text: TextSpan(
                text: '\u2716',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: (315 - 4 * rows) / (max(rows, cols) + 5),
                ),
              ),
              textAlign: TextAlign.center,
            ));
            buildTile(buildInnerTile(text));
          }
        }

        if (state == TileState.covered || state == TileState.flagged) {
          rowChildren.add(GestureDetector(
            onLongPress: () {
              flag(i, j);
            },
            onTap: () {
              if (state == TileState.covered) probe(i, j);
            },
            child: Listener(
                child: CoveredMineTile(
              flagged: state == TileState.flagged,
              posX: i,
              posY: j,
            )),
          ));
          if (state == TileState.covered) {
            hasCoveredCell = true;
          }
        } else {
          rowChildren.add(
              OpenMineTIle(state: state, count: count, isflagged: isflagged));
        }
      }
      boardRow.add(Row(
        children: rowChildren,
        mainAxisAlignment: MainAxisAlignment.center,
        key: ValueKey<int>(i),
      ));
    }

    if (!hasCoveredCell) {
      if ((flagsplaced == numOfMines) && alive) {
        wonGame = true;
        stopwatch.stop();
      }
    }

    return Container(
      color: Colors.grey[700],
      padding: EdgeInsets.fromLTRB(20.0, 200.0, 20.0, 0.0),
      child: Column(
        children: boardRow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int timeElapsed = stopwatch.elapsedMilliseconds ~/ 1000;
    return WillPopScope(
      onWillPop: onBackPressed2,
      child: new Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 0.0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(130.0),
              child: Column(children: <Widget>[
                Container(
                  height: 40.0,
                  child: Row(children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.restart_alt),
                      tooltip: 'Restart game',
                      color: Colors.black,
                      iconSize: 40.0,
                      padding: EdgeInsets.only(left: 30.0),
                      onPressed: () => resetBoard(),
                    ),
                    Container(
                      height: 40.0,
                      padding: EdgeInsets.only(left: 60.0),
                      child: Row(children: <Widget>[
                        Icon(
                          Icons.alarm,
                          color: Colors.black,
                          size: 40.0,
                        ),
                        Container(
                          height: 40.0,
                          padding: EdgeInsets.only(top: 5.0),
                          width: 150.0,
                          child: RichText(
                            text: TextSpan(
                              text:
                                  "${timeElapsed ~/ 60} m ${timeElapsed % 60} s",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 30.0),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    IconButton(
                      icon: Icon(Icons.palette),
                      tooltip: 'Select color',
                      color: Colors.black,
                      iconSize: 40.0,
                      padding: EdgeInsets.only(left: 20.0),
                      onPressed: () {
                        bool x = stopwatch.isRunning;
                        if (x) stopwatch.stop();
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  content: SingleChildScrollView(
                                    child: ColorPicker(
                                      color: currentColor,
                                      onColorChanged: changeColor,
                                      enableShadesSelection: true,
                                      enableOpacity: true,
                                      pickersEnabled: const <ColorPickerType,
                                          bool>{
                                        ColorPickerType.both: false,
                                        ColorPickerType.primary: false,
                                        ColorPickerType.accent: false,
                                        ColorPickerType.bw: false,
                                        ColorPickerType.custom: false,
                                        ColorPickerType.wheel: true
                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    /*
                                    TextButton(
                                      child: Text('Revert color'),
                                      onPressed: () {
                                        changeColor(currentColor);
                                      },
                                    ),
                                    */
                                    TextButton(
                                      child: Text('Select color'),
                                      onPressed: () {
                                        if (x) stopwatch.start();
                                        setState(
                                            () => currentColor = pickerColor);
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ]);
                            });
                      },
                    ),
                  ]),
                ),
                Container(
                  height: 60.0,
                  padding: EdgeInsets.only(top: 25.0),
                  child: RichText(
                    text: TextSpan(
                      text: wonGame
                          ? "You've Won!"
                          : alive
                              ? ""
                              : "You've Lost!",
                      style: TextStyle(color: Colors.black, fontSize: 30.0),
                    ),
                  ),
                ),
              ]),
            )),
        body: Container(
          color: Colors.grey[50],
          child: Center(
            child: buildBoard(),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(children: <Widget>[
            Container(
              child: alive && !wonGame
                  ? Icon(
                      Icons.flag,
                      color: Colors.black,
                      size: 40.0,
                    )
                  : Icon(
                      Icons.star,
                      color: Colors.black,
                      size: 40.0,
                    ),
              padding: EdgeInsets.only(left: 150.0),
            ),
            Container(
              height: 40.0,
              padding: EdgeInsets.only(top: 5.0),
              child: RichText(
                text: TextSpan(
                  text: alive
                      ? "$flagsplaced/$numOfMines"
                      : "$minesfound/$numOfMines",
                  style: TextStyle(
                      color: Colors.black,
                      backgroundColor: Colors.transparent,
                      fontSize: 30.0),
                ),
              ),
            ),
          ]),
          color: Colors.transparent,
          elevation: 0.0,
        ),
      ),
    );
  }

  Future<bool> onBackPressed2() {
    bool y = stopwatch.isRunning;
    if (y) stopwatch.stop();
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the app?'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => {
              stopwatch.reset(),
              Navigator.of(context).pop(true),
            },
            child: Text("Get back to Main Menu"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => {
              if (y) stopwatch.start(),
              Navigator.of(context).pop(false),
            },
            child: Text("No"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => {
              stopwatch.reset(),
              exit(1),
            },
            child: Text("Yes"),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  void probe(int x, int y) {
    if (!alive) return;
    if (uiState[x][y] == TileState.flagged) return;
    setState(() {
      if (tiles[x][y]) {
        uiState[x][y] = TileState.blown;
        alive = false;
        timer?.cancel();
      } else {
        open(x, y);
        if (!stopwatch.isRunning) stopwatch.start();
      }
    });
  }

  void open(int x, int y) {
    if (!inBoard(x, y)) return;
    if (uiState[x][y] == TileState.open) return;
    uiState[x][y] = TileState.open;

    if (mineCount(x, y) > 0) return;
    open(x - 1, y);
    open(x + 1, y);
    open(x, y - 1);
    open(x, y + 1);
    open(x - 1, y - 1);
    open(x - 1, y + 1);
    open(x + 1, y - 1);
    open(x + 1, y + 1);
  }

  void flag(int x, int y) {
    if (!alive) return;
    setState(() {
      if (uiState[x][y] == TileState.flagged) {
        uiState[x][y] = TileState.covered;
        if (tiles[x][y]) minesfound--;
        --flagsplaced;
      } else {
        if (tiles[x][y]) minesfound++;
        if (flagsplaced < numOfMines) {
          uiState[x][y] = TileState.flagged;
          ++flagsplaced;
        }
      }
    });
  }

  int mineCount(int x, int y) {
    int count = 0;
    count += bombs(x - 1, y);
    count += bombs(x + 1, y);
    count += bombs(x, y - 1);
    count += bombs(x, y + 1);
    count += bombs(x - 1, y - 1);
    count += bombs(x - 1, y + 1);
    count += bombs(x + 1, y - 1);
    count += bombs(x + 1, y + 1);
    return count;
  }

  int bombs(int x, int y) => inBoard(x, y) && tiles[x][y] ? 1 : 0;
  bool inBoard(int x, int y) => x >= 0 && x < rows && y >= 0 && y < cols;
}

Widget buildTile(Widget child) {
  return Container(
    padding: EdgeInsets.all(1.0),
    height: 315.0 / rows,
    width: 315.0 / cols,
    color: Colors.grey[350],
    margin: EdgeInsets.all(2.0),
    child: child,
  );
}

Widget buildInnerTile(Widget child) {
  return Container(
    padding: EdgeInsets.all(1.0),
    margin: EdgeInsets.all(2.0),
    height: 20.0,
    width: 20.0,
    child: child,
  );
}

class CoveredMineTile extends StatelessWidget {
  final bool flagged;
  final int? posX;
  final int? posY;

  CoveredMineTile({this.flagged = false, this.posX, this.posY});

  @override
  Widget build(BuildContext context) {
    Widget? text;
    if (flagged) {
      text = buildInnerTile(RichText(
        text: TextSpan(
          text: '\u2691',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: (315 - 4 * rows) / (max(rows, cols) + 5),
          ),
        ),
        textAlign: TextAlign.center,
      ));
    }
    Widget innerTile = Container(
      padding: EdgeInsets.all(1.0),
      margin: EdgeInsets.all(1.0),
      height: 20.0,
      width: 20.0,
      color: currentColor,
      child: text,
    );
    return buildTile(innerTile);
  }
}

class OpenMineTIle extends StatelessWidget {
  TileState? state;
  int count;
  bool isflagged;

  OpenMineTIle({this.state, this.count = 0, this.isflagged = false});

  final List textColor = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.cyan,
    Colors.amber,
    Colors.brown,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    Widget text = RichText(
      text: TextSpan(),
    );

    if (state == TileState.open) {
      if (count != 0) {
        text = RichText(
          text: TextSpan(
            text: '$count',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor[count - 1],
              fontSize: (315 - 4 * rows) / (max(rows, cols) + 5),
            ),
          ),
          textAlign: TextAlign.center,
        );
      }
    } else if (isflagged) {
      text = RichText(
        text: TextSpan(
          text: '\u2691',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontSize: (315 - 4 * rows) / (max(rows, cols) + 5),
          ),
        ),
        textAlign: TextAlign.center,
      );
    } else {
      text = RichText(
        text: TextSpan(
          text: '\u2739',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontSize: (315 - 4 * rows) / (max(rows, cols) + 5),
          ),
        ),
        textAlign: TextAlign.center,
      );
    }
    return buildTile(buildInnerTile(text));
  }
}
