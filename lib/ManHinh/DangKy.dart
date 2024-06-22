import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

class DangKy extends StatefulWidget {
  const DangKy({super.key});

  @override
  State<DangKy> createState() => DangKyState();
}

class DangKyState extends State<DangKy> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      List.generate(
          length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  Future<void> addAccount(TextEditingController usernameController,
      [TextEditingController? passwordController]) async {
    final name = _usernameController.text;
    final pass = _passwordController.text;
    final vaitro = 1;
    final anh = null;
    final trangthai = true;

    String idProduct = generateRandomString(10);

    try {
      DatabaseReference productsRef =
          FirebaseDatabase.instance.ref().child('taikhoan');

      String productId = productsRef.push().key!;

      Map<String, dynamic> productData = {
        'idproduct': idProduct,
        'taikhoan': name,
        'tentaikhoan': name,
        'anh': anh,
        'trangthai': trangthai,
        'vaitro': vaitro,
        'matkhau': pass,
      };

      productsRef
          .child(productId)
          .set(productData)
          .then((_) {})
          .catchError((error) {});
    } catch (error) {}
  }

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
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Tên tài khoản',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên tài khoản';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Nhập lại mật khẩu',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập lại mật khẩu';
                  }
                  if (value != _passwordController.text) {
                    return 'Mật khẩu không khớp';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 300, // Set the width to fill the parent
                height: 50, // Set the height to 50
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue, // Set the background color to blue
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addAccount(_usernameController, _passwordController);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đăng ký thành công')),
                      );
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
