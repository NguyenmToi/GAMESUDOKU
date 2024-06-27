import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Manhinhchoimucdo extends StatefulWidget {
  const Manhinhchoimucdo(
      {Key? key, required this.mucdo, required this.soan, required this.diem})
      : super(key: key);

  final String mucdo;
  final int soan;
  final int diem;

  @override
  State<Manhinhchoimucdo> createState() => _ManhinhchoimucdoState();
}

class _ManhinhchoimucdoState extends State<Manhinhchoimucdo> {
  int giay = 0; // Biến lưu trữ thời gian đã trôi qua
  late Timer thoiGian; // Đối tượng Timer để đếm thời gian
  int? hangDuocChon; // Chỉ số hàng được chọn
  int? cotDuocChon; // Chỉ số cột được chọn
  int loiSai = 0; // Biến đếm số lần lỗi

  // Khởi tạo bảng Sudoku
  List<List<int>> bangSudoku =
      List.generate(9, (_) => List.generate(9, (_) => 0));
  List<List<bool>> oKhoiTao =
      List.generate(9, (_) => List.generate(9, (_) => false));
  List<List<int>> mangTam = List.generate(
      9,
      (_) => List.generate(
          9, (_) => 0)); // Khai báo mảng tạm để lưu trữ các giá trị

  @override
  void initState() {
    super.initState();
    batDauThoiGian(); // Bắt đầu đếm thời gian
    xoaONgauNhien(); // Tạo bảng Sudoku ngẫu nhiên
  }

