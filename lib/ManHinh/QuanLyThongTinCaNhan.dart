import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/DangNhap.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:sudoku/ManHinh/LichSuChoi.dart';
import 'package:sudoku/ManHinh/ManHinhChinh.dart';
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
      required this.man,
      required this.matkhau});
  final String taikhoan;
  final String matkhau;
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
  bool trangThaiNut = false;

  final TextEditingController _tenController = TextEditingController();
  final TextEditingController _mkhientaiController = TextEditingController();
  final TextEditingController _mkmoiController = TextEditingController();
  final TextEditingController _mkmoinhaplaiController = TextEditingController();

  bool nhan = false;

  Future<void> _pickImage() async {
    if (nhan) {
      return;
    }
    nhan = true; // đang trong quá trình chọn ảnh

    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        FirebaseStorage storage = FirebaseStorage.instance;

        // xóa ảnh cũ
        if (widget.anh != "") {
          try {
            await storage.ref('anh/${widget.taikhoan}.png').delete();
          } catch (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi xóa ảnh: $error')),
            );
          }
        }

        // Đọc và tải ảnh lên Firebase Storage
        File imageFile = File(pickedFile.path);
        Uint8List imageBytes = await imageFile.readAsBytes();
        String tenanh = widget.taikhoan!;
        Reference reference = storage.ref().child('anh/$tenanh.png');
        await reference.putData(imageBytes);

        String diachianh = await reference.getDownloadURL();
        setState(() {
          widget.anh = diachianh;
        });

        setState(() {
          dulieuanh = diachianh;
          databaseReference.child('taikhoan').child(widget.taikhoan).update({
            'anh': dulieuanh.toString(),
          }).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã thay đổi ảnh thành công'),
                backgroundColor: Colors.green,
                duration: Duration(milliseconds: 500),
              ),
            );
          });
        });
      }
    } catch (e) {
      print('Lỗi khi chọn ảnh: $e');
    } finally {
      nhan = false; // quá trình chọn ảnh đã kết thúc
    }
  }

  void thayDoiTen(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thay đổi tên'),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: 200.0), // Set the maximum height
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _tenController,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: 'Nhập tên mới',
                    ),
                  ),
                ],
              ),
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

  void thayDoiMatKhau(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thay đổi mật khẩu'),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: 200.0), // Set the maximum height
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller:
                        _mkhientaiController, // Controller để lấy giá trị từ ô nhập mật khẩu
                    obscureText: trangThaiNut, // Ẩn hiện mật khẩu khi nhập
                    decoration: InputDecoration(
                      labelText: "Mật khẩu", // Nhãn cho ô nhập mật khẩu

                      suffixIcon: IconButton(
                        icon: Icon(
                          trangThaiNut
                              ? Icons.visibility
                              : Icons
                                  .visibility_off, // Biểu tượng ẩn hiện mật khẩu
                        ),
                        onPressed: () {
                          setState(() {
                            trangThaiNut =
                                !trangThaiNut; // Thay đổi trạng thái ẩn hiện mật khẩu
                          });
                        },
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                    ),
                  ),
                  TextField(
                    controller: _mkmoiController,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: 'Nhập mật khẩu mới',
                    ),
                  ),
                  TextField(
                    controller: _mkmoinhaplaiController,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: 'Nhập lại mật khẩu mới',
                    ),
                  ),
                ],
              ),
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
          content: Text('Vui lòng điền thông tin'),
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
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 500),
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
            onPressed: () async {
              ctaiKhoan? ttTaiKhoan = await ctaiKhoan.thongTindangNhap(
                  widget.taikhoan, widget.matkhau);

              if (ttTaiKhoan != null) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ManHinhChinh(
                            ttTaiKhoan: ttTaiKhoan,
                          )),
                  (Route<dynamic> route) =>
                      false, // Loại bỏ tất cả các trang trước đó
                );
              }
            }),
        title: Text(
          'Thông Tin Cá Nhân',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.amber[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: widget.anh.isNotEmpty
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.anh!),
                          fit: BoxFit.fill,
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
            const SizedBox(height: 25),
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
                  MaterialPageRoute(
                      builder: (context) => LichSuaChoi(
                            taikhoan: widget.taikhoan,
                          )),
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
            SizedBox(
              height: 215,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Thay đổi mật khẩu'),
                          content: SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 200.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: _mkhientaiController,
                                    obscureText: trangThaiNut,
                                    decoration: InputDecoration(
                                      labelText: "Mật khẩu",
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          trangThaiNut
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            trangThaiNut = !trangThaiNut;
                                          });
                                        },
                                      ),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                    ),
                                  ),
                                  TextField(
                                    controller: _mkmoiController,
                                    onChanged: (value) {},
                                    decoration: InputDecoration(
                                      hintText: 'Nhập mật khẩu mới',
                                    ),
                                  ),
                                  TextField(
                                    controller: _mkmoinhaplaiController,
                                    onChanged: (value) {},
                                    decoration: InputDecoration(
                                      hintText: 'Nhập lại mật khẩu mới',
                                    ),
                                  ),
                                ],
                              ),
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
                                  widget.tentaikhoan =
                                      _tenController.text.toString();
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  minimumSize: Size(220, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child:
                    const Text('Đổi mật khẩu', style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => DangNhap()),
                    (Route<dynamic> route) => false,
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
