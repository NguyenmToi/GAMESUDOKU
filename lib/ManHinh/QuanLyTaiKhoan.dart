import 'package:flutter/material.dart';

class QuanLyTaiKhoan extends StatefulWidget {
  const QuanLyTaiKhoan({super.key});

  @override
  State<QuanLyTaiKhoan> createState() => _QuanLyTaiKhoanState();
}

class _QuanLyTaiKhoanState extends State<QuanLyTaiKhoan> {
  final List<Map<String, String>> accounts = List.generate(10, (index) {
    return {
      "hoten": "Tên thành viên ${index + 1}",
      "anh": 'assets/image/avt1.jpg',
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[200], // Màu nền appbar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(right: 38.0),
                child: Text(
                  'Quản lý tài khoản',
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.lightBlue[100],
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(accounts[index]['anh']!),
                  radius: 30,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    accounts[index]['hoten']!,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Icon(Icons.lock, color: Colors.black),
              ],
            ),
          );
        },
      ),
    );
  }
}
