import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

class XepHang extends StatefulWidget {
  const XepHang({Key? key}) : super(key: key);

  @override
  State<XepHang> createState() => XepHangState();
}

class XepHangState extends State<XepHang> {
  int NutChon = 0; // Biến lưu trữ nút đang chọn

  List<ctaiKhoan> doKho = [];
  List<ctaiKhoan> thuThach = [];

  @override
  void initState() {
    super.initState();
    NguoiChoiXepHang(SapXep: true); // Lấy người chơi sắp xếp theo điểm ban đầu
  }

  Future<void> NguoiChoiXepHang({required bool SapXep}) async {
    List<ctaiKhoan> nguoichoi = await ctaiKhoan.layDSTaiKhoan(SapXepDiem: SapXep);
    setState(() {
      if (SapXep) {
        doKho = nguoichoi;
      } else {
        thuThach = nguoichoi;
      }
    });
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Bảng xếp hạng',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/image/xephang.jpg",
          height: 250,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      NutChon == 0 ? Colors.blue : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    NutChon = 0;
                  });
                  NguoiChoiXepHang(SapXep: true);
                },
                child: Text(
                  'Độ khó',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      NutChon == 1 ? Colors.blue : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    NutChon = 1;
                  });
                  NguoiChoiXepHang(SapXep: false);
                },
                child: Text(
                  'Thử thách',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: NutChon == 0
                ? LuuDsNguoiChoi(doKho)
                : LuuDsNguoiChoi(thuThach),
          ),
        ),
      ],
    ),
  );
}

  Widget LuuDsNguoiChoi(List<ctaiKhoan> players) {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: players.length,
    itemBuilder: (context, index) {
      final nguoichoi = players[index];
      return ListTile(
        leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: FileImage(File(nguoichoi.anh!)),
                        backgroundColor: Colors.black,
                      ),
        title: Text(nguoichoi.tentaikhoan,
                    style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    ),
                  ),
        subtitle: Text(NutChon == 0
            ? 'Điểm: ${nguoichoi.diem}' // Hiển thị điểm số cho Độ khó
            : 'Màn: ${nguoichoi.man}',
            style: TextStyle(
            color: Colors.black,
            fontSize: 17,
           ),),
             // Hiển thị số màn cho Thử thách
      );
    },
  );
}
}
