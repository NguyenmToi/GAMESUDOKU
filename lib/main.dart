import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/ChonManChoi.dart';
import 'package:sudoku/ManHinh/DangNhap.dart';
import 'package:sudoku/ManHinh/ManHinhChinh.dart';
import 'package:sudoku/ManHinh/ManHinhChoiThuThach.dart';
import 'package:sudoku/ManHinh/QuanLyManChoi.dart';
import 'package:sudoku/ManHinh/QuanLyThongTinCaNhan.dart';
import 'package:sudoku/ManHinh/DangKy.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:sudoku/MoHinh/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
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
        '/': (context) => DangNhap(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
