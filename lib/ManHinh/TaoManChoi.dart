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
  bool _thongbaokiemtra = false;
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

//kiểm tra màn chơi đã tồn tại chưa
  Future<bool> kiemTraManChoi(String maman) async {
    DatabaseEvent event = await FirebaseDatabase.instance
        .reference()
        .child('thuthach')
        .orderByKey()
        .equalTo(maman)
        .once();

    DataSnapshot snapshot = event.snapshot;

    return snapshot.value != null;
  }

// kiểm tra và thực hiện thêm màn chơi
  void themManChoiLenFireBase() async {
    String maman = 'man${_tenManChoiController.text.toString()}';
    bangChoiSudoku = bangSudoku;
    bool tontai = await kiemTraManChoi(maman);
    if (tontai) {
      loiManChoiDaTonTai();
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
      dienDayDuThongTin();
      return;
    }
    int thoigian = int.parse(_thoiGianController.text.toString());
    int goiy = int.parse(_soGoiYController.text.toString());
    int soloi = int.parse(_soLoiController.text.toString());
    int soman = int.parse(_tenManChoiController.text.toString());
    if (thoigian < 1 || thoigian >= 3600) {
      loiThoiGian();
      return;
    } else if (goiy > 81) {
      loiGoiY();
      return;
    } else if (soloi > 729) {
      loiSoLoi();
      return;
    } else if (soman == 0) {
      loiMan0();
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
      thongBaoThemManChoiThanhCong();
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

    lamMoiBangSuDoKu();
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
          padding: const EdgeInsets.all(7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Màn chơi:',
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
                        padding: const EdgeInsets.symmetric(
                            horizontal:
                                10), //khoảng cách điền so với bên trái của ô
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ], // chỉ cho phép số
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
                  const SizedBox(width: 25),
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
                        if (kiemTraBangSudoku(bangSudoku) == true &&
                            kiemTraBangRong(bangSudoku) == false) {
                          giaiSudoku();
                        } else {
                          thongBaoBangKhongHopLe();
                        }
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
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                        onPressed: () {
                          if (kiemTraBangSudoku(bangSudoku) == true &&
                              kiemTraBangRong(bangSudoku) == false) {
                            thongBaoBangHopLe();
                          } else {
                            thongBaoBangKhongHopLe();
                          }
                        },
                        color: Colors.black,
                        icon: const Icon(Icons.check_circle, size: 24.0)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.455,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 9,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    int hang = index ~/ 9;
                    int cot = index % 9;
                    bool daChon = hang == hangDuocChon && cot == cotDuocChon;

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
                          color: daChon ? Colors.blue[100] : null,
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
              const SizedBox(height: 20),
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
                      color: Colors.blue[100],
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
              const SizedBox(height: 25),
              Center(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (kiemTraBangSudoku(bangSudoku) == true &&
                          kiemTraBangRong(bangSudoku) == false) {
                        if (demSoLuongSo(bangSudoku) >= 17) {
                          themManChoiLenFireBase();
                        } else {
                          thongBaoBangKhongDuSo();
                        }
                      } else {
                        thongBaoBangKhongHopLe();
                      }
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
    _soGoiYController.text = '';
    _soLoiController.text = '';
    _tenManChoiController.text = '';
    _thoiGianController.text = '';
    setState(() {});
  }

  void lamMoiThongTinNutNhan() {
    _soGoiYController.text = '';
    _soLoiController.text = '';
    _tenManChoiController.text = '';
    _thoiGianController.text = '';
  }

  bool _ngauNhienSudoku(int hang, int cot) {
    if (hang == 9) {
      return true;
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

  int demSoLuongSo(List<List<int?>> bang) {
    int dem = 0;
    for (int i = 0; i < bang.length; i++) {
      for (int j = 0; j < bang[i].length; j++) {
        if (bang[i][j] != 0) {
          dem++;
        }
      }
    }
    return dem;
  }

  void thongBaoBangHopLe() {
    if (!_thongbaokiemtra) {
      _thongbaokiemtra = true;

      final snackbar = SnackBar(
        content: Text('Màn chơi hợp lệ'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackbar)
          .closed
          .then((reason) {
        _thongbaokiemtra = false;
      });
    }
  }

  void thongBaoBangKhongHopLe() {
    if (!_thongbaokiemtra) {
      _thongbaokiemtra = true;

      final snackbar = SnackBar(
        content: Text('Màn chơi không hợp lệ'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackbar)
          .closed
          .then((reason) {
        _thongbaokiemtra = false;
      });
    }
  }

  void thongBaoBangKhongDuSo() {
    if (!_thongbaokiemtra) {
      _thongbaokiemtra = true;

      final snackbar = SnackBar(
        content: Text('Bảng chơi phải có tối thiểu 17 số'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackbar)
          .closed
          .then((reason) {
        _thongbaokiemtra = false;
      });
    }
  }

  void dienDayDuThongTin() {
    if (!_thongbaokiemtra) {
      _thongbaokiemtra = true;

      final snackbar = SnackBar(
        content: Text('Vui lòng điền đầy đủ thông tin'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackbar)
          .closed
          .then((reason) {
        _thongbaokiemtra = false;
      });
    }
  }

  void loiThoiGian() {
    if (!_thongbaokiemtra) {
      _thongbaokiemtra = true;

      final snackbar = SnackBar(
        content:
            Text('Thời gian tối thiểu màn chơi là 1 giây, tối đa là 3599 giây'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackbar)
          .closed
          .then((reason) {
        _thongbaokiemtra = false;
      });
    }
  }

  void loiGoiY() {
    if (!_thongbaokiemtra) {
      _thongbaokiemtra = true;

      final snackbar = SnackBar(
        content: Text('Số gợi ý tối đa là 81'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackbar)
          .closed
          .then((reason) {
        _thongbaokiemtra = false;
      });
    }
  }

  void loiSoLoi() {
    if (!_thongbaokiemtra) {
      _thongbaokiemtra = true;

      final snackbar = SnackBar(
        content: Text('Số lỗi tối đa là 729'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackbar)
          .closed
          .then((reason) {
        _thongbaokiemtra = false;
      });
    }
  }

  void loiMan0() {
    if (!_thongbaokiemtra) {
      _thongbaokiemtra = true;

      final snackbar = SnackBar(
        content: Text('Màn chơi tối thiểu là 1'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackbar)
          .closed
          .then((reason) {
        _thongbaokiemtra = false;
      });
    }
  }

  void loiManChoiDaTonTai() {
    if (!_thongbaokiemtra) {
      _thongbaokiemtra = true;

      final snackbar = SnackBar(
        content: Text('Màn chơi đã tồn tại'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackbar)
          .closed
          .then((reason) {
        _thongbaokiemtra = false;
      });
    }
  }

  void thongBaoThemManChoiThanhCong() {
    if (!_thongbaokiemtra) {
      _thongbaokiemtra = true;

      final snackbar = SnackBar(
        content: Text('Đã thêm màn chơi thành công'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackbar)
          .closed
          .then((reason) {
        _thongbaokiemtra = false;
      });
    }
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
