import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart' as c;

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  c.ChessBoardController controller = c.ChessBoardController();

  @override
  Widget build(BuildContext context) {
    return c.ChessBoard(
      controller: controller,
      boardColor: c.BoardColor.darkBrown,
      boardOrientation: c.PlayerColor.white,
    );
  }
}
