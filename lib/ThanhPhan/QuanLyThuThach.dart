import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/CapNhatManChoi.dart';
import 'package:sudoku/ManHinh/TaoManChoi.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

class QuanLyThuThach extends StatefulWidget {
  const QuanLyThuThach({Key? key}) : super(key: key);

  @override
  State<QuanLyThuThach> createState() => _QuanLyThuThachState();
}

class _QuanLyThuThachState extends State<QuanLyThuThach> {
  late Future<List<cManThuThach>> _dsManThuThach;
  bool thongbao = false;

  void xoaManChoi(String maman) async {
    DatabaseReference manChoi =
        FirebaseDatabase.instance.ref().child('thuthach').child(maman);
    await manChoi.remove();
  }

  @override
  void initState() {
    super.initState();
    taiLaiDanhSachMan();
  }

  Future<void> taiLaiDanhSachMan() async {
    setState(() {
      _dsManThuThach = cManThuThach.taiDanhSachManQuanLy();
    });
  }

  int demSoLuongSo0(List<dynamic> bang) {
    int soLuongSo0 = 0;
    for (var row in bang) {
      for (var cell in row) {
        if (cell == 0) {
          soLuongSo0++;
        }
      }
    }
    return soLuongSo0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: RefreshIndicator(
          onRefresh: taiLaiDanhSachMan,
          child: FutureBuilder<List<cManThuThach>>(
            future: _dsManThuThach,
            builder: (BuildContext context,
                AsyncSnapshot<List<cManThuThach>> snapshot) {
              // Kiểm tra trạng thái kết nối của snapshot
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
                //biểu tượng tải lại
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Không có dữ liệu màn chơi'));
              } else {
                List<cManThuThach> dsManThuThach = snapshot.data!;
                dsManThuThach.sort((a, b) => a.maman.compareTo(b.maman));
                return ListView.builder(
                  itemCount: dsManThuThach.length,
                  itemBuilder: (BuildContext context, int index) {
                    cManThuThach manThuThach = dsManThuThach[index];
                    int maman = dsManThuThach[index].maman;
                    int soluongoan = demSoLuongSo0(dsManThuThach[index].bang);

                    List bang = dsManThuThach[index].bang;
                    List banggiai = dsManThuThach[index].banggiai;
                    int soloi = dsManThuThach[index].soloi;
                    int thoigian = dsManThuThach[index].thoigian;
                    int goiy = dsManThuThach[index].sogoiy;
                    bool trangthaiman = dsManThuThach[index].trangthai;

                    return _xayDungCacThanhPhan(
                      title: manThuThach.tenman,
                      sl: soluongoan,
                      mau: Colors.lightBlue[100]!,
                      trangthaiman: trangthaiman,
                      sua: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CapNhatManChoi(
                              bang: bang,
                              banggiai: banggiai,
                              goiy: goiy,
                              maman: maman,
                              soloi: soloi,
                              thoigian: thoigian,
                            ),
                          ),
                        );
                      },
                      trangThai: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(trangthaiman
                                  ? 'Ẩn màn chơi'
                                  : 'Hiển thị màn chơi'),
                              content: Text(trangthaiman
                                  ? 'Bạn có muốn ẩn màn chơi không ?'
                                  : 'Bạn có muốn hiển thị lại màn chơi không ?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Hủy bỏ'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    cManThuThach.capNhatTrangThaiManChoi(maman);
                                    setState(() {
                                      taiLaiDanhSachMan();
                                    });
                                    thongBaoCapNhat(trangthaiman);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Đồng ý'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _xayDungCacThanhPhan({
    required String title,
    required int sl,
    required Color mau,
    required bool trangthaiman,
    VoidCallback? sua,
    VoidCallback? trangThai,
  }) {
    return Card(
      color: mau,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
        ),
        subtitle: Text(
          'Số ô ẩn: ' + sl.toString(),
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: sua,
            ),
            if (trangthaiman)
              IconButton(
                icon: const Icon(Icons.visibility, color: Colors.black),
                onPressed: trangThai,
              )
            else
              IconButton(
                icon: const Icon(Icons.visibility_off, color: Colors.black),
                onPressed: trangThai,
              )
          ],
        ),
      ),
    );
  }

  void thongBaoCapNhat(bool trangthai) {
    if (!thongbao) {
      thongbao = true;
      final snackbar = SnackBar(
        content:
            Text(trangthai ? 'Đã ẩn màn chơi' : 'Màn chơi đã hiển thị lại'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackbar)
          .closed
          .then((reason) {
        thongbao = false;
      });
    }
  }
}
