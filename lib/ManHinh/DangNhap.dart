import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/DangKy.dart';
import 'package:sudoku/ManHinh/ManHinhChinh.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

class DangNhap extends StatefulWidget {
  const DangNhap({super.key});

  @override
  State<DangNhap> createState() => DangNhapState();
}

class DangNhapState extends State<DangNhap> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey để quản lý Form
  final _TaiKhoan = TextEditingController(); // Controller cho ô nhập tài khoản
  final _MatKhau = TextEditingController(); // Controller cho ô nhập mật khẩu
  bool temp = false; // Biến để điều khiển hiển thị mật khẩu

  // Hàm thực hiện đăng nhập
  Future<void> _dangNhap() async {
    String taiKhoan = _TaiKhoan.text.trim();
    String matKhau = _MatKhau.text.trim();

    if (taiKhoan.isEmpty || matKhau.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bạn chưa nhập Tài khoản hoặc Mật khẩu"),
        ),
      );
      return;
    }

    bool isAuthenticated = await ctaiKhoan.dangNhap(taiKhoan, matKhau);

    // Kiểm tra kết quả đăng nhập và chỉ chuyển hướng nếu thành công
    if (isAuthenticated) {
      ctaiKhoan? ttTaiKhoan =
          await ctaiKhoan.thongTindangNhap(taiKhoan, matKhau);

      if (ttTaiKhoan != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManHinhChinh(
                ttTaiKhoan: ttTaiKhoan,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Lấy thông tin tài khoản thất bại"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đăng nhập thất bại"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 60),
          child: Form(
            key: _formKey, // Gắn GlobalKey cho Form để quản lý
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "SUDOKU",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
                const SizedBox(
                    height: 70), // Khoảng cách giữa tiêu đề và ô nhập liệu
                TextFormField(
                  controller:
                      _TaiKhoan, // Controller để lấy giá trị từ ô nhập tài khoản
                  decoration: const InputDecoration(
                    labelText: 'Đăng Nhập', // Nhãn cho ô nhập tài khoản
                    prefixIcon:
                        Icon(Icons.person_4_sharp), // Biểu tượng trước ô nhập
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(15.0)), // Bo viền ô nhập
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10), // Khoảng cách bên trong ô nhập
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên tài khoản'; // Kiểm tra hợp lệ khi submit Form
                    }
                    return null;
                  },
                ),
                const SizedBox(
                    height:
                        20), // Khoảng cách giữa ô nhập tài khoản và ô nhập mật khẩu
                TextFormField(
                  controller:
                      _MatKhau, // Controller để lấy giá trị từ ô nhập mật khẩu
                  obscureText: !temp, // Ẩn hiện mật khẩu khi nhập
                  decoration: InputDecoration(
                    labelText: "Mật khẩu", // Nhãn cho ô nhập mật khẩu
                    prefixIcon:
                        const Icon(Icons.lock), // Biểu tượng trước ô nhập
                    suffixIcon: IconButton(
                      icon: Icon(
                        temp
                            ? Icons.visibility
                            : Icons
                                .visibility_off, // Biểu tượng ẩn hiện mật khẩu
                      ),
                      onPressed: () {
                        setState(() {
                          temp = !temp; // Thay đổi trạng thái ẩn hiện mật khẩu
                        });
                      },
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(15.0)), // Bo viền ô nhập
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10), // Khoảng cách bên trong ô nhập
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu'; // Kiểm tra hợp lệ khi submit Form
                    }
                    return null;
                  },
                ),
                const SizedBox(
                    height:
                        30), // Khoảng cách giữa ô nhập mật khẩu và nút Đăng nhập
                SizedBox(
                  width: 250, // Độ rộng của nút Đăng nhập
                  height: 40, // Chiều cao của nút Đăng nhập
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              15.0), // Bo góc của nút Đăng nhập
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          Colors.blue), // Màu nền của nút Đăng nhập
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _dangNhap(); // Gọi hàm đăng nhập khi Form hợp lệ
                      }
                    },
                    child: const Text(
                      "Đăng nhập", // Nội dung của nút Đăng nhập
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Bạn chưa có tài khoản? ', // Chữ trước link Đăng ký
                      style: const TextStyle(
                          color: Colors.black,
                          fontStyle:
                              FontStyle.italic), // Kiểu chữ cho chữ trước
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Đăng ký ngay', // Link Đăng ký
                          style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle
                                  .normal), // Kiểu chữ cho link Đăng ký
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DangKy()), // Chuyển hướng đến màn hình Đăng ký khi nhấp vào link
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
