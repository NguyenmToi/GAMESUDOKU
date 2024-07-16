import 'package:flutter/material.dart';

import 'package:sudoku/ManHinh/ManHinhChoiThuThach.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

class ChonManChoi extends StatefulWidget {
  ChonManChoi({
    super.key,
    required this.man,
    required this.matkhau,
    required this.taikhoan,
    required this.ttsovandachoi,
    required this.ttsovanthangkhongloi,
    // required this.tttilemokhoamanmoi
  });
  final String taikhoan;
  final String matkhau;
  final int man;
  late int ttsovandachoi;
  final int ttsovanthangkhongloi;
  // final String tttilemokhoamanmoi;

  @override
  State<ChonManChoi> createState() => _ChonManCHoiState();
}

class _ChonManCHoiState extends State<ChonManChoi> {
  late Future<List<cManThuThach>> _dsManThuThach;
  bool _thongBao = false;

  @override
  void initState() {
    super.initState();
    _dsManThuThach = cManThuThach.taiDanhSachMan();
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

            //sua lai thanh load
          },
        ),
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(right: 40.0),
                child: Text(
                  "Chọn màn chơi",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(7, 10, 7, 5),
        child: FutureBuilder<List<cManThuThach>>(
          future: _dsManThuThach,
          builder: (BuildContext context,
              AsyncSnapshot<List<cManThuThach>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Không có dữ liệu màn chơi'));
            } else {
              List<cManThuThach> dsManThuThach = snapshot.data!;

              dsManThuThach.sort((a, b) => a.maman.compareTo(b.maman));

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.8, // tỉ lệ dài - rộng
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: dsManThuThach.length,
                itemBuilder: (BuildContext context, int index) {
                  cManThuThach manThuThach = dsManThuThach[index];
                  List bangc = dsManThuThach[index].bang;
                  List banggiaic = dsManThuThach[index].banggiai;
                  int goiyc = dsManThuThach[index].sogoiy;
                  int soloic = dsManThuThach[index].soloi;
                  int thoigianc = dsManThuThach[index].thoigian;
                  int maman = dsManThuThach[index].maman;

                  return GestureDetector(
                    onTap: () async {
                      ctaiKhoan? ttTaiKhoan =
                          await ctaiKhoan.thongTinDangNhap(widget.taikhoan);
                      if (ttTaiKhoan != null) {
                        int mannguoichoi = ttTaiKhoan.man;

                        if (mannguoichoi >= maman) {
                          int sovan = widget.ttsovandachoi += 1;
                          ctaiKhoan.capNhatThongKeTTSoVanChoi(
                              widget.taikhoan, sovan);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManHinhChoiThuThach(
                                tenMan: manThuThach.tenman,
                                bang: bangc,
                                soloi: soloic,
                                goiy: goiyc,
                                thoigian: thoigianc,
                                banggiai: banggiaic,
                                maman: maman,
                                taikhoan: widget.taikhoan,
                                matkhau: widget.matkhau,
                                mannguoichoi: widget.man,
                                ttsovandachoi: widget.ttsovandachoi,
                                ttsovanthangkhongloi:
                                    widget.ttsovanthangkhongloi,
                              ),
                            ),
                          );
                        } else {
                          thongBao(mannguoichoi);
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          ' ${manThuThach.tenman}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void thongBao(int man) {
    if (!_thongBao) {
      _thongBao = true;

      final snackbar = SnackBar(
        content: Text('Hãy hoàn thành màn chơi $man để mở khóa màn chơi mới'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackbar)
          .closed
          .then((reason) {
        _thongBao = false;
      });
    }
  }
}
