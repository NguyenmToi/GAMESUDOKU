import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

class SuaMucDoChoi extends StatefulWidget {
  SuaMucDoChoi({
    Key? key,
    required this.mamucdo,
    required this.tenmucdo,
    required this.soan,
    required this.diem,
  }) : super(key: key);

  final int mamucdo;
  final String tenmucdo;
  final int soan;
  final int diem;
  @override
  State<SuaMucDoChoi> createState() => _SuaMucDoChoiState();
}

class _SuaMucDoChoiState extends State<SuaMucDoChoi> {
  final TextEditingController TenMucDo = TextEditingController();
  final TextEditingController SoOAn = TextEditingController();
  final TextEditingController diem = TextEditingController();

  @override
  void initState() {
    super.initState();
    TenMucDo.text = widget.tenmucdo;
    SoOAn.text = widget.soan.toString();
    diem.text = widget.diem.toString();
  }

  // final ChuNhapHopLe =
  //     FilteringTextInputFormatter.deny(RegExp(r'[\u0300-\u036f]'));

  // Khởi tạo bảng Sudoku
  List<List<int>> BangSudoku =
      List.generate(9, (_) => List.generate(9, (_) => 0));
  List<List<bool>> oKhoiTao =
      List.generate(9, (_) => List.generate(9, (_) => false));
  List<List<bool>> oDaThayDoi =
      List.generate(9, (_) => List.generate(9, (_) => false));

  void xoaONgauNhien() {
    setState(() {
      try {
        int soOAn = int.tryParse(SoOAn.text) ?? 0;
        soOAn = soOAn.clamp(0, 81);
        BangSudoku = List.generate(9, (_) => List.generate(9, (_) => 0));
        oKhoiTao = List.generate(9, (_) => List.generate(9, (_) => false));
        oDaThayDoi = List.generate(9, (_) => List.generate(9, (_) => false));
        dienSudokuNgauNhien(0, 0);
        List<int> ViTriO = [];
        for (int i = 0; i < 81; i++) {
          if (BangSudoku[i ~/ 9][i % 9] != 0) {
            ViTriO.add(i);
          }
        }
        ViTriO.shuffle();
        for (int i = 0; i < soOAn; i++) {
          int index = ViTriO[i];
          int row = index ~/ 9;
          int col = index % 9;
          if (!oKhoiTao[row][col]) {
            BangSudoku[row][col] = 0;
            oKhoiTao[row][col] = true;
          } else {
            i--;
          }
        }
      } catch (e) {
        print('Lỗi: $e');
      }
    });
  }

  bool dienSudokuNgauNhien(int row, int col) {
    if (row == 9) {
      return true;
    }
    int nextRow = (col == 8) ? (row + 1) : row;
    int nextCol = (col + 1) % 9;
    List<int> randomNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    randomNumbers.shuffle();

    for (int num in randomNumbers) {
      if (KiemTraHopLe(row, col, num)) {
        BangSudoku[row][col] = num;
        if (dienSudokuNgauNhien(nextRow, nextCol)) {
          return true;
        }
        BangSudoku[row][col] = 0;
      }
    }
    return false;
  }

  bool KiemTraHopLe(int row, int col, int num) {
    for (int i = 0; i < 9; i++) {
      if (BangSudoku[row][i] == num || BangSudoku[i][col] == num) {
        return false;
      }
    }
    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;
    for (int i = startRow; i < startRow + 3; i++) {
      for (int j = startCol; j < startCol + 3; j++) {
        if (BangSudoku[i][j] == num) {
          return false;
        }
      }
    }

    return true;
  }

