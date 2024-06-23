import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaoDoKho extends StatefulWidget {
  const TaoDoKho({Key? key}) : super(key: key);

  @override
  State<TaoDoKho> createState() => TaoDoKhoState();
}

class TaoDoKhoState extends State<TaoDoKho> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController hiddenCellsController = TextEditingController();
  final TextEditingController hintsController = TextEditingController();

  final _numberTextInputFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

  void _addDifficulty() {
    if (nameController.text.isEmpty ||
        hiddenCellsController.text.isEmpty ||
        hintsController.text.isEmpty) {
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

    int hiddenCells = int.tryParse(hiddenCellsController.text) ?? 0;

    if (hiddenCells <= 0 || hiddenCells > 81) {
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
      print('Name: ${nameController.text}');
      print('Hidden Cells: $hiddenCells');
      print('Hints: ${hintsController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[200], // Màu nền appbar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(right: 38.0),
                child: Text(
                  'Tạo mức độ chơi',
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
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
                Expanded(
                  child: SizedBox(
                    height: 45, // Set the height for the button
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your random game logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // Rounded corners
                        ),
                      ),
                      child: Text(
                        'Ngẫu nhiên',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Giải trò chơi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _addDifficulty,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Thêm mức độ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
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
              double borderLeft = 0.2;
              double borderRight = 0.2;
              double borderTop = 0.2;
              double borderBottom = 0.2;

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
