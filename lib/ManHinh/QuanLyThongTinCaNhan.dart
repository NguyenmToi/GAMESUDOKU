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
  String? dulieuanh;
  bool nhan = false;

  final TextEditingController _tenController = TextEditingController();
  final TextEditingController _mkhientaiController = TextEditingController();
  final TextEditingController _mkmoiController = TextEditingController();
  final TextEditingController _mkmoinhaplaiController = TextEditingController();

  late String matkhauhientai = widget.matkhau.toString();
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

        if (widget.anh != "") {
          try {
            await storage.ref('anh/${widget.taikhoan}.png').delete();
          } catch (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi xóa ảnh: $error')),
            );
          }
        }

        File imageFile = File(pickedFile.path);
        Uint8List imageBytes = await imageFile.readAsBytes();
        String tenanh = widget.taikhoan!;
        Reference reference = storage.ref().child('anh/$tenanh.png');
        await reference.putData(imageBytes);
        //tải lên dữ liệu dưới dạng bytes.
        String diachianh = await reference.getDownloadURL();

        setState(() {
          widget.anh = diachianh;
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
              constraints: BoxConstraints(maxHeight: 200.0), //độ cao lớn nhất
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _tenController,
                    onChanged: (value) {
                      _tenController.text.toString();
                    },
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
    if (_tenController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền thông tin'),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 500),
        ),
      );
      _tenController.text = widget.tentaikhoan;
      return;
    } else if (_tenController.text.length < 1 ||
        _tenController.text.length > 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tên tối thiểu 1 ký tự và tối đa 18 ký tự'),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 2000),
        ),
      );
      return;
    } else {
      setState(() {
        widget.tentaikhoan = _tenController.text.toString().trim();
      });
      databaseReference.child('taikhoan').child(widget.taikhoan).update({
        'tentaikhoan': _tenController.text.toString().trim(),
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
            var ttTaiKhoan = await ctaiKhoan.thongTinDangNhap(widget.taikhoan);
            if (ttTaiKhoan != null) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ManHinhChinh(
                    ttTaiKhoan: ttTaiKhoan,
                  ),
                ),
                (Route<dynamic> route) => false,
              );
            }
          },
        ),
        title: Text(
          'Thông Tin Cá Nhân',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.amber[200],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: widget.anh.isNotEmpty
                          ? BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget.anh),
                                fit: BoxFit.fill,
                              ),
                              border: Border.all(color: Colors.black))
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
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tên người chơi',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.tentaikhoan,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => thayDoiTen(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  _xayDungDong('Màn', 'Màn ${widget.man}'),
                  SizedBox(height: 15),
                  _xayDungDong('Điểm', '${widget.diem}'),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LichSuaChoi(
                            taikhoan: widget.taikhoan,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Lịch sử chơi:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.history,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal:
                    60.0), //chỉ định khoảng cách trái và phải so với đối tượng
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      doiMatKhau();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    onPrimary: Colors.white,
                    minimumSize: Size(220, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text('Đổi mật khẩu',
                      style: TextStyle(fontSize: 20)),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => DangNhap()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.red,
                    minimumSize: Size(220, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(color: Colors.red),
                    ),
                  ),
                  child: const Icon(
                    Icons.exit_to_app,
                    size: 30,
                  ),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void doiMatKhau() {
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
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: "Mật khẩu hiện tại",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _mkmoiController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Mật khẩu mới",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _mkmoinhaplaiController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Nhập lại mật khẩu mới",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
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
                if (_mkmoiController.text != _mkmoinhaplaiController.text) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Lỗi'),
                        content: Text(
                            'Mật khẩu mới và mật khẩu nhập lại phải giống nhau.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else if (_mkhientaiController.text != matkhauhientai) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Lỗi'),
                        content: Text('Mật khẩu hiện tại không chính xác '),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else if (_mkmoiController.text.length < 6) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Lỗi'),
                        content: Text('mật khẩu mới tối thiểu là 6 ký tự'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else if (_mkhientaiController.text.toString() ==
                    _mkmoiController.text.toString()) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Lỗi'),
                        content: Text(
                            'mật khẩu mới không được trùng với mật khẩu hiện tại'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã thay đổi mật khẩu thành công'),
                      backgroundColor: Colors.green,
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                  ctaiKhoan.capNhatMatKhau(
                      widget.taikhoan, _mkmoiController.text.toString());
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => DangNhap()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
            ),
          ],
        );
      },
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
