import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/DangKy.dart';
import 'package:sudoku/ManHinh/ManHinhChinh.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';
import 'package:sudoku/ManHinh/ManHinhChoiNgay.dart';

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
          backgroundColor: Colors.red,
          content: Text("Bạn chưa nhập Tài khoản hoặc Mật khẩu"),
        ),
      );
      return;
    }
    RegExp KhongKiTuDacBiet = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (KhongKiTuDacBiet.hasMatch(taiKhoan)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Tài khoản không được chứa ký tự đặc biệt"),
        ),
      );
      return;
    }
    bool kiemTraDangNhap = await ctaiKhoan.dangNhap(taiKhoan, matKhau);
    bool KiemTraKhoaTK = await ctaiKhoan.kiemTraTrangThaiTaiKhoan(taiKhoan);
    if (!KiemTraKhoaTK) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Tài khoản này đang bị khóa!"),
        ),
      );
      return;
    }

    if (kiemTraDangNhap) {
      ctaiKhoan? ttTaiKhoan = await ctaiKhoan.thongTinDangNhap(taiKhoan);

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
            backgroundColor: Colors.red,
            content: Text("Lấy thông tin tài khoản thất bại"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Đăng nhập thất bại"),
        ),
      );
    }
  }

  void HienThiMucDo() {
    bool chonNgauNhien = false; // Trạng thái của checkbox
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Wrap(
              children: <Widget>[
                ListTile(
                  leading:
                      Icon(Icons.sentiment_satisfied_alt, color: Colors.green),
                  title: Text('Dễ'),
                  onTap: () {
                    Navigator.pop(context);
                    _batDauChoi('Dễ', 20, chonNgauNhien);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.sentiment_neutral, color: Colors.blue),
                  title: Text('Trung bình'),
                  onTap: () {
                    Navigator.pop(context);
                    _batDauChoi('Trung bình', 30, chonNgauNhien);
                  },
                ),
                ListTile(
                  leading:
                      Icon(Icons.sentiment_dissatisfied, color: Colors.orange),
                  title: Text('Khó'),
                  onTap: () {
                    Navigator.pop(context);
                    _batDauChoi('Khó', 40, chonNgauNhien);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.sentiment_very_dissatisfied,
                      color: Colors.red),
                  title: Text('Chuyên gia'),
                  onTap: () {
                    Navigator.pop(context);
                    _batDauChoi('Chuyên gia', 50, chonNgauNhien);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  leading: Icon(
                    chonNgauNhien
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: chonNgauNhien
                        ? Colors.red
                        : Colors.grey, // Thay đổi màu icon theo trạng thái
                  ),
                  title: Text(
                    'Ngẫu nhiên',
                    style: TextStyle(
                        color: chonNgauNhien
                            ? Colors.red
                            : Colors.black), // Thay đổi màu chữ
                  ),
                  onTap: () {
                    setState(() {
                      chonNgauNhien = !chonNgauNhien;
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

// Hàm _batDauChoi được cập nhật với tham số ngẫu nhiên
  void _batDauChoi(String tenMucDo, int soOAn, bool ngauNhien) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManHinhChoiNgay(
          tenMucDo: tenMucDo,
          soOAn: soOAn,
          ngauNhien: ngauNhien,
        ),
      ),
    );
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
                    labelText: 'Đăng Nhập',
                    prefixIcon: Icon(Icons.person_4_sharp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10), // Khoảng cách bên trong ô nhập
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên tài khoản'; // Kiểm tra hợp lệ
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _MatKhau,
                  obscureText: !temp, // Ẩn hiện mật khẩu khi nhập
                  decoration: InputDecoration(
                    labelText: "Mật khẩu",
                    prefixIcon: const Icon(Icons.lock),
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
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                    height:
                        30), // Khoảng cách giữa ô nhập mật khẩu và nút Đăng nhập
                SizedBox(
                  width: 280,
                  height: 45,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              15.0), // Bo góc của nút Đăng nhập
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _dangNhap();
                      }
                    },
                    child: const Text(
                      "Đăng nhập",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Khoảng cách giữa hai nút
                SizedBox(
                  width: 280,
                  height: 45,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              15.0), // Bo góc của nút Chơi ngay
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    onPressed: HienThiMucDo,
                    child: const Text(
                      "Chơi ngay",
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
                      text: 'Bạn chưa có tài khoản? ',
                      style: const TextStyle(
                          color: Colors.black, fontStyle: FontStyle.italic),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Đăng ký ngay',
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
