import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/TaoDoKho.dart';

class QuanLyMucDo extends StatefulWidget {
  const QuanLyMucDo({super.key});

  @override
  State<QuanLyMucDo> createState() => _QuanLyMucDoState();
}

class _QuanLyMucDoState extends State<QuanLyMucDo> {
  List<String> levels = ['Dễ', 'Trung bình', 'Khó', 'Ác mộng'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaoDoKho()),
                );
              },
              child: Text('Tạo mức độ chơi',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Co giãn theo màn hình
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15), // Thêm bán kính bo tròn
                ),
                backgroundColor: Colors.blue, // Đặt màu nền xanh
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.lightBlue[100],
                    child: ListTile(
                      title: Text(
                        levels[index],
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.black),
                            onPressed: () {
                              // Xử lý khi nhấn icon sửa
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.black),
                            onPressed: () {
                              // Xử lý khi nhấn icon xóa
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
