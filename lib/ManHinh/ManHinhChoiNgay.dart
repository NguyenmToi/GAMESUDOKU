import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ManHinhChoiNgay extends StatefulWidget {
  const ManHinhChoiNgay(
      {Key? key,
      required this.soOAn,
      required this.tenMucDo,
      required this.ngauNhien})
      : super(key: key);
  final String tenMucDo;
  final int soOAn;
  final bool ngauNhien;

  @override
  State<ManHinhChoiNgay> createState() => _ManHinhChoiNgayState();
}

class _ManHinhChoiNgayState extends State<ManHinhChoiNgay> {
  int giay = 0; // Biến lưu trữ thời gian đã trôi qua
  late Timer thoiGian; // Đối tượng Timer để đếm thời gian
  int? hangDuocChon; // Chỉ số hàng được chọn
  int? cotDuocChon; // Chỉ số cột được chọn
  int loiSai = 5;
  bool ttghichu = false;

  // Khởi tạo bảng Sudoku
  List<List<int>> bangSudoku =
      List.generate(9, (_) => List.generate(9, (_) => 0));
  List<List<bool>> oKhoiTao =
      List.generate(9, (_) => List.generate(9, (_) => false));
  List<List<int>> mangTam = List.generate(9, (_) => List.generate(9, (_) => 0));
  List<List<Set<int>>> ghiChu = List.generate(9,
      (_) => List.generate(9, (_) => <int>{})); // Danh sách ghi chú cho mỗi ô

  @override
  void initState() {
    super.initState();
    batDauThoiGian(); // Bắt đầu đếm thời gian
    // Kiểm tra và thực hiện xóa ô Sudoku ngẫu nhiên nếu widget.ngauNhien là true
    if (widget.ngauNhien) {
      xoaOSudokuNgauNhien();
    } else {
      xoaOSudoku();
    }
  }

  void batDauThoiGian() {
    const oneSecond = Duration(seconds: 1);
    thoiGian = Timer.periodic(oneSecond, (Timer thoiGian) {
      setState(() {
        giay++;
      });
    });
  }

