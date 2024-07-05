import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/ChonManChoi.dart';
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
                                DuLieuManHinhChoiMucDo(mucDo);
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
      XepHang(),
      //ThongKe(ttTaiKhoan: widget.ttTaiKhoan),
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

  void DuLieuManHinhChoiMucDo(cmucDo mucDo) {
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
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: FileImage(File(ttTaiKhoan.anh!)),
                        backgroundColor: Colors.transparent,
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
                  huongDanChoi(context);
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChonManChoi(),
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
              ],
            ),
          )
        ],
      ),
    );
  }

  void huongDanChoi(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Luật Chơi'),
          content: const SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Hướng dẫn chơi Sudoku:\n\n'
                  'Sudoku là câu đố trí tuệ có hình dạng lưới gồm 9x9 ô trống.\n\n'
                  'Bạn chỉ có thể sử dụng các số từ 1 đến 9.\n\n'
                  'Mỗi khối gồm 3×3 ô trống chỉ có thể chứa các số từ 1 đến 9.\n\n'
                  'Mỗi hàng dọc chỉ có thể chứa các số từ 1 đến 9.\n\n'
                  'Mỗi hàng ngang chỉ có thể chứa các số từ 1 đến 9.\n\n'
                  'Mỗi số trong khối 3×3, hàng dọc hoặc hàng ngang không được trùng nhau.\n\n'
                  'Câu đố được giải khi điền đúng hết tất cả các số trên toàn bộ lưới Sudoku.\n\n'
                  'Chúc bạn chơi vui vẻ!',
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            if (ttTaiKhoan.quanly == true)
              TextButton(
                child: Text('Sửa'),
                onPressed: () {
                  Navigator.of(context).pop();
                  //
                },
              ),
          ],
        );
      },
    );
  }
}
