import 'package:flutter/material.dart';
import 'dart:io';

class QuanLyThongTinCaNhan extends StatefulWidget {
  const QuanLyThongTinCaNhan({super.key});

  @override
  State<QuanLyThongTinCaNhan> createState() => _QuanLyThongTinCaNhanState();
}

class _QuanLyThongTinCaNhanState extends State<QuanLyThongTinCaNhan> {
  File? _image;

  // Future<void> _pickImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tên người chơi:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: null,
                  child: Row(
                    children: [
                      Text(
                        "_name",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Màn:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Màn 22',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Điểm:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '35',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Thêm hành động đăng xuất ở đây
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent[200], // nền xanh
                  onPrimary: Colors.red, // chữ đỏ
                  minimumSize: Size(220, 50), // Tăng bề ngang và độ cao
                ),
                child: Text('Đăng Xuất', style: TextStyle(fontSize: 22)),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
