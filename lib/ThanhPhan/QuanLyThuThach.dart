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
      _dsManThuThach = cManThuThach.taiDanhSachMan();
    });
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
                    int mamanxoa = dsManThuThach[index].maman;
                    return _xayDungCacThanhPhan(
                      title: manThuThach.tenman,
                      color: Colors.lightBlue[100]!,
                      onTapEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CapNhatManChoi(),
                          ),
                        );
                      },
                      onTapDelete: () {
                        thongBaoXoaManChoi('man${mamanxoa.toString()}');
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
    required Color color,
    VoidCallback? onTapEdit,
    VoidCallback? onTapDelete,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: onTapEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.black),
              onPressed: onTapDelete,
            ),
          ],
        ),
      ),
    );
  }

  void thongBaoXoaManChoi(String maman) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Xóa màn chơi',
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          content: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber, size: 30, color: Colors.red),
              SizedBox(width: 8), // Khoảng cách giữa icon và văn bản
              Flexible(
                child: Text(
                    'Màn chơi sẽ bị xóa vĩnh viễn, bạn có muốn xóa không ?'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
            TextButton(
              child: const Text('Đồng ý'),
              onPressed: () {
                xoaManChoi(maman);
                Navigator.of(context).pop();
                setState(() {
                  taiLaiDanhSachMan();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
