import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemChiTietDoKho extends StatefulWidget {
  const ThemChiTietDoKho({Key? key}) : super(key: key);

  @override
  State<ThemChiTietDoKho> createState() => ThemChiTietDoKhoState();
}

class ThemChiTietDoKhoState extends State<ThemChiTietDoKho> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController hiddenCellsController = TextEditingController();
  final TextEditingController hintsController = TextEditingController();

  // Input formatters to allow only numeric input
  final _numberTextInputFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

  void _addDifficulty() {
    // Check if any field is empty
    if (nameController.text.isEmpty ||
        hiddenCellsController.text.isEmpty ||
        hintsController.text.isEmpty) {
      // Show an error dialog if any field is empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Missing Information'),
          content: Text('Please fill in all fields.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Parse the number of hidden cells from the controller
    int hiddenCells = int.tryParse(hiddenCellsController.text) ?? 0;

    if (hiddenCells <= 0 || hiddenCells > 81) {
      // Show an error dialog if the number of hidden cells is invalid
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid Input'),
          content: Text('Number of hidden cells must be between 1 and 81.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Proceed with adding the difficulty level
      // Implement your logic here
      // For now, just print the values
      print('Name: ${nameController.text}');
      print('Hidden Cells: $hiddenCells');
      print('Hints: ${hintsController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm mức độ'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Tên mức độ'),
            ),
            TextField(
              controller: hiddenCellsController,
              decoration: InputDecoration(labelText: 'Số ô ẩn'),
              keyboardType: TextInputType.number,
              inputFormatters: [_numberTextInputFormatter],
            ),
            TextField(
              controller: hintsController,
              decoration: InputDecoration(labelText: 'Số gợi ý'),
              keyboardType: TextInputType.number,
              inputFormatters: [_numberTextInputFormatter],
            ),
            SizedBox(height: 20),
            bangSudoku(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your solve game logic here
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // Rounded corners
                      ),
                    ),
                    child: Text(
                      'Giải trò chơi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your random game logic here
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // Rounded corners
                      ),
                    ),
                    child: Text(
                      'Ngẫu nhiên',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: _addDifficulty,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // Rounded corners
                      ),
                    ),
                    child: Text(
                      'Thêm mức độ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class bangSudoku extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate cell size based on screen width minus padding and border widths
        double screenWidth = constraints.maxWidth;
        double cellSize =
            (screenWidth - 16.0) / 9.0; // 16.0 is total padding (8.0 * 2)

        return Container(
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
