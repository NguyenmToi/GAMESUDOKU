import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudoku/ManHinh/ManHinhChinh.dart';
import 'package:sudoku/ManHinh/ManHinhChoiMucDo.dart';
import 'package:sudoku/ManHinh/QuanLyManChoi.dart';
import 'package:sudoku/ThanhPhan/QuanLyThuThach.dart';

import '../MoHinh/xulydulieu.dart';

class TaoManChoi extends StatefulWidget {
  const TaoManChoi({super.key});

  @override
  State<TaoManChoi> createState() => _TaoManChoiState();
}

class _TaoManChoiState extends State<TaoManChoi> {
  int? hangDuocChon;
  int? cotDuocChon;
  final TextEditingController _tenManChoiController = TextEditingController();
  final TextEditingController _thoiGianController = TextEditingController();
  final TextEditingController _soGoiYController = TextEditingController();
  final TextEditingController _soLoiController = TextEditingController();
  List<List<int>> bangSudoku =
      List.generate(9, (_) => List.generate(9, (_) => 0));
  List<List<int>> bangChoiSudoku =
      List.generate(9, (_) => List.generate(9, (_) => 0));
  List<List<int>> bangLoiGiaiSudoku =
      List.generate(9, (_) => List.generate(9, (_) => 0));

  void giaiSudoku() {
    GiaiSudoku sdk = GiaiSudoku(bangSudoku);
    if (sdk.giai()) {
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không thể giải bảng Sudoku")),
      );
    }
  }

// kiểm tra và thực hiện thêm màn chơi
  void themManChoiLenFireBase() async {
    String maman = 'man${_tenManChoiController.text.toString()}';
    bangChoiSudoku = bangSudoku;
    bool exists = await kiemTraManChoi(maman);
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tên màn chơi đã tồn tại")),
      );
    } else {
      themManChoi();
    }
  }

