import 'package:flutter/material.dart';

class TaoManChoi extends StatefulWidget {
  const TaoManChoi({super.key});

  @override
  State<TaoManChoi> createState() => _TaoManChoiState();
}

class _TaoManChoiState extends State<TaoManChoi> {
  List<List<int>> bangSudoku =
      List.generate(9, (_) => List.generate(9, (_) => 0));

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
                  'Tạo màn chơi',
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 3, 5, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dòng 1: Tên màn chơi và ô nhập thông tin
            Row(
              children: [
                Text(
                  'Tên màn chơi:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey), // Viền xám
                      borderRadius: BorderRadius.circular(5), // Bo tròn góc
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder
                              .none, // Loại bỏ viền của TextFormField
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'Thời gian:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey), // Viền xám
                      borderRadius: BorderRadius.circular(5), // Bo tròn góc
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder
                              .none, // Loại bỏ viền của TextFormField
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Số gợi ý:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey), // Viền xám
                      borderRadius: BorderRadius.circular(5), // Bo tròn góc
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder
                              .none, // Loại bỏ viền của TextFormField
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Xử lý khi nhấn nút Giải trò chơi
                    },
                    child: Text(
                      'Giải trò chơi',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      _maTranNgauNhien();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(10),
                    ),
                    child: Text(
                      'Ngẫu nhiên',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Xử lý khi nhấn nút Ẩn
                    },
                    color: Colors.black,
                    icon: Icon(Icons.visibility_off),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Xử lý khi nhấn nút Hiện
                    },
                    color: Colors.black,
                    icon: Icon(Icons.visibility),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5), // Khoảng cách giữa các dòng
            // GridView và các nút chức năng
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9, // số lượng cột trong lưới
                  childAspectRatio: 0.85, // tỉ lệ giữa chiều rộng và cao
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ 9; // lấy chỉ số hàng, chia lấy nguyên
                  int col = index %
                      9; // lấy chỉ số cột, chia lấy dư, vd ô 27%9 = 3 dư 0: hàng 3 cột 0
                  return GestureDetector(
                    // widget phát hiện cử chỉ tương tác với ứng dụng
                    onTap: () {},
                    child: Container(
                      color: null,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: (row % 3 == 0) ? Colors.black : Colors.grey,
                            width: 1.0,
                          ),
                          left: BorderSide(
                            color: (col % 3 == 0) ? Colors.black : Colors.grey,
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
                          bangSudoku[row][col] == 0
                              ? ''
                              : bangSudoku[row][col].toString(),
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
            SizedBox(
                height: 10), // Khoảng cách giữa GridView và các nút chức năng
            // Dòng nút chức năng

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                xaydungso(1),
                xaydungso(2),
                xaydungso(3),
                xaydungso(4),
                xaydungso(5),
              ],
            ),
            SizedBox(height: 3), // Khoảng cách giữa các dòng nút chức năng
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                xaydungso(6),
                xaydungso(7),
                xaydungso(8),
                xaydungso(9),
                Container(
                    width: 60,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.rotate_left_rounded)),
              ],
            ),
            SizedBox(
                height:
                    15), // Khoảng cách giữa dòng nút chức năng và nút "Thêm màn chơi"
            // Nút "Thêm màn chơi"
            Center(
              child: Container(
                width: double
                    .infinity, // Chiều rộng bằng toàn bộ không gian có sẵn
                decoration: BoxDecoration(
                  color: Colors.blue, // Màu nền xanh
                  borderRadius: BorderRadius.circular(15), // Bo tròn góc
                ),
                child: TextButton(
                  onPressed: () {
                    // Xử lý khi nhấn nút
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 10), // Khoảng cách lề trên và dưới
                  ),
                  child: Text(
                    'Thêm màn chơi',
                    style: TextStyle(
                        color: Colors.white, fontSize: 18), // Màu chữ đen
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _NgauNhienSudoku(int row, int col) {
    if (row == 9) {
      return true; // Đã điền đầy đủ Sudoku thành công
    }

    // Tính toán hàng và cột tiếp theo
    int nextRow = (col == 8) ? (row + 1) : row;
    int nextCol = (col + 1) % 9;

    // Xáo trộn các số từ 1 đến 9 để ngẫu nhiên hóa quá trình sinh ra Sudoku
    List<int> nums = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    nums.shuffle();

    // Thử điền ô hàng,cột từng số
    for (int num in nums) {
      if (_hopLe(row, col, num)) {
        // Đặt số nếu số đó hợp lệ
        bangSudoku[row][col] = num;

        // Điền đệ quy ô tiếp theo
        if (_NgauNhienSudoku(nextRow, nextCol)) {
          return true;
        }

        // Nếu điền ô tiếp theo thất bại, backtrack
        bangSudoku[row][col] = 0;
      }
    }

    // Không tìm thấy số hợp lệ cho ô này, backtrack
    return false;
  }

  bool _hopLe(int row, int col, int num) {
    //kiểm tra số đã tồn tại trong hàng, cột
    for (int i = 0; i < 9; i++) {
      if (bangSudoku[row][i] == num || bangSudoku[i][col] == num) {
        return false;
      }
    }

    //kiểm tra số đã tồn tại trong bảng 3x3
    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;
    for (int i = startRow; i < startRow + 3; i++) {
      for (int j = startCol; j < startCol + 3; j++) {
        if (bangSudoku[i][j] == num) {
          return false;
        }
      }
    }

    return true;
  }

  void _maTranNgauNhien() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        bangSudoku[i][j] = 0;
      }
    }

    // tạo bảng hợp lệ
    if (_NgauNhienSudoku(0, 0)) {
      // Cập nhật giao diện
      setState(() {});
    } else {
      // Xử lý trường hợp không tìm thấy
      print("không thể tạo nguẫ nhiên");
    }
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