  Future<void> _rungDienThoai() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator != null && hasVibrator) {
      Vibration.vibrate(duration: 400);
    }
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
        int hang = hangDuocChon!;
        int cot = cotDuocChon!;
        if (so >= 1 && so <= 9) {
          if (ttghichu) {
            if (ghiChu[hang][cot].contains(so)) {
              ghiChu[hang][cot].remove(so);
            } else {
              ghiChu[hang][cot].add(so);
            }
          } else {
            if (KiemTraHopLe(hang, cot, so)) {
              bangSudoku[hang][cot] = so;
              ghiChu[hang][cot].clear();
              mangTam[hang][cot] = 0;
              oKhoiTao[hang][cot] = true;

              hangDuocChon = null;
              cotDuocChon = null;

              if (kiemTraBangDayDu()) {
                xuLyHoanThanhTroChoi();
                thayDoiTrangThaiBang();
              }
            } else {
              loiSai--;

              _rungDienThoai();
              kiemTraLoiSai(); // thong bao ket thuc
            }
          }
        }
      });
    }
  }

  void thayDoiTrangThaiBang() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          oKhoiTao[i][j] = false;
        }
      }
    });
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
    // Kiểm tra nếu tất cả các giá trị trong mangTam đều bằng 0
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (mangTam[i][j] != 0) {
          return false;
        }
      }
    }
    return true;
  }

  void dungThoiGian() {
    if (thoiGian != null) {
      thoiGian!.cancel();
    }
  }

  void xuLyHoanThanhTroChoi() {
    dungThoiGian();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chúc mừng!'),
          content: Text('Giải thành công câu đố Sudoku'),
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

  void xuLyThuaTroChoi() {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Không cho phép đóng hộp thoại bằng cách nhấn bên ngoài
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo!'),
          content: Text('Bạn đã thua, bạn muốn bắt đầu ván mới?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Quay lại màn hình trước đó
              },
              child: Text('Thoát'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame(); // Hàm để reset màn hình lại
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      // Khởi tạo lại bảng Sudoku
      bangSudoku = List.generate(9, (_) => List.generate(9, (_) => 0));
      oKhoiTao = List.generate(9, (_) => List.generate(9, (_) => false));
      mangTam = List.generate(9, (_) => List.generate(9, (_) => 0));
      // Đặt lại các biến trạng thái
      hangDuocChon = null;
      cotDuocChon = null;
      loiSai = 5;
      giay = 0;
      // Kiểm tra và thực hiện xóa ô Sudoku ngẫu nhiên nếu widget.ngauNhien là true
      if (widget.ngauNhien) {
        xoaOSudokuNgauNhien();
      } else {
        xoaOSudoku();
      }
      // Khởi động lại bộ đếm thời gian
      thoiGian.cancel();
      batDauThoiGian();
    });
  }

  void kiemTraLoiSai() {
    if (loiSai <= 0) {
      xuLyThuaTroChoi();
    }
  }

  void xoaOChon() {
    if (hangDuocChon != null && cotDuocChon != null) {
      setState(() {
        bangSudoku[hangDuocChon!][cotDuocChon!] = 0;
        mangTam[hangDuocChon!][cotDuocChon!] = 0;
      });
    }
  }

  void ThayDoiTrangThaiGhiChu() {
    setState(() {
      ttghichu = !ttghichu;
    });
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Mức độ: ${widget.tenMucDo}',
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
                          Icons.error,
                          color: Colors.red,
                          size: 25,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '$loiSai',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(width: 1),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 30,
                      ),
                      onPressed: () {
                        xoaOChon();
                      },
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.timer,
                          color: Colors.black,
                          size: 25,
                        ),
                        SizedBox(width: 5),
                        Text(
                          dinhDang(giay),
                          style: TextStyle(color: Colors.black, fontSize: 20),
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
                      // Kiểm tra các giá trị không null trước khi sử dụng
                      bool duocChon = hang == (hangDuocChon ?? -1) &&
                          cot ==
                              (cotDuocChon ??
                                  -1); // Kiểm tra ô có được chọn không
                      bool laKhoiTao = oKhoiTao[hang]
                          [cot]; // Kiểm tra ô có phải là ô khởi tạo không
                      //bool daDien = bangSudoku[hang][cot] != 0; // Kiểm tra ô đã có số hay chưa
                      bool coLoi = mangTam[hang][cot] == -1;
                      // Kiểm tra ô có nằm trong cùng hàng, cột hoặc vùng 3x3 với ô được chọn không
                      bool cungHang = hang == (hangDuocChon ?? -1);
                      bool cungCot = cot == (cotDuocChon ?? -1);
                      bool cungVung3x3 =
                          (hang ~/ 3 == (hangDuocChon ?? -1) ~/ 3) &&
                              (cot ~/ 3 == (cotDuocChon ?? -1) ~/ 3);

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
                      // Chọn màu chữ dựa trên giá trị trong oKhoiTao và mangTam
                      Color mauChu = coLoi
                          ? Color.fromARGB(255, 183, 183, 183)
                          : (laKhoiTao ? Colors.blue : Colors.black);
                      // Chọn màu nền cho ô
                      Color? mauNen =
                          Colors.white; // Đặt màu nền mặc định là màu trắng

                      if (duocChon) {
                        mauNen = Colors.blue[
                            100]; // Sử dụng màu hợp lệ cho ô không phải khởi tạo
                      } else if ((hangDuocChon != null &&
                              cotDuocChon != null) &&
                          (cungHang || cungCot || cungVung3x3)) {
                        mauNen = Colors.blue[
                            50]; // Sử dụng màu hợp lệ cho ô không phải khởi tạo
                      }

                      // Đảm bảo rằng ô được chọn và không phải là ô khởi tạo sẽ làm cho tất cả các ô cùng hàng, cột, hoặc vùng 3x3 có màu trắng
                      if (duocChon && !laKhoiTao) {
                        mauNen = Colors.white;
                      }
                      return InkWell(
                        onTap: () => xuLyOChon(
                            hang, cot), // Gọi hàm xử lý khi ô được chọn
                        child: Container(
                          decoration: BoxDecoration(
                            color: mauNen, // Đặt màu nền cho ô
                            border: border, // Đặt đường viền cho ô
                          ),
                          child: Center(
                            child: bangSudoku[hang][cot] != 0
                                ? Text(
                                    bangSudoku[hang][cot].toString(),
                                    style: TextStyle(
                                      fontSize: 24,
                                      color:
                                          mauChu, // Sử dụng màu chữ được chọn
                                    ),
                                  )
                                : GridView.count(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 1,
                                    crossAxisSpacing: 1,
                                    children: List.generate(9, (index) {
                                      int so = index + 1;
                                      return Center(
                                        child: ghiChu[hang][cot].contains(so)
                                            ? Text(
                                                so.toString(),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors
                                                      .black, // Màu ghi chú
                                                ),
                                                textAlign: TextAlign.center,
                                              )
                                            : Container(),
                                      );
                                    }),
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
                              ThayDoiTrangThaiGhiChu();
                            },
                            child: Icon(
                              Icons.note_alt_outlined,
                              color: ttghichu ? Colors.blue : Colors.black,
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

  void xoaOSudokuNgauNhien() {
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
    for (int i = 0; i < widget.soOAn; i++) {
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

  void xoaOSudoku() {
    dienSudokuNgauNhien(0, 0);
    // Khởi tạo danh sách vị trí đã điền
    List<int> viTriDaDien = List.generate(81, (index) => index);
    viTriDaDien.shuffle();
    // Số ô cần ẩn và số ẩn tối thiểu trong mỗi khối
    int soOAn = widget.soOAn;
    int soOAnToiThieuMoiKhoi = soOAn ~/ 9;
    int soOAnDu = soOAn % 9;

    // Tạo danh sách số ô ẩn cần thiết cho mỗi khối
    List<int> soOAnTrongMoiKhoi =
        List.generate(9, (index) => soOAnToiThieuMoiKhoi);

    // Phân bố ngẫu nhiên số dư vào các khối
    List<int> khongGian = List.generate(9, (index) => index);
    khongGian.shuffle();
    for (int i = 0; i < soOAnDu; i++) {
      soOAnTrongMoiKhoi[khongGian[i]]++;
    }

    // Lặp qua các vị trí đã điền và ẩn số
    for (int i = 0; i < viTriDaDien.length && soOAn > 0; i++) {
      int index = viTriDaDien[i];
      int hang = index ~/ 9;
      int cot = index % 9;
      int khoi = (hang ~/ 3) * 3 + (cot ~/ 3);

      // Ẩn số nếu ô đã có giá trị
      if (bangSudoku[hang][cot] != 0) {
        // Đảm bảo mỗi khối có đủ số ô ẩn
        if (soOAnTrongMoiKhoi[khoi] > 0) {
          bangSudoku[hang][cot] = 0;
          oKhoiTao[hang][cot] = true;
          soOAn--;
          soOAnTrongMoiKhoi[khoi]--;
        }
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