  void batDauThoiGian() {
    const oneSecond = Duration(seconds: 1);
    thoiGian = Timer.periodic(oneSecond, (Timer thoiGian) {
      setState(() {
        giay++;
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

  bool kiemtrasokhoitao = false;

  void xuLyOChon(int hang, int cot) {
    setState(() {
      if (oKhoiTao[hang][cot]) {
        // Chỉ cho phép chọn vào ô khởi tạo
        hangDuocChon = hang;
        cotDuocChon = cot;
      } else {
        hangDuocChon = null;
        cotDuocChon = null;
      }
    });
  }

  void xuLySoTap(int so) {
    if (hangDuocChon != null && cotDuocChon != null) {
      setState(() {
        if (oKhoiTao[hangDuocChon!][cotDuocChon!]) {
          // Chỉ cho phép điền vào ô khởi tạo
          if (so >= 1 && so <= 9) {
            if (NuocDiHopLe(hangDuocChon!, cotDuocChon!, so)) {
              // Lưu vị trí hàng và cột
              int hang = hangDuocChon!;
              int cot = cotDuocChon!;

              // Thực hiện thay đổi giá trị
              bangSudoku[hang][cot] = so;

              // Đánh dấu là số khởi tạo
              oKhoiTao[hang][cot] = true;

              hangDuocChon = null;
              cotDuocChon = null;

              // Xử lý khi bảng Sudoku đã được điền đầy đủ
              if (kiemTraBangDayDu()) {
                xuLyHoanThanhTroChoi();
              }
            } else {
              loiSai++; // Tăng số lỗi nếu điền sai vào ô khởi tạo
            }
          }
        }
      });
    }
  }

  void xoaOChon() {
    if (hangDuocChon != null && cotDuocChon != null) {
      setState(() {
        // Cho phép xóa cả ô khởi tạo
        bangSudoku[hangDuocChon!][cotDuocChon!] = 0;
        hangDuocChon = null;
        cotDuocChon = null;
      });
    }
  }

  bool NuocDiHopLe(int hang, int cot, int so) {
    // Kiểm tra nếu số đã tồn tại trong hàng hiện tại
    for (int i = 0; i < 9; i++) {
      if (bangSudoku[hang][i] == so) {
        return false;
      }
    }
    // Kiểm tra nếu số đã tồn tại trong cột hiện tại
    for (int i = 0; i < 9; i++) {
      if (bangSudoku[i][cot] == so) {
        return false;
      }
    }
    // Kiểm tra nếu số đã tồn tại trong lưới 3x3 hiện tại
    int batDauHang = (hang ~/ 3) * 3;
    int batDauCot = (cot ~/ 3) * 3;
    for (int i = batDauHang; i < batDauHang + 3; i++) {
      for (int j = batDauCot; j < batDauCot + 3; j++) {
        if (bangSudoku[i][j] == so) {
          return false;
        }
      }
    }

    return true; // Số hợp lệ trong vị trí này
  }

  bool kiemTraBangDayDu() {
    // Kiểm tra nếu tất cả các ô đã được điền đầy đủ (không có ô nào bằng 0)
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (bangSudoku[i][j] == 0) {
          return false;
        }
      }
    }
    return true;
  }

  void xuLyHoanThanhTroChoi() {
    // Thực hiện logic khi trò chơi hoàn thành
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chúc mừng!'),
          content: Text(
              'Giải thành công câu đố Sudoku bạn được cộng ${widget.diem} điểm'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
              thongBaoThoat();
            },
          )),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 60, 5, 60),
        child: Stack(
          children: [
            Column(
              children: [
                const Text(
                  'SUDOKU',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 189, 189, 189),
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Mức độ ${widget.mucdo}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.error, // Icon cho lỗi
                          color: Colors.red,
                          size: 24,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '$loiSai',
                          style:
                              const TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time, // Icon cho thời gian
                          color: Colors.black,
                          size: 24,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          dinhDang(giay),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 9, // 9 cột cho bảng Sudoku
                      childAspectRatio: 1, // Tỷ lệ chiều rộng và chiều cao là 1
                    ),
                    itemBuilder: (context, index) {
                      int hang = index ~/ 9; // Tính hàng từ chỉ số
                      int cot = index % 9; // Tính cột từ chỉ số
                      bool duocChon = hang == hangDuocChon &&
                          cot == cotDuocChon; // Kiểm tra ô có được chọn không
                      bool laKhoiTao = oKhoiTao[hang]
                          [cot]; // Kiểm tra ô có phải là ô khởi tạo không
                      bool daDien = bangSudoku[hang][cot] !=
                          0; // Kiểm tra ô đã có số hay chưa

                      // Tạo đường viền cho ô
                      Border border = Border(
                        top: BorderSide(
                          color: hang == 0
                              ? Colors.black
                              : (hang % 3 == 0)
                                  ? Colors.black
                                  : Colors.grey, // Đường viền trên
                          width: 1.0,
                        ),
                        left: BorderSide(
                          color: cot == 0
                              ? Colors.black
                              : (cot % 3 == 0)
                                  ? Colors.black
                                  : Colors.grey, // Đường viền trái
                          width: 1.0,
                        ),
                        bottom: BorderSide(
                          color: hang == 8
                              ? Colors.black
                              : ((hang + 1) % 3 == 0)
                                  ? Colors.black
                                  : Colors.grey, // Đường viền dưới
                          width: 1.0,
                        ),
                        right: BorderSide(
                          color: cot == 8
                              ? Colors.black
                              : ((cot + 1) % 3 == 0)
                                  ? Colors.black
                                  : Colors.grey, // Đường viền phải
                          width: 1.0,
                        ),
                      );

                      return InkWell(
                        onTap: () => xuLyOChon(
                            hang, cot), // Gọi hàm xử lý khi ô được chọn
                        child: Container(
                          decoration: BoxDecoration(
                            color: duocChon
                                ? Colors.blue[100]
                                : null, // Đổi màu nền khi ô được chọn
                            border: border, // Đặt đường viền cho ô
                          ),
                          child: Center(
                            child: Text(
                              daDien
                                  ? bangSudoku[hang][cot].toString()
                                  : '', // Hiển thị số trong ô nếu đã điền
                              style: TextStyle(
                                fontSize: 24,
                                color: laKhoiTao
                                    ? Colors.blue
                                    : Colors
                                        .black, // Màu sắc cho ô khởi tạo (xanh) và ô đã điền số (đen)
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: 81, // Tổng số ô trong bảng Sudoku
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 1; i <= 5; i++)
                          xayDungSo(i), // Tạo nút số từ 1 đến 5
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 6; i <= 9; i++)
                          xayDungSo(i), // Tạo nút số từ 6 đến 9
                        Ink(
                          height: 45,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              xoaOChon();
                            },
                            child: const Icon(
                              Icons.drive_file_rename_outline_rounded,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
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
          content: const Text(
            'Thoát sẽ hủy kết quả, bạn có muốn thoát không ?',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.normal),
          ),
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

  void xoaONgauNhien() {
    dienSudokuNgauNhien(0, 0); // Gọi ban đầu để điền bảng Sudoku

    // Lấy danh sách các vị trí đã điền số
    List<int> viTriDaDien = [];
    for (int i = 0; i < 81; i++) {
      if (bangSudoku[i ~/ 9][i % 9] != 0) {
        // Kiểm tra ô đã được điền số chưa
        viTriDaDien.add(i);
      }
    }
    viTriDaDien.shuffle();

    Random random = Random();
    for (int i = 0; i < widget.soan; i++) {
      // Số ô cần xóa
      int index = viTriDaDien[i];
      int hang = index ~/ 9;
      int cot = index % 9;
      if (!oKhoiTao[hang][cot]) {
        // Nếu ô không phải là ô khởi tạo
        bangSudoku[hang][cot] = 0; // Xóa ô này bằng cách gán giá trị về 0
        oKhoiTao[hang][cot] = true; // Đặt giá trị của ô khởi tạo thành true
      } else {
        i--; // Thử lại nếu ô đã được xóa
      }
    }
  }

  bool dienSudokuNgauNhien(int hang, int cot) {
    // Trường hợp cơ sở: Nếu đã điền đầy đủ tất cả các ô
    if (hang == 9) {
      return true; // Đã điền đầy đủ Sudoku
    }

    // Tính toán hàng và cột tiếp theo
    int hangTiepTheo = (cot == 8) ? (hang + 1) : hang;
    int cotTiepTheo = (cot + 1) % 9;

    // Xáo trộn các số từ 1 đến 9 để tạo ngẫu nhiên
    List<int> soNgauNhien = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    soNgauNhien.shuffle();

    // Thử điền số vào ô (hang, cot)
    for (int so in soNgauNhien) {
      if (KiemTraHopLe(hang, cot, so)) {
        // Đặt số nếu hợp lệ
        bangSudoku[hang][cot] = so;

        // Đệ quy để điền ô tiếp theo
        if (dienSudokuNgauNhien(hangTiepTheo, cotTiepTheo)) {
          return true;
        }

        // Quay lui nếu điền ô tiếp theo thất bại
        bangSudoku[hang][cot] = 0;
      }
    }

    // Không tìm thấy số hợp lệ cho ô này, quay lui
    return false;
  }

  bool KiemTraHopLe(int hang, int cot, int so) {
    // Kiểm tra nếu số đã tồn tại trong hàng hoặc cột hiện tại
    for (int i = 0; i < 9; i++) {
      if (bangSudoku[hang][i] == so || bangSudoku[i][cot] == so) {
        return false;
      }
    }

    // Kiểm tra nếu số đã tồn tại trong lưới 3x3 hiện tại
    int batDauHang = (hang ~/ 3) * 3;
    int batDauCot = (cot ~/ 3) * 3;
    for (int i = batDauHang; i < batDauHang + 3; i++) {
      for (int j = batDauCot; j < batDauCot + 3; j++) {
        if (bangSudoku[i][j] == so) {
          return false;
        }
      }
    }

    return true; // Số hợp lệ trong vị trí này
  }

  Widget xayDungSo(int so) {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          xuLySoTap(so);
        },
        child: Container(
          width: 60,
          height: 45,
          alignment: Alignment.center,
          child: Text(
            so.toString(),
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