  bool giaiSudoku(int row, int col) {
    if (row == 9) {
      return true;
    }
    int nextRow = (col == 8) ? (row + 1) : row;
    int nextCol = (col + 1) % 9;

    if (BangSudoku[row][col] != 0) {
      return giaiSudoku(nextRow, nextCol);
    }

    for (int num = 1; num <= 9; num++) {
      if (KiemTraHopLe(row, col, num)) {
        setState(() {
          BangSudoku[row][col] = num;
          oDaThayDoi[row][col] = true;
        });

        if (giaiSudoku(nextRow, nextCol)) {
          return true;
        }

        setState(() {
          BangSudoku[row][col] = 0;
          oDaThayDoi[row][col] = false;
        });
      }
    }

    return false;
  }

  void CapNhatDuLieu() async {
    if (TenMucDo.text.isEmpty || SoOAn.text.isEmpty || diem.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Thiếu thông tin'),
          content: const Text('Vui lòng điền đầy đủ thông tin.'),
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

    int SoAn = int.tryParse(SoOAn.text) ?? 0;
    int DiemSo = int.tryParse(diem.text) ?? 0;

    if (SoAn <= 0 || SoAn > 81) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Thông tin không hợp lệ'),
          content: Text('Số ô ẩn phải từ 1 đến 81.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      try {
        int mamucdo = widget.mamucdo;
        await cmucDo.capNhatMucDoChoi(mamucdo, TenMucDo.text, SoAn, DiemSo);
        print('Tên: ${TenMucDo.text}');
        print('Số ô ẩn: $SoAn');
        print('Số điểm: $DiemSo');

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Thành công'),
            content: const Text('Đã cập nhật mức độ thành công.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        print('Lỗi: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[200],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Cập nhật mức độ chơi',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: TenMucDo,
                    decoration: const InputDecoration(labelText: 'Tên mức độ'),
                    // inputFormatters: [ChuNhapHopLe],
                  ),
                  TextField(
                    controller: SoOAn,
                    decoration: const InputDecoration(labelText: 'Số ô ẩn'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: diem,
                    decoration: const InputDecoration(labelText: 'Số điểm'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  BangSudokuWidget(BangSudoku, oDaThayDoi),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: xoaONgauNhien,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Ngẫu nhiên',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            giaiSudoku(0, 0);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
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
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: CapNhatDuLieu,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Cập nhật mức độ',
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
        ],
      ),
    );
  }
}

class BangSudokuWidget extends StatelessWidget {
  final List<List<int>> BangSudoku;
  final List<List<bool>> oDaThayDoi;

  BangSudokuWidget(this.BangSudoku, this.oDaThayDoi);

  @override
  Widget build(BuildContext context) {
    double boardSize = MediaQuery.of(context).size.width * 1;
    return Container(
      width: boardSize,
      height: boardSize,
      child: GridView.builder(
        key: UniqueKey(), // Thêm key để rebuild khi dữ liệu thay đổi
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          int row = index ~/ 9;
          int col = index % 9;
          Border border = Border(
            top: BorderSide(
              color: row == 0
                  ? Colors.black
                  : (row % 3 == 0)
                      ? Colors.black
                      : Colors.grey,
              width: 0.7,
            ),
            left: BorderSide(
              color: col == 0
                  ? Colors.black
                  : (col % 3 == 0)
                      ? Colors.black
                      : Colors.grey,
              width: 0.7,
            ),
            bottom: BorderSide(
              color: row == 8
                  ? Colors.black
                  : ((row + 1) % 3 == 0)
                      ? Colors.black
                      : Colors.grey,
              width: 0.7,
            ),
            right: BorderSide(
              color: col == 8
                  ? Colors.black
                  : ((col + 1) % 3 == 0)
                      ? Colors.black
                      : Colors.grey,
              width: 0.7,
            ),
          );

          return Container(
            decoration: BoxDecoration(border: border),
            child: Center(
              child: Text(
                BangSudoku[row][col] == 0
                    ? ''
                    : BangSudoku[row][col].toString(),
                style: TextStyle(
                  fontSize: 20,
                  color: oDaThayDoi[row][col] ? Colors.blue : Colors.black,
                ),
              ),
            ),
          );
        },
        itemCount: 81,
      ),
    );
  }
}
