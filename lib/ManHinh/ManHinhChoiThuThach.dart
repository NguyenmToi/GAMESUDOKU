import 'dart:async';
import 'package:flutter/material.dart';

class ManHinhChoiThuThach extends StatefulWidget {
  const ManHinhChoiThuThach({super.key, required this.tenMan});

  final String tenMan;

  @override
  State<ManHinhChoiThuThach> createState() => _ManHinhChoiThuThachState();
}

class _ManHinhChoiThuThachState extends State<ManHinhChoiThuThach> {
  int giay = 300;
  late Timer thoiGian;
  int? selectedRow;
  int? selectedCol;

  @override
  void initState() {
    super.initState();
    batDauThoiGian();
  }

  void batDauThoiGian() {
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
    thoiGian.cancel();
    super.dispose();
  }

  String dinhDang(int timeInSeconds) {
    int minutes = timeInSeconds ~/ 60;
    int seconds = timeInSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  List<List<int>> board = List.generate(9, (_) => List.generate(9, (_) => 0));

  void handleCellTap(int row, int col) {
    setState(() {
      selectedRow = row;
      selectedCol = col;
    });
  }

  void handleNumberTap(int number) {
    if (selectedRow != null && selectedCol != null) {
      setState(() {
        board[selectedRow!][selectedCol!] = number;
        selectedRow = null;
        selectedCol = null;
      });
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
        padding: const EdgeInsets.fromLTRB(5, 100, 5, 10),
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
                      childAspectRatio: 1, // tỉ lệ giữa chiều rộng và cao
                    ),
                    itemBuilder: (context, index) {
                      int row = index ~/ 9; // lấy chỉ số hàng, chia lấy nguyên
                      int col = index % 9; // lấy chỉ số cột, chia lấy dư
                      bool isSelected =
                          row == selectedRow && col == selectedCol;

                      Border border = Border(
                        top: BorderSide(
                          color: row == 0
                              ? Colors.black
                              : (row % 3 == 0)
                                  ? Colors.black
                                  : Colors.grey,
                          width: row == 0 ? 1.0 : 1.0,
                        ),
                        left: BorderSide(
                          color: col == 0
                              ? Colors.black
                              : (col % 3 == 0)
                                  ? Colors.black
                                  : Colors.grey,
                          width: col == 0 ? 1.0 : 1.0,
                        ),
                        bottom: BorderSide(
                          color: row == 8
                              ? Colors.black
                              : ((row + 1) % 3 == 0)
                                  ? Colors.black
                                  : Colors.grey,
                          width: row == 8 ? 1.0 : 1.0,
                        ),
                        right: BorderSide(
                          color: col == 8
                              ? Colors.black
                              : ((col + 1) % 3 == 0)
                                  ? Colors.black
                                  : Colors.grey,
                          width: col == 8 ? 1.0 : 1.0,
                        ),
                      );

                      return InkWell(
                        onTap: () => handleCellTap(row, col),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue[100] : null,
                            border: border,
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
                        for (int i = 1; i <= 5; i++) xayDungSo(i),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 6; i <= 9; i++) xayDungSo(i),
                        Ink(
                            height: 45,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              child: IconButton(
                                onPressed: () {},
                                color: Colors.black,
                                icon: const Icon(Icons.lightbulb_outline_sharp),
                              ),
                            )),
                      ],
                    ),
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
                    builder: (context) => ManHinhChoiThuThach(
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
              },
            ),
          ],
        );
      },
    );
  }

  Widget xayDungSo(int number) {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          handleNumberTap(number);
        },
        child: Container(
          width: 60,
          height: 45,
          alignment: Alignment.center,
          child: Text(
            number.toString(),
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
