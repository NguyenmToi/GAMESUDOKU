import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/ManHinhChinh.dart';
import 'package:sudoku/ManHinh/TaoDoKho.dart';
import 'package:sudoku/ManHinh/TaoManChoi.dart';
import 'package:sudoku/ThanhPhan/QuanLyMucDo.dart';
import 'package:sudoku/ThanhPhan/QuanLyThuThach.dart';

class QuanLyManChoi extends StatefulWidget {
  const QuanLyManChoi({super.key});

  @override
  State<QuanLyManChoi> createState() => _QuanLyManChoi();
}

class _QuanLyManChoi extends State<QuanLyManChoi> {
  bool qlThuThach = true;
  bool qlMucDo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[200], // Màu nền appbar
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
                padding: EdgeInsets.only(right: 40.0),
                child: Text(
                  "Quản lý màn chơi",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            color: Colors.black,
          ),
          SizedBox(
            height: 45,
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        qlThuThach = true;
                        qlMucDo = false;
                      });
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: qlThuThach
                            ? const Color.fromARGB(255, 146, 255, 208)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(0), // hình dạng khung
                        )),
                    child: const Text(
                      'Thử thách',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  color: Colors.grey, // Màu viền xám
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        qlThuThach = false;
                        qlMucDo = true;
                      });
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: qlMucDo
                            ? const Color.fromARGB(255, 146, 255, 208)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        )),
                    child: const Text(
                      'Mức độ',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // Viền xám
                ),
                child:
                    qlThuThach ? const QuanLyThuThach() : const QuanLyMucDo()),
          ),
          ElevatedButton(
            onPressed: () {
              if (qlThuThach == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TaoManChoi()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TaoDoKho()),
                );
              }
            },
            child: const Text(
              'Tạo màn chơi',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              minimumSize:
                  const Size(double.infinity, 50), // Co giãn theo màn hình
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0), // Bo tròn góc
              ),
              backgroundColor: Colors.blue,
              side: BorderSide.none,
            ),
          ),
        ],
      ),
    );
  }
}
