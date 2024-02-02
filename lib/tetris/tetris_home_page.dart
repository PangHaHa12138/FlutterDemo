import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:test001/tetris/gamer/gamer.dart';
import 'package:test001/tetris/gamer/keyboard.dart';
import 'package:test001/tetris/material/audios.dart';
import 'package:test001/tetris/panel/page_portrait.dart';



const SCREEN_BORDER_WIDTH = 3.0;

const BACKGROUND_COLOR = const Color(0xffefcc19);

class TetrisHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //only Android/iOS support land mode
    bool land = MediaQuery.of(context).orientation == Orientation.landscape;
    return Sound(child: Game(child: KeyboardController(child: land ? PageLand() : PagePortrait())));
  }
}