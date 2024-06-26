import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/DangNhap.dart';
import 'dart:io';

import 'package:sudoku/ManHinh/LichSuChoi.dart';

class QuanLyThongTinCaNhan extends StatefulWidget {
  const QuanLyThongTinCaNhan({super.key});

  @override
  State<QuanLyThongTinCaNhan> createState() => _QuanLyThongTinCaNhanState();
}

class _QuanLyThongTinCaNhanState extends State<QuanLyThongTinCaNhan> {
  File? _image;

  void _changeNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thay Đổi Tên'),
          content: TextField(
            onChanged: (value) {},
            decoration: InputDecoration(
              hintText: 'Nhập tên mới',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Lưu'),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Thông Tin Cá Nhân',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: null, //_pickImage,
              child: Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: null,
                  child: _image == null
                      ? Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: Colors.grey[700],
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            _xayDungDong('Tên người chơi', 'John Doe'),
            SizedBox(height: 10),
            _xayDungDong('Màn', 'Màn 22'),
            SizedBox(height: 10),
            _xayDungDong('Điểm', '35'),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LichSuaChoi()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lịch sử chơi:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.history,
                    color: Colors.blue,
                    size: 30,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const DangNhap()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.white,
                  minimumSize: Size(220, 50),
                ),
                // child: Text('Đăng Xuất', style: TextStyle(fontSize: 22)),
                child: const Icon(
                  Icons.exit_to_app,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _xayDungDong(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: Colors.black),
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
