import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/DangNhap.dart';
import 'dart:io';

import 'package:sudoku/ManHinh/LichSuChoi.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

class QuanLyThongTinCaNhan extends StatefulWidget {
  QuanLyThongTinCaNhan(
      {super.key,
      required this.tentaikhoan,
      required this.taikhoan,
      required this.anh,
      required this.diem,
      required this.man});
  final String taikhoan;
  final String tentaikhoan;
  final int man;
  final String anh;
  final int diem;

  @override
  State<QuanLyThongTinCaNhan> createState() => _QuanLyThongTinCaNhanState();
}

class _QuanLyThongTinCaNhanState extends State<QuanLyThongTinCaNhan> {
  File? _image;

  void thayDoiTen(BuildContext context) {
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
            const SizedBox(height: 25),
            // _xayDungDong('Tên người chơi', widget.tentaikhoan),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tên người chơi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(children: [
                  Text(
                    widget.tentaikhoan,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => {thayDoiTen(context)}),
                ])
              ],
            ),
            const SizedBox(height: 15),
            _xayDungDong('Màn', 'Màn ${widget.man}'),
            const SizedBox(height: 15),
            _xayDungDong('Điểm', '${widget.diem}'),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LichSuaChoi()),
                );
              },
              child: const Row(
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
                  minimumSize: const Size(220, 50),
                ),
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
