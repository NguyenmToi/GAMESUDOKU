import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/ChonManChoi.dart';
import 'package:sudoku/ManHinh/ManHinhChinh.dart';
import 'package:sudoku/ManHinh/ManHinhChoi.dart';
import 'package:sudoku/ManHinh/QuanLyManChoi.dart';
import 'package:sudoku/ManHinh/QuanLyThongTinCaNhan.dart';
import 'package:sudoku/ManHinh/DangKy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ManHinhChinh(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