//hàm thêm màn chơi
  final databaseReference = FirebaseDatabase.instance.reference();
  Future<void> themManChoi() async {
    if (_tenManChoiController.text.isEmpty ||
        _soGoiYController.text.isEmpty ||
        _soLoiController.text.isEmpty ||
        _thoiGianController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin'),
        ),
      );
      return;
    }
    databaseReference
        .child('thuthach')
        .child('man${_tenManChoiController.text.toString()}')
        .set({
      'bang': bangChoiSudoku,
      'maman': int.parse(_tenManChoiController.text.toString()),
      'tenman': 'Màn ${_tenManChoiController.text.toString()}',
      'thoigian': int.parse(_thoiGianController.text.toString()),
      'soloi': int.parse(_soLoiController.text.toString()),
      'sogoiy': int.parse(_soGoiYController.text.toString()),
      'trangthai': true,
      'thoigiantao': DateTime.now().toString(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã thêm màn chơi thành công'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi thêm màn chơi: $error'),
        ),
      );
    });

    giaiSudoku();
    bangLoiGiaiSudoku = bangSudoku;
    databaseReference
        .child('thuthach')
        .child('man${_tenManChoiController.text.toString()}')
        .update({'banggiai': bangLoiGiaiSudoku});
  }

  @override
  Widget build(BuildContext context) {
    // cố định màn hình ứng dụng ở chế độ dọc
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[200],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context);

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const QuanLyManChoi(),
            //   ),
            // );
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 3, 5, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Tên màn chơi:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: _tenManChoiController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Số lỗi:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: _soLoiController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Thời gian:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: _thoiGianController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Số gợi ý:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: _soGoiYController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                        giaiSudoku();
                      },
                      child: const Text(
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
                      child: const Text(
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
                        xoaODangChon();
                      },
                      color: Colors.black,
                      icon: const Icon(Icons.visibility_off),
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
                      icon: const Icon(Icons.visibility),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.46,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 9,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    int hang = index ~/ 9;
                    int cot = index % 9;
                    bool isSelected =
                        hang == hangDuocChon && cot == cotDuocChon;

                    Border border = Border(
                      top: BorderSide(
                        color: hang == 0
                            ? Colors.black
                            : (hang % 3 == 0)
                                ? Colors.black
                                : Colors.grey,
                        width: hang == 0 ? 1.0 : 1.0,
                      ),
                      left: BorderSide(
                        color: cot == 0
                            ? Colors.black
                            : (cot % 3 == 0)
                                ? Colors.black
                                : Colors.grey,
                        width: cot == 0 ? 1.0 : 1.0,
                      ),
                      bottom: BorderSide(
                        color: hang == 8
                            ? Colors.black
                            : ((hang + 1) % 3 == 0)
                                ? Colors.black
                                : Colors.grey,
                        width: hang == 8 ? 1.0 : 1.0,
                      ),
                      right: BorderSide(
                        color: cot == 8
                            ? Colors.black
                            : ((cot + 1) % 3 == 0)
                                ? Colors.black
                                : Colors.grey,
                        width: cot == 8 ? 1.0 : 1.0,
                      ),
                    );

                    return InkWell(
                      onTap: () => xuLyNhan(hang, cot),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue[100] : null,
                          border: border,
                        ),
                        child: Center(
                          child: Text(
                            bangSudoku[hang][cot] == 0
                                ? ''
                                : bangSudoku[hang][cot].toString(),
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 1; i <= 5; i++) xayDungSo(i),
                ],
              ),
              const SizedBox(height: 10),
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
                        onPressed: () {
                          lamMoiBangSuDoKu();
                        },
                        color: Colors.black,
                        icon: const Icon(Icons.rotate_left),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Center(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    onPressed: () {
                      themManChoiLenFireBase();
                      lamMoiBangSuDoKu();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Thêm màn chơi',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void xyLyNhanSo(int so) {
    if (hangDuocChon != null && cotDuocChon != null) {
      setState(() {
        bangSudoku[hangDuocChon!][cotDuocChon!] = so;
        hangDuocChon = null;
        cotDuocChon = null;
      });
    }
  }

  void xuLyNhan(int hang, int cot) {
    setState(() {
      hangDuocChon = hang;
      cotDuocChon = cot;
    });
  }

  void xoaODangChon() {
    if (hangDuocChon != null && cotDuocChon != null) {
      setState(() {
        bangSudoku[hangDuocChon!][cotDuocChon!] = 0;
      });
    }
  }

  void lamMoiBangSuDoKu() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        bangSudoku[i][j] = 0;
      }
    }
    setState(() {});
  }

  bool _ngauNhienSudoku(int hang, int cot) {
    if (hang == 9) {
      return true; // Đã điền đầy đủ Sudoku thành công
    }

    // Tính toán hàng và cột tiếp theo
    int hangtieptheo = (cot == 8) ? (hang + 1) : hang;
    int cottieptheo = (cot + 1) % 9;

    // Xáo trộn các số từ 1 đến 9 để ngẫu nhiên hóa quá trình sinh ra Sudoku
    List<int> dsso = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    dsso.shuffle();

    // Thử điền ô hàng,cột từng số
    for (int so in dsso) {
      if (_hopLe(hang, cot, so)) {
        // Đặt số nếu số đó hợp lệ
        bangSudoku[hang][cot] = so;

        // Điền đệ quy ô tiếp theo
        if (_ngauNhienSudoku(hangtieptheo, cottieptheo)) {
          return true;
        }

        // Nếu điền ô tiếp theo thất bại, backtrack
        bangSudoku[hang][cot] = 0;
      }
    }

    // Không tìm thấy số hợp lệ cho ô này, backtrack
    return false;
  }

  bool _hopLe(int hang, int cot, int so) {
    //kiểm tra số đã tồn tại trong hàng, cột
    for (int i = 0; i < 9; i++) {
      if (bangSudoku[hang][i] == so || bangSudoku[i][cot] == so) {
        return false;
      }
    }

    //kiểm tra số đã tồn tại trong bảng 3x3
    int dhang = (hang ~/ 3) * 3;
    int dcot = (cot ~/ 3) * 3;
    for (int i = dhang; i < dhang + 3; i++) {
      for (int j = dcot; j < dcot + 3; j++) {
        if (bangSudoku[i][j] == so) {
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
    if (_ngauNhienSudoku(0, 0)) {
      // Cập nhật giao diện
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể phát sinh ngẫu nhiên '),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Widget xayDungSo(int so) {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          xyLyNhanSo(so);
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
