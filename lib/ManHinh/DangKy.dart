import 'package:flutter/material.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

class DangKy extends StatefulWidget {
  const DangKy({super.key});

  @override
  State<DangKy> createState() => DangKyState();
}

class DangKyState extends State<DangKy> {
  final _formKey = GlobalKey<
      FormState>(); // GlobalKey để quản lý và kiểm tra trạng thái của Form
  final TextEditingController _TaiKhoan =
      TextEditingController(); // Controller cho ô nhập tài khoản
  final TextEditingController _MatKhau =
      TextEditingController(); // Controller cho ô nhập mật khẩu
  final TextEditingController _NhapLaiMatKhau =
      TextEditingController(); // Controller cho ô nhập lại mật khẩu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Biểu tượng nút quay lại
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước đó khi nhấn nút
          },
        ),
        title: Text('Đăng ký tài khoản'), // Tiêu đề của AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key:
              _formKey, // Gắn GlobalKey cho Form để quản lý và kiểm tra trạng thái Form
          child: Column(
            children: <Widget>[
              TextFormField(
                controller:
                    _TaiKhoan, // Controller để lấy giá trị từ ô nhập tài khoản
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
                  return null;
                },
              ),
              TextFormField(
                controller:
                    _MatKhau, // Controller để lấy giá trị từ ô nhập mật khẩu
                decoration: InputDecoration(
                  labelText:
                      'Mật khẩu (6-20 kí tự)', // Nhãn cho ô nhập mật khẩu
                ),
                obscureText: true, // Ẩn văn bản nhập vào ô mật khẩu
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu'; // Kiểm tra hợp lệ khi submit Form
                  }
                  if (value.length < 6 || value.length > 20) {
                    return 'Mật khẩu phải có từ 6 đến 20 kí tự'; // Kiểm tra độ dài mật khẩu
                  }
                  return null;
                },
              ),
              TextFormField(
                controller:
                    _NhapLaiMatKhau, // Controller để lấy giá trị từ ô nhập lại mật khẩu
                decoration: InputDecoration(
                  labelText:
                      'Nhập lại mật khẩu', // Nhãn cho ô nhập lại mật khẩu
                ),
                obscureText: true, // Ẩn văn bản nhập vào ô nhập lại mật khẩu
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập lại mật khẩu'; // Kiểm tra hợp lệ khi submit Form
                  }
                  if (value != _MatKhau.text) {
                    return 'Mật khẩu không khớp'; // Kiểm tra xem mật khẩu nhập lại có khớp với mật khẩu đã nhập không
                  }
                  return null;
                },
              ),
              SizedBox(
                  height:
                      20), // Khoảng cách giữa các ô nhập liệu và nút Đăng ký
              SizedBox(
                width: double.infinity, // Chiều rộng bằng toàn bộ phần màn hình
                height: 50, // Chiều cao của nút Đăng ký
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Màu nền của nút Đăng ký
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Kiểm tra hợp lệ khi submit Form
                      try {
                        bool tonTai = await ctaiKhoan
                            .kiemTraTaiKhoanTonTai(_TaiKhoan.text);
                        if (tonTai) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                    'Tên tài khoản đã được sử dụng')), // Hiển thị thông báo khi tài khoản đã tồn tại
                          );
                        } else {
                          await ctaiKhoan.ThemTaiKhoan(_TaiKhoan.text,
                              _MatKhau.text); // Thêm tài khoản mới vào Firebase
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                    'Đăng ký thành công')), // Hiển thị thông báo đăng ký thành công
                          );
                        }
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                  'Lỗi khi thêm tài khoản: $error')), // Hiển thị thông báo lỗi nếu có lỗi khi thêm tài khoản
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
