import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

class QuanLyTaiKhoan extends StatefulWidget {
  const QuanLyTaiKhoan({super.key});

  @override
  State<QuanLyTaiKhoan> createState() => _QuanLyTaiKhoanState();
}

class _QuanLyTaiKhoanState extends State<QuanLyTaiKhoan> {
  List<ctaiKhoan> accounts = [];
  List<ctaiKhoan> filteredAccounts = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadAccounts();
  }

  Future<void> loadAccounts() async {
    try {
      List<ctaiKhoan> loadedAccounts = await ctaiKhoan.layTatCaTaiKhoan();
      setState(() {
        accounts = loadedAccounts;
        filteredAccounts = accounts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print("Lỗi $e");
    }
  }

  void CapNhatTimKiem(String query) {
    setState(() {
      searchQuery = query;
      filteredAccounts = accounts
          .where((account) => account.tentaikhoan
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  Future<void> CapNhatTrangThaiTaiKhoan(ctaiKhoan taiKhoan, bool status) async {
    ctaiKhoan.capNhatTrangThai(taiKhoan.taikhoan, status);
    setState(() {
      taiKhoan.trangthai = status;
    });
  }

  void ThongBaoXacNhan(ctaiKhoan taiKhoan) {
    bool isLocked = taiKhoan.trangthai == true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isLocked ? 'Khóa tài khoản' : 'Mở khóa tài khoản'),
          content: Text(
            isLocked
                ? 'Bạn có chắc muốn khóa tài khoản ${taiKhoan.taikhoan} này không?'
                : 'Bạn có chắc muốn mở khóa tài khoản ${taiKhoan.taikhoan} này không?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Không'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await CapNhatTrangThaiTaiKhoan(taiKhoan, !isLocked);
              },
              child: Text('Có'),
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
        backgroundColor: Colors.yellow[200],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Text(
              'Quản lý tài khoản',
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm theo tên',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: CapNhatTimKiem,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredAccounts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          color: filteredAccounts[index].trangthai == false
                              ? Colors.red[200]
                              : Colors.lightBlue[100],
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    NetworkImage(filteredAccounts[index].anh),
                                backgroundColor: Colors.black,
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      filteredAccounts[index].tentaikhoan,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Điểm: ${filteredAccounts[index].diem}, Màn: ${filteredAccounts[index].man}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  filteredAccounts[index].trangthai
                                      ? Icons.lock_open
                                      : Icons.lock,
                                  color: Colors.black,
                                ),
                                onPressed: () =>
                                    ThongBaoXacNhan(filteredAccounts[index]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
