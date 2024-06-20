import 'package:flutter/material.dart';

class LichSuaChoi extends StatefulWidget {
  const LichSuaChoi({super.key});

  @override
  State<LichSuaChoi> createState() => LichSuaChoiState();
}

class LichSuaChoiState extends State<LichSuaChoi> {
  // Danh sách các bảng Sudoku cùng với ngày tháng
  final List<BangSudoku> sudokuList = [
    BangSudoku(date: DateTime(2022, 10, 20), cellSize: 17.0),
    BangSudoku(date: DateTime(2022, 10, 21), cellSize: 17.0),
    BangSudoku(date: DateTime(2022, 10, 22), cellSize: 17.0),
    // Thêm các bảng Sudoku khác ở đây
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch Sử Chơi'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: sudokuList.map((sudoku) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ngày: ${sudoku.date.day}/${sudoku.date.month}/${sudoku.date.year}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sudoku,
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, size: 20),
                              SizedBox(width: 5),
                              Text('Độ khó: Dễ'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.timer, size: 20),
                              SizedBox(width: 5),
                              Text('Thời gian: 00:30'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.lightbulb, size: 20),
                              SizedBox(width: 5),
                              Text('Gợi ý: 3'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.error, size: 20),
                              SizedBox(width: 5),
                              Text('Lượt sai: 1'),
                            ],
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // Background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15), // Rounded corners
                              ),
                            ),
                            onPressed: () {
                              // Hành động khi nhấn nút
                            },
                            child: Text(
                              'Chơi lại',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class BangSudoku extends StatelessWidget {
  final DateTime date;
  final double cellSize;

  BangSudoku({required this.date, required this.cellSize});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Ensure the GridView is within a fixed size
        double gridSize = cellSize * 9 + 8.0 * 2; // 9 cells + 2 * padding

        return Container(
          width: gridSize,
          height: gridSize,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(), // Disable scrolling
            shrinkWrap:
                true, // Allow GridView to occupy only the space it needs
            itemCount: 81, // 9x9 grid
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 9,
              mainAxisSpacing: 0.2, // Vertical spacing between cells
              crossAxisSpacing: 0.2, // Horizontal spacing between cells
            ),
            itemBuilder: (context, index) {
              // Determine fixed border widths
              double borderLeft = 0.2;
              double borderRight = 0.2;
              double borderTop = 0.2;
              double borderBottom = 0.2;

              // Adjust border widths for 3x3 blocks
              if ((index % 9) % 3 == 0) {
                borderLeft = 1.2;
              }
              if (index % 9 == 8 || (index % 9 + 1) % 3 == 0) {
                borderRight = 1.2;
              }
              if ((index ~/ 9) % 3 == 0) {
                borderTop = 1.2;
              }
              if (index ~/ 9 == 8 || (index ~/ 9 + 1) % 3 == 0) {
                borderBottom = 1.2;
              }

              return Container(
                width: cellSize,
                height: cellSize,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(width: borderLeft, color: Colors.black),
                    right: BorderSide(width: borderRight, color: Colors.black),
                    top: BorderSide(width: borderTop, color: Colors.black),
                    bottom:
                        BorderSide(width: borderBottom, color: Colors.black),
                  ),
                ),
                child: Center(child: Text('')),
              );
            },
          ),
        );
      },
    );
  }
}
