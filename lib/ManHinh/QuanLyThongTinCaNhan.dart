import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/DangNhap.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:sudoku/ManHinh/LichSuChoi.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class QuanLyThongTinCaNhan extends StatefulWidget {
  QuanLyThongTinCaNhan(
      {super.key,
      required this.tentaikhoan,
      required this.taikhoan,
      required this.anh,
      required this.diem,
      required this.man});
  final String taikhoan;
  late String tentaikhoan;
  final int man;
  late String anh;
  final int diem;

  @override
  State<QuanLyThongTinCaNhan> createState() => _QuanLyThongTinCaNhanState();
}

class _QuanLyThongTinCaNhanState extends State<QuanLyThongTinCaNhan> {
  File? anh;
  String? duongdananh;
  String? dulieuanh;

  final TextEditingController _tenController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        widget.anh = pickedFile.path;
      });

      FirebaseStorage storage = FirebaseStorage.instance;
      try {
        await storage.ref('anh/${widget.taikhoan}.png').delete();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi xóa ảnh: $error')),
        );
      }

      File imageFile = File(pickedFile.path);
      Uint8List imageBytes = await imageFile.readAsBytes();

      String tenanh = widget.taikhoan!;

      Reference reference = storage.ref().child('anh/$tenanh.png');

      // Tải ảnh lên Firebase Storage
      await reference.putData(imageBytes);

      // Lấy URL của ảnh đã tải lên
      // String diachianh = await reference.getDownloadURL();

      setState(() {
        duongdananh = pickedFile.path;
        databaseReference.child('taikhoan').child(widget.taikhoan).update({
          'anh': duongdananh.toString(),
        }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã thay đổi ảnh thành công'),
              backgroundColor: Colors.green,
            ),
          );
        });
      });
    }
  }

  void thayDoiTen(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thay Đổi Tên'),
          content: TextField(
            controller: _tenController,
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
                thucHienThayDoiTen();
                setState(() {
                  widget.tentaikhoan = _tenController.text.toString();
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  final databaseReference = FirebaseDatabase.instance.reference();
  Future<void> thucHienThayDoiTen() async {
    if (_tenController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin'),
        ),
      );
      return;
    }
    databaseReference.child('taikhoan').child(widget.taikhoan).update({
      'tentaikhoan': _tenController.text.toString(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã thay đổi tên thành công'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi : $error'),
        ),
      );
    });
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
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: widget.anh.isNotEmpty
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File(widget.anh!)),
                          fit: BoxFit.contain,
                        ),
                      )
                    : BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                child: widget.anh.isEmpty
                    ? Center(
                        child: Icon(
                          Icons.image,
                          size: 50,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 50),
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
            const SizedBox(height: 7),
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
