import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/ChonManChoi.dart';
import 'package:sudoku/ManHinh/LichSuChoi.dart';
import 'package:sudoku/ManHinh/ManHinhChinh.dart';
import 'package:vibration/vibration.dart';

import '../MoHinh/xulydulieu.dart';

class ManHinhChoiThuThach extends StatefulWidget {
  ManHinhChoiThuThach(
      {super.key,
      required this.tenMan,
      required this.bang,
      required this.banggiai,
      required this.soloi,
      required this.goiy,
      required this.thoigian,
      required this.maman,
      required this.taikhoan,
      required this.matkhau,
      required this.mannguoichoi,
      required this.ttsovandachoi,
      required this.ttsovanthangkhongloi});
  late final List bang;
  final List banggiai;
  final String tenMan;
  final int soloi;
  final int thoigian;
  final int goiy;
  late int maman;
  final taikhoan;
  final matkhau;
  late final mannguoichoi;
  late int ttsovandachoi;
  late final int ttsovanthangkhongloi;

  @override
  State<ManHinhChoiThuThach> createState() => _ManHinhChoiThuThachState();
}

class _ManHinhChoiThuThachState extends State<ManHinhChoiThuThach> {
  late int giay = widget.thoigian;
  late Timer thoiGian;
  late List<List<Color>> mauSo;
  late int soloi = widget.soloi;
  late int goiy = widget.goiy;
  int hangDuocChon = -1;
  int cotDuocChon = -1;
  bool _thongbaokiemtra = false;
  bool cheDoGhiChu = false;
  List<List<Set<int>>> ghiChuO =
      List.generate(9, (i) => List.generate(9, (j) => <int>{}));

  @override
  void initState() {
    super.initState();
    batDauThoiGian();

    mauSo = List.generate(
      widget.bang.length,
      (i) => List.generate(widget.bang[i].length, (j) => Colors.white),
    );
  }

