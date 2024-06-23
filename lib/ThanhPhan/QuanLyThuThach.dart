import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/CapNhatManChoi.dart';
import 'package:sudoku/ManHinh/TaoManChoi.dart';

class QuanLyThuThach extends StatefulWidget {
  const QuanLyThuThach({super.key});

  @override
  State<QuanLyThuThach> createState() => _QuanLyThuThachState();
}

class _QuanLyThuThachState extends State<QuanLyThuThach> {
  List<String> manChoi = ['Màn 1', 'Màn 2', 'Màn 3', 'Màn 4'];

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
                  MaterialPageRoute(builder: (context) => const TaoManChoi()),
                );
              },
              child: Text(
                'Tạo màn chơi',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Co giãn theo màn hình
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Bo tròn góc
                ),
                backgroundColor: Colors.blue, // Màu nền xanh
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: manChoi.length,
                itemBuilder: (context, index) {
                  return _buildScreen(
                      title: manChoi[index], color: Colors.lightBlue[100]!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreen({required String title, required Color color}) {
    return Card(
      color: color,
      // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CapNhatManChoi()),
                );
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
  }
}
