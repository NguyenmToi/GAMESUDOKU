import 'package:flutter/material.dart';

class ManHinhChoiMucDo extends StatefulWidget {
  const ManHinhChoiMucDo({super.key});

  @override
  State<ManHinhChoiMucDo> createState() => _ManHinhChoiMucDoState();
}

class _ManHinhChoiMucDoState extends State<ManHinhChoiMucDo> {
  List<List<int?>> board =
      List.generate(9, (_) => List.generate(9, (_) => null));
  int? selectedRow;
  int? selectedCol;

  void selectCell(int row, int col) {
    setState(() {
      selectedRow = row;
      selectedCol = col;
    });
  }

  void inputNumber(int number) {
    if (selectedRow != null && selectedCol != null) {
      setState(() {
        board[selectedRow!][selectedCol!] = number;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sudoku'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Sudoku',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Mức độ: Dễ', style: TextStyle(fontSize: 18)),
                Text('Số lượt sai: 3', style: TextStyle(fontSize: 18)),
                Text('Gợi ý: 5', style: TextStyle(fontSize: 18)),
                Text('Thời gian: 00:00', style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 20),
            bangSudoku(board, selectCell, selectedRow, selectedCol),
            SizedBox(height: 20),
            SudokuButtons(inputNumber),
          ],
        ),
      ),
    );
  }
}

class bangSudoku extends StatelessWidget {
  final List<List<int?>> board;
  final Function(int, int) selectCell;
  final int? selectedRow;
  final int? selectedCol;

  bangSudoku(this.board, this.selectCell, this.selectedRow, this.selectedCol);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double cellSize = (screenWidth - 16.0) / 9.0;

        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 81,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 9,
              mainAxisSpacing: 0.2,
              crossAxisSpacing: 0.2,
            ),
            itemBuilder: (context, index) {
              int row = index ~/ 9;
              int col = index % 9;

              double borderLeft = 0.2;
              double borderRight = 0.2;
              double borderTop = 0.2;
              double borderBottom = 0.2;

              if (col % 3 == 0) borderLeft = 1.2;
              if (col == 8 || (col + 1) % 3 == 0) borderRight = 1.2;
              if (row % 3 == 0) borderTop = 1.2;
              if (row == 8 || (row + 1) % 3 == 0) borderBottom = 1.2;

              return GestureDetector(
                onTap: () => selectCell(row, col),
                child: Container(
                  width: cellSize,
                  height: cellSize,
                  decoration: BoxDecoration(
                    color: selectedRow == row && selectedCol == col
                        ? Colors.blue[100]
                        : Colors.white,
                    border: Border(
                      left: BorderSide(width: borderLeft, color: Colors.black),
                      right:
                          BorderSide(width: borderRight, color: Colors.black),
                      top: BorderSide(width: borderTop, color: Colors.black),
                      bottom:
                          BorderSide(width: borderBottom, color: Colors.black),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      board[row][col]?.toString() ?? '',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class SudokuButtons extends StatelessWidget {
  final Function(int) inputNumber;

  SudokuButtons(this.inputNumber);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () => inputNumber(index + 1),
                    child: Text('${index + 1}'),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () => inputNumber(index + 6),
                    child: Text('${index + 6}'),
                  ),
                ),
              );
            }).followedBy([
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.lightbulb_outline),
                  ),
                ),
              ),
            ]).toList(),
          ),
        ],
      ),
    );
  }
}
