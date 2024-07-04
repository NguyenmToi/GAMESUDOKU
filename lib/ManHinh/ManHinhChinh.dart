import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/ChonManChoi.dart';
import 'package:sudoku/ManHinh/LichSuChoi.dart';
import 'package:sudoku/ManHinh/ManHinhChoiMucDo.dart';
import 'package:sudoku/ManHinh/QuanLyManChoi.dart';
import 'package:sudoku/ManHinh/QuanLyThongTinCaNhan.dart';
import 'package:sudoku/ManHinh/ThongKe.dart';
import 'package:sudoku/ManHinh/XepHang.dart';
import 'package:sudoku/ManHinh/QuanLyTaiKhoan.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

class ManHinhChinh extends StatefulWidget {
  const ManHinhChinh({Key? key, required this.ttTaiKhoan}) : super(key: key);
  final ctaiKhoan ttTaiKhoan;

  @override
  State<ManHinhChinh> createState() => _ManHinhChinhState();
}

class _ManHinhChinhState extends State<ManHinhChinh> {
  int _currentIndex = 0;
  late Future<List<cmucDo>> _dsmucDo;

  @override
  void initState() {
    super.initState();
    _dsmucDo = cmucDo.dsMucDo();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void HienThiMucDo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<cmucDo>>(
          future: _dsmucDo,
          builder:
              (BuildContext context, AsyncSnapshot<List<cmucDo>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Không có dữ liệu'));
            } else {
              List<cmucDo> mucDos = snapshot.data!;
              mucDos.sort((a, b) => a.soan.compareTo(b.soan));
              return Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Mức độ chơi',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: mucDos.length,
                        itemBuilder: (context, index) {
                          cmucDo mucDo = mucDos[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                _navigateToManHinhChoiMucDo(mucDo);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                  child: Text(
                                    mucDo.tenmucdo,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      TrangChu(ttTaiKhoan: widget.ttTaiKhoan),
      const XepHang(),
      ThongKe(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Màn Hình Chính',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Xếp Hạng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Thống Kê',
          ),
        ],
      ),
    );
  }

  void _navigateToManHinhChoiMucDo(cmucDo mucDo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Manhinhchoimucdo(
          mucdo: mucDo.tenmucdo,
          soan: mucDo.soan,
          diem: mucDo.diem,
          taikhoan: widget.ttTaiKhoan.taikhoan,
        ),
      ),
    );
  }

  void DuLieuLichSuCHoi() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LichSuaChoi(
          taikhoan: widget.ttTaiKhoan.taikhoan,
        ),
      ),
    );
  }
}

class TrangChu extends StatelessWidget {
  final ctaiKhoan ttTaiKhoan;

  const TrangChu({Key? key, required this.ttTaiKhoan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(3, 25, 3, 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuanLyThongTinCaNhan(
                              taikhoan: ttTaiKhoan.taikhoan,
                              anh: ttTaiKhoan.anh,
                              diem: ttTaiKhoan.diem,
                              man: ttTaiKhoan.man,
                              tentaikhoan: ttTaiKhoan.tentaikhoan,
                              matkhau: ttTaiKhoan.matkhau,
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(ttTaiKhoan.anh!),
                        backgroundColor: Colors.black,
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ttTaiKhoan.tentaikhoan,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Màn ${ttTaiKhoan.man}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.question_mark,
                  size: 35,
                  color: Colors.green[200],
                ),
                onPressed: () {
                  hienThiHuongDan(context);
                },
              )
            ],
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SUDOKU',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/image/logo.png',
                  width: 220,
                  height: 200,
                ),
                const SizedBox(height: 60),
                const SizedBox(height: 15),
                if (ttTaiKhoan.quanly == true)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuanLyManChoi(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      minimumSize: Size(280, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('Quản lý màn chơi',
                        style: TextStyle(fontSize: 20)),
                  ),
                const SizedBox(height: 15),
                if (ttTaiKhoan.quanly == true)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuanLyTaiKhoan(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      minimumSize: Size(280, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('Quản lý tài khoản',
                        style: TextStyle(fontSize: 20)),
                  ),
                if (ttTaiKhoan.quanly)
                  const SizedBox(height: 15)
                else
                  const SizedBox(height: 130),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChonManChoi(
                          man: ttTaiKhoan.man,
                          matkhau: ttTaiKhoan.matkhau,
                          taikhoan: ttTaiKhoan.taikhoan,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size(280, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text('Chọn màn', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    // Sử dụng hàm showDifficultyLevels thông qua _ManHinhChinhState
                    (context.findAncestorStateOfType<_ManHinhChinhState>())
                        ?.HienThiMucDo(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    minimumSize: Size(280, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child:
                      const Text('Ngẫu nhiên', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> hienThiHuongDan(BuildContext context) async {
    TextEditingController _noiDungcontroller = TextEditingController();

    // Tham chiếu đến Firebase Realtime Database
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('huongdanchoi/noidung');

    // Lấy dữ liệu từ Firebase Realtime Database
    DataSnapshot snapshot = await reference.get();

    // Trích xuất dữ liệu và đặt vào controller
    if (snapshot.value != null) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      _noiDungcontroller.text = data['noidung'] ?? '';
    } else {
      _noiDungcontroller.text = '';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Hướng dẫn Chơi'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _noiDungcontroller,
                      readOnly: ttTaiKhoan.quanly ? false : true,
                      maxLines: null, // Cho phép nhiều dòng
                      decoration: InputDecoration(
                        hintText: 'Nhập nội dung hướng dẫn chơi',
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                if (ttTaiKhoan.quanly)
                  TextButton(
                    child: Text('Cập nhật'),
                    onPressed: () async {
                      await reference.set({'noidung': _noiDungcontroller.text});
                      Navigator.of(context).pop();
                    },
                  ),
                TextButton(
                  child: Text('Đóng'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
