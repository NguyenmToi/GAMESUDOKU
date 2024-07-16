import 'package:flutter/material.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

class DangKy extends StatefulWidget {
  const DangKy({Key? key}) : super(key: key);

  @override
  State<DangKy> createState() => DangKyState();
}

class DangKyState extends State<DangKy> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _TaiKhoan = TextEditingController();
  final TextEditingController _MatKhau = TextEditingController();
  final TextEditingController _NhapLaiMatKhau = TextEditingController();

  RegExp KhongKiTuDacBiet = RegExp(r'^[a-zA-Z0-9]+$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Đăng ký tài khoản'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _TaiKhoan,
                decoration: InputDecoration(
                  labelText: 'Tên tài khoản (3-15 kí tự)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên tài khoản';
                  }
                  if (value.length < 3 || value.length > 15) {
                    return 'Tên tài khoản phải có từ 3 đến 15 kí tự';
                  }
                  if (!KhongKiTuDacBiet.hasMatch(value)) {
                    return 'Tên tài khoản không được chứa ký tự đặc biệt';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _MatKhau,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu (6-20 kí tự)',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  if (value.length < 6 || value.length > 20) {
                    return 'Mật khẩu phải có từ 6 đến 20 kí tự';
                  }
                  if (!KhongKiTuDacBiet.hasMatch(value)) {
                    return 'Mật khẩu không được chứa ký tự đặc biệt';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _NhapLaiMatKhau,
                decoration: InputDecoration(
                  labelText: 'Nhập lại mật khẩu',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập lại mật khẩu';
                  }
                  if (value != _MatKhau.text) {
                    return 'Mật khẩu không khớp';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        bool tonTai = await ctaiKhoan
                            .kiemTraTaiKhoanTonTai(_TaiKhoan.text);
                        if (tonTai) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Tên tài khoản đã được sử dụng'),
                            ),
                          );
                        } else {
                          await ctaiKhoan.ThemTaiKhoan(
                              _TaiKhoan.text, _MatKhau.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Đăng ký thành công'),
                            ),
                          );
                        }
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Lỗi khi thêm tài khoản: $error'),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    'Đăng ký',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
