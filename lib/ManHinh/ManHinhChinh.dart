import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/ChonManChoi.dart';
import 'package:sudoku/ManHinh/ManHinhChoiMucDo.dart';
import 'package:sudoku/ManHinh/QuanLyManChoi.dart';
import 'package:sudoku/ManHinh/QuanLyThongTinCaNhan.dart';
import 'package:sudoku/ThanhPhan/QuanLyMucDo.dart';

class ManHinhChinh extends StatefulWidget {
  const ManHinhChinh({super.key});

  @override
  State<ManHinhChinh> createState() => _ManHinhChinhState();
}

class _ManHinhChinhState extends State<ManHinhChinh> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: EdgeInsets.fromLTRB(3, 25, 3, 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
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
                                builder: (context) => QuanLyThongTinCaNhan()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage('assets/image/avt1.jpg'),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phạm Tuân',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Màn 22',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.question_mark,
                    size: 35,
                    color: Colors.green[200],
                  ),
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
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
                  SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/image/logo.png',
                    width: 220,
                    height: 200,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChonManCHoi()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // nền xanh
                      onPrimary: Colors.white, // chữ đỏ
                      minimumSize: Size(280, 50), // Tăng bề ngang và độ cao
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // làm tròn góc 8px
                      ),
                    ),
                    child:
                        const Text('Chọn màn', style: TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuanLyMucDo()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // nền xanh
                      onPrimary: Colors.white, // chữ đỏ
                      minimumSize: Size(280, 50), // Tăng bề ngang và độ cao
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // làm tròn góc 8px
                      ),
                    ),
                    child: const Text('Ngẫu nhiên',
                        style: TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuanLyMucDo()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // nền xanh
                      onPrimary: Colors.white, // chữ đỏ
                      minimumSize: Size(280, 50), // Tăng bề ngang và độ
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // làm tròn góc 8px
                      ),
                    ),
                    child: const Text('Quản lý màn chơi',
                        style: TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // nền xanh
                      onPrimary: Colors.white, // chữ đỏ
                      minimumSize: Size(280, 50), // Tăng bề ngang và độ cao
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // làm tròn góc 8px
                      ),
                    ),
                    child: const Text('Quản lý tài khoản',
                        style: TextStyle(fontSize: 22)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
}
