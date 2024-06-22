import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/CapNhatManChoi.dart';
import 'package:sudoku/ManHinh/TaoManChoi.dart';

class QuanLyThuThach extends StatefulWidget {
  const QuanLyThuThach({super.key});

  @override
  State<QuanLyThuThach> createState() => _QuanLyThuThachState();
}

class _QuanLyThuThachState extends State<QuanLyThuThach> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAddButton(),
        SizedBox(
          height: 5,
        ),
        _buildScreen(title: 'Màn 1', color: Colors.lightBlue[100]!),
        SizedBox(
          height: 5,
        ),
        _buildScreen(title: 'Màn 2', color: Colors.lightBlue[100]!),
        SizedBox(
          height: 5,
        ),
        _buildScreen(title: 'Màn 3', color: Colors.lightBlue[100]!),
        SizedBox(
          height: 5,
        ),
        _buildScreen(title: 'Màn 4', color: Colors.lightBlue[100]!),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget _buildScreen({required String title, required Color color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.0),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CapNhatManChoi()),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {
                  // Xử lý sự kiện khi nhấn vào nút "thùng rác"
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: double.infinity,
      height: 50.0, // Chiều cao của nút
      color: Colors.blue, // Màu nền của nút
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaoManChoi()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Loại bỏ màu nền mặc định của ElevatedButton
            elevation: 0.0, // Loại bỏ độ nhấn của ElevatedButton
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0), // Tạo góc vuông cho nút
            ),
          ),
          child: const Text(
            'Tạo màn chơi',
            style: TextStyle(
                color: Colors.white, // Màu chữ của nút
                fontWeight: FontWeight.bold, // Kiểu chữ đậm
                fontSize: 18),
          ),
        ),
      ),
    );
  }
}