  void batDauThoiGian() {
    const motGiay = Duration(seconds: 1);
    thoiGian = Timer.periodic(motGiay, (Timer thoiGian) {
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

  String dinhDangThoiGian(int thoiGian) {
    // int gio = thoiGian ~/ 3600;
    //${gio.toString().padLeft(2, '0')}:
    int phut = (thoiGian % 3600) ~/ 60;
    int giay = thoiGian % 60;
    return '${phut.toString().padLeft(2, '0')}:${giay.toString().padLeft(2, '0')}';
  }

  void xuLyChonO(int hang, int cot) {
    setState(() {
      hangDuocChon = hang;
      cotDuocChon = cot;

      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          if (i == hang ||
              j == cot ||
              (i ~/ 3 == hang ~/ 3 && j ~/ 3 == cot ~/ 3)) {
            mauSo[i][j] = Colors.blue[50]!;
          } else {
            mauSo[i][j] = Colors.white;
          }
        }
      }

      mauSo[hang][cot] = Colors.blue[100]!;
    });
  }

  void doiTrangThaiGhiChu() {
    setState(() {
      cheDoGhiChu = !cheDoGhiChu;
    });
  }

  void xuLyNhapSo(int so) async {
    if (hangDuocChon != -1 && cotDuocChon != -1) {
      widget.bang[hangDuocChon][cotDuocChon] = so;

      if (so == widget.banggiai[hangDuocChon][cotDuocChon]) {
        thongBaoNhapDung();
        setState(() {
          mauSo[hangDuocChon][cotDuocChon] = Colors.green;
        });
      } else {
        await _rungDienThoai();

        setState(() {
          mauSo[hangDuocChon][cotDuocChon] = Colors.red;

          if (soloi == 0) {
            thongBaoThua();
          } else {
            soloi -= 1;
          }

          widget.bang[hangDuocChon][cotDuocChon] = 0;
        });
      }
      setState(() {
        kiemTraBangHoanThanh();
      });
    }
  }

  Future<void> _rungDienThoai() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator != null && hasVibrator) {
      Vibration.vibrate(duration: 400);
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
                  widget.tenMan,
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 40, 5, 90),
        child: Column(
          children: [
            Text(
              'SUDOKU',
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.error,
                      size: 20,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 5),
                    Text(soloi.toString(),
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
                Row(
                  children: [
              
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      child: IconButton(
                        onPressed: () {
                          if (goiy == 0) {
                            setState(() {
                              thongBaoHetGoiY();
                            });
                          } else if (widget.bang[hangDuocChon][cotDuocChon] ==
                              widget.banggiai[hangDuocChon][cotDuocChon]) {
                            return;
                          } else {
                            widget.bang[hangDuocChon][cotDuocChon] =
                                widget.banggiai[hangDuocChon][cotDuocChon];
                            goiy -= 1;
                            kiemTraBangHoanThanh();
                          }
                        },
                        color: Colors.black,
                        icon: const Icon(Icons.lightbulb_outline_sharp),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(goiy.toString(), style: const TextStyle(fontSize: 20)),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      dinhDangThoiGian(giay),
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                )
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  int hang = index ~/ 9;
                  int cot = index % 9;
                  bool duocChon = hang == hangDuocChon && cot == cotDuocChon;

                  Border border = Border(
                    top: BorderSide(
                      color: hang == 0
                          ? Colors.black
                          : (hang % 3 == 0)
                              ? Colors.black
                              : Colors.grey,
                      width: hang == 0 ? 1 : 1,
                    ),
                    left: BorderSide(
                      color: cot == 0
                          ? Colors.black
                          : (cot % 3 == 0)
                              ? Colors.black
                              : Colors.grey,
                      width: cot == 0 ? 1 : 1,
                    ),
                    bottom: BorderSide(
                      color: hang == 8
                          ? Colors.black
                          : ((hang + 1) % 3 == 0)
                              ? Colors.black
                              : Colors.grey,
                      width: hang == 8 ? 1 : 1,
                    ),
                    right: BorderSide(
                      color: cot == 8
                          ? Colors.black
                          : ((cot + 1) % 3 == 0)
                              ? Colors.black
                              : Colors.grey,
                      width: cot == 8 ? 1 : 1,
                    ),
                  );
                  return InkWell(
                    onTap: () {
                      if (widget.bang != null &&
                          hang < widget.bang.length &&
                          widget.bang[hang] != null &&
                          cot < widget.bang[hang].length &&
                          widget.bang[hang][cot] == 0) {
                        xuLyChonO(hang, cot);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: duocChon ? Colors.blue[100] : mauSo[hang][cot],
                        border: border,
                      ),
                      child: Center(
                        child: widget.bang != null &&
                                hang < widget.bang.length &&
                                widget.bang[hang] != null &&
                                cot < widget.bang[hang].length &&
                                widget.bang[hang][cot] != 0
                            ? Text(
                                widget.bang[hang][cot].toString(),
                                style: const TextStyle(
                                  fontSize: 24,
                                ),
                              )
                            : xayDungOGhiChu(hang, cot),
                      ),
                    ),
                  );
                },
                itemCount: 81,
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 1; i <= 5; i++) xayDungSo(i),
                  ],
                ),
                const SizedBox(
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
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        child: IconButton(
                          onPressed: doiTrangThaiGhiChu,
                          color: cheDoGhiChu ? Colors.blue : Colors.black,
                          icon: const Icon(Icons.note_alt_outlined),
                        ),
                      ),
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
              onPressed: () async {
                ctaiKhoan? ttTaiKhoan =
                    await ctaiKhoan.thongTinDangNhap(widget.taikhoan);

                setState(() {
                  if (ttTaiKhoan != null) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManHinhChinh(
                                ttTaiKhoan: ttTaiKhoan,
                              )),
                      (Route<dynamic> route) => false,
                    );
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChonManChoi(
                              man: widget.maman,
                              taikhoan: widget.taikhoan,
                              matkhau: widget.matkhau,
                              ttsovandachoi: ttTaiKhoan!.ttsovandachoi,
                              ttsovanthangkhongloi:
                                  ttTaiKhoan.mdsovanthangkhongloi,
                            )),
                  );
                });
              },
            ),
            TextButton(
              child: const Text('Đồng ý'),
              onPressed: () async {
                ctaiKhoan? ttTaiKhoan =
                    await ctaiKhoan.thongTinDangNhap(widget.taikhoan);
                List<List<int>>? bang =
                    await cManThuThach.layDuLieuBang(widget.maman);
                // suawr lay thang
                int sovan = ttTaiKhoan!.ttsovandachoi += 1;
                ctaiKhoan.capNhatThongKeTTSoVanChoi(widget.taikhoan, sovan);
                setState(() {
                  if (ttTaiKhoan != null) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManHinhChinh(
                                ttTaiKhoan: ttTaiKhoan,
                              )),
                      (Route<dynamic> route) => false,
                    );
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChonManChoi(
                              man: widget.maman,
                              taikhoan: widget.taikhoan,
                              matkhau: widget.matkhau,
                              ttsovandachoi: ttTaiKhoan!.ttsovandachoi,
                              ttsovanthangkhongloi:
                                  ttTaiKhoan.mdsovanthangkhongloi,
                            )),
                  );

                  if (bang != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManHinhChoiThuThach(
                          tenMan: widget.tenMan,
                          bang: bang,
                          soloi: widget.soloi,
                          goiy: widget.goiy,
                          thoigian: widget.thoigian,
                          banggiai: widget.banggiai,
                          maman: widget.maman,
                          taikhoan: widget.taikhoan,
                          matkhau: widget.matkhau,
                          mannguoichoi: widget.mannguoichoi,
                          ttsovandachoi: widget.ttsovandachoi,
                          ttsovanthangkhongloi: widget.ttsovanthangkhongloi,
                        ),
                      ),
                    );
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget xayDungOGhiChu(int hang, int cot) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      children: List.generate(9, (index) {
        int so = index + 1;

        return Center(
          child: ghiChuO[hang][cot].contains(so)
              ? Text(
                  so.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                )
              : Container(),
        );
      }),
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
              onPressed: () async {
                ctaiKhoan? ttTaiKhoan =
                    await ctaiKhoan.thongTinDangNhap(widget.taikhoan);
                setState(() {
                  if (ttTaiKhoan != null) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManHinhChinh(
                                ttTaiKhoan: ttTaiKhoan,
                              )),
                      (Route<dynamic> route) => false,
                    );
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChonManChoi(
                              man: widget.mannguoichoi,
                              taikhoan: widget.taikhoan,
                              matkhau: widget.matkhau,
                              ttsovandachoi: ttTaiKhoan!.ttsovandachoi,
                              ttsovanthangkhongloi:
                                  ttTaiKhoan.mdsovanthangkhongloi,
                            )),
                  );
                });
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

  void thongBaoHetGoiY() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Hết gợi ý',
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          content: const Text('Bạn đã hết gợi ý'),
          actions: <Widget>[
            TextButton(
              child: const Text('Đồng ý'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget xayDungSo(int so) {
    bool daChon = hangDuocChon >= 0 &&
        hangDuocChon < 9 &&
        cotDuocChon >= 0 &&
        cotDuocChon < 9;
    bool coSoGhiChu =
        daChon ? ghiChuO[hangDuocChon][cotDuocChon].contains(so) : false;

    return Ink(
      height: 45,
      width: 60,
      decoration: BoxDecoration(
        color: cheDoGhiChu
            ? coSoGhiChu
                ? Colors.blue[100]
                : Colors.blue[50]
            : Colors.blue[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          setState(() {
            if (cheDoGhiChu) {
              if (ghiChuO[hangDuocChon][cotDuocChon].contains(so)) {
                ghiChuO[hangDuocChon][cotDuocChon].remove(so);
              } else {
                ghiChuO[hangDuocChon][cotDuocChon].add(so);
              }
            } else {
              widget.bang[hangDuocChon][cotDuocChon] = so;
              ghiChuO[hangDuocChon][cotDuocChon].clear();
              xuLyNhapSo(so);
            }
          });
        },
        child: Container(
          width: 60,
          height: 45,
          alignment: Alignment.center,
          child: Text(
            so.toString(),
            style: TextStyle(
                color: cheDoGhiChu
                    ? coSoGhiChu
                        ? Colors.black
                        : Colors.grey
                    : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void thongBaoNhapDung() {
    if (!_thongbaokiemtra) {
      _thongbaokiemtra = true;

      final snackbar = SnackBar(
        content: Text('Đúng'),
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

  void kiemTraBangHoanThanh() {
    bool bangHoanThanh = true;
    for (int i = 0; i < widget.bang.length; i++) {
      for (int j = 0; j < widget.bang[i].length; j++) {
        if (widget.bang[i][j] == 0) {
          bangHoanThanh = false;
          break;
        }
      }
      if (!bangHoanThanh) {
        break;
      }
    }
    if (bangHoanThanh) {
      if (widget.maman == widget.mannguoichoi) {
        widget.mannguoichoi += 1;

        final databaseReference = FirebaseDatabase.instance.reference();
        databaseReference
            .child('taikhoan')
            .child(widget.taikhoan)
            .update({'man': widget.mannguoichoi});
      }

      if (widget.maman != null) {
        Future<int?> soloiman = cManThuThach.layThongTinSoLoi(widget.maman);
        if (widget.soloi == soloiman) {
          int sovan = widget.ttsovanthangkhongloi += 1;
          ctaiKhoan.capNhatThongKeTTThangKhongLoi(widget.taikhoan, sovan);
        }
      }

      thoiGian.cancel();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.yellow),
                SizedBox(width: 8),
                Text(
                  'HOÀN THÀNH',
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 8),
                Icon(Icons.star, color: Colors.yellow),
              ],
            ),
            content: const Text(
              'Chúc mừng bạn đã hoàn thành màn chơi !\n\n'
              'Khám phá màn chơi mới được mở khóa nào',
              style: TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Đóng'),
                onPressed: () async {
                  ctaiKhoan? ttTaiKhoan =
                      await ctaiKhoan.thongTinDangNhap(widget.taikhoan);

                  setState(() {
                    if (ttTaiKhoan != null) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManHinhChinh(
                                  ttTaiKhoan: ttTaiKhoan,
                                )),
                        (Route<dynamic> route) => false,
                      );
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChonManChoi(
                                man: widget.mannguoichoi,
                                taikhoan: widget.taikhoan,
                                matkhau: widget.matkhau,
                                ttsovandachoi: ttTaiKhoan!.ttsovandachoi,
                                ttsovanthangkhongloi:
                                    ttTaiKhoan.mdsovanthangkhongloi,
                              )),
                    );
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }
}
