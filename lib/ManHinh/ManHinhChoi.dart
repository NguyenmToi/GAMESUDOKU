import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/ChonManChoi.dart';

class ManHinhChoi extends StatefulWidget {
  const ManHinhChoi({super.key, required this.tenMan});

  final String tenMan;

  @override
  State<ManHinhChoi> createState() => _ManHinhChoiState();
}

class _ManHinhChoiState extends State<ManHinhChoi> {
  int giay = 30;
  late Timer thoiGian;
  bool ktNhan = false;
  int? selectedRow;
  int? selectedCol;

  void handleCellTap(int row, int col) {
    setState(() {
      if (selectedRow == row && selectedCol == col) {
        // Nếu ô đã được chọn rồi thì bỏ chọn
        selectedRow = null;
        selectedCol = null;
      } else {
        // Nếu chưa được chọn thì chọn ô này
        selectedRow = row;
        selectedCol = col;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    batdauthoigian();
  }

  void batdauthoigian() {
    const oneSecond = Duration(seconds: 1);
    thoiGian = Timer.periodic(oneSecond, (Timer thoiGian) {
      setState(() {
        if (giay <= 0) {
          thoiGian.cancel();
          thongBaoThua();
        } else {
          giay--;
        }
      });
    });
  }

  @override
  void dispose() {
    thoiGian.cancel(); // Hủy Timer khi Widget bị dispose để tránh rò rỉ bộ nhớ
    super.dispose();
  }

  String dinhDang(int timeInSeconds) {
    int minutes = timeInSeconds ~/ 60;
    int seconds = timeInSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  List<List<int>> board = List.generate(9, (_) => List.generate(9, (_) => 0));
  //List.generate(9, (_) => ...): Tạo ra một danh sách 1 chiều gồm 9 phần tử. Mỗi phần tử được khởi tạo bằng cách gọi hàm List.generate(9, (_) => 0).
  //List.generate(9, (_) => 0): Tạo ra một danh sách 1 chiều gồm 9 phần tử, mỗi phần tử được khởi tạo bằng giá trị 0.
  // _ biến ẩn danh : không cần đặt tên cho biến
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[200], // Màu nền appbar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.grey,
          onPressed: () {
            thongBaoThoat();
          },
        ),
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right: 38.0),
                child: Text(
                  '${widget.tenMan}',
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 70, 5, 10),
        child: Stack(
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    '${dinhDang(giay)}',
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                // Tạo lưới 9x9 ô
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 9, // số lượng cột trong lưới
                      childAspectRatio: 0.8, // tỉ lệ giữa chiều rộng và cao
                    ),
                    itemBuilder: (context, index) {
                      int row = index ~/ 9; // lấy chỉ số hàng, chia lấy nguyên
                      int col = index %
                          9; // lấy chỉ số cột, chia lấy dư, vd ô 27%9 = 3 dư 0: hàng 3 cột 0
                      return GestureDetector(
                        // widget phát hiện cử chỉ tương tác với ứng dụng
                        onTap: () {
                          handleCellTap(row, col);
                        },
                        child: Container(
                          color: board[row][col] == 1 ? Colors.blue[250] : null,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color:
                                    (row % 3 == 0) ? Colors.black : Colors.grey,
                                width: 1.0,
                              ),
                              left: BorderSide(
                                color:
                                    (col % 3 == 0) ? Colors.black : Colors.grey,
                                width: 1.0,
                              ),
                              bottom: BorderSide(
                                color: ((row + 1) % 3 == 0)
                                    ? Colors.black
                                    : Colors.grey,
                                width: 1.0,
                              ),
                              right: BorderSide(
                                color: ((col + 1) % 3 == 0)
                                    ? Colors.black
                                    : Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              board[row][col] == 0
                                  ? ''
                                  : board[row][col].toString(),
                              style: const TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: 81,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          xaydungso(1),
                          xaydungso(2),
                          xaydungso(3),
                          xaydungso(4),
                          xaydungso(5)
                        ]),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          xaydungso(6),
                          xaydungso(7),
                          xaydungso(8),
                          xaydungso(9),
                          Ink(
                            decoration: ShapeDecoration(
                                shape: CircleBorder(), color: Colors.blue[100]),
                            child: IconButton(
                                onPressed: () {},
                                color: Colors.black,
                                icon: Icon(Icons.lightbulb_outline_sharp)),
                          ),
                        ]),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void thongBaoThua() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Trò chơi kết thúc',
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          content: const Text('Bạn đã thua, bạn có muốn chơi lại không ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Thoát'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Đồng ý'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManHinhChoi(
                      tenMan: widget.tenMan,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void thongBaoThoat() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Thoát trò chơi',
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          content:
              const Text('Thoát sẽ hủy kết quả, bạn có muốn thoát không ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Đồng ý'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ở lại'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManHinhChoi(
                      tenMan: widget.tenMan,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

Widget xaydungso(int number) {
  return Container(
    width: 60,
    height: 45,
    decoration: BoxDecoration(
      color: Colors.blue[100],
      borderRadius: BorderRadius.circular(8),
    ),
    child: GestureDetector(
      onTap: () {
        print('Button $number pressed');
      },
      child: Center(
        child: Text(
          number.toString(),
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
    ),
  );
}
