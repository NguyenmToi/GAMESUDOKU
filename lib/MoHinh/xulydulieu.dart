import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
class ctaiKhoan {
  int diem;
  int man;
  String taikhoan;
  String tentaikhoan;
  String matkhau;
  bool quanly;
  bool trangthai;
  String anh;

  ctaiKhoan({
    required this.diem,
    required this.man,
    required this.taikhoan,
    required this.tentaikhoan,
    required this.matkhau,
    required this.quanly,
    required this.trangthai,
    required this.anh,
  });

  factory ctaiKhoan.fromSnapshot(DataSnapshot snapshot) {
    Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
    return ctaiKhoan(
      diem: data['diem'] ?? 0,
      man: data['man'] ?? 0,
      taikhoan: data['taikhoan'] ?? "",
      tentaikhoan: data['tentaikhoan'] ?? "",
      matkhau: data['matkhau'] ?? "",
      quanly: data['quanly'] ?? false,
      trangthai: data['trangthai'] ?? true,
      anh: data['anh'] ?? "",
    );
  }

  Future<void> capNhat(
      int diem,
      int man,
      String taikhoan,
      String tentaikhoan,
      String matkhau,
      bool quanly,
      bool trangthai,
      String anh) async {
    DatabaseReference userReference =
        FirebaseDatabase.instance.ref().child('taikhoan').child(taikhoan);
    await userReference.update({
      'diem': diem,
      'man': man,
      'taikhoan': taikhoan,
      'tentaikhoan': tentaikhoan,
      'matkhau': matkhau,
      'quanly': quanly,
      'trangthai': trangthai,
      'anh': anh
    });
  }

  static Future<ctaiKhoan> fetchUser(String userId) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child("taikhoan").child(userId);
    DatabaseEvent event = await reference.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      return ctaiKhoan.fromSnapshot(snapshot);
    } else {
      throw Exception("User not found");
    }
  }

  static Future<void> ThemTaiKhoan(String ten, String matkhau) async {
    final quanly = false;
    final anh = '';
    final trangthai = true;
    final diem = 0;
    final man = 1;

    try {
      DatabaseReference productsRef =
          FirebaseDatabase.instance.ref().child('taikhoan');

      String productId = productsRef.push().key!;

      Map<String, dynamic> productData = {
        'diem': diem,
        'man': man,
        'taikhoan': ten,
        'tentaikhoan': ten,
        'anh': anh,
        'trangthai': trangthai,
        'quanly': quanly,
        'matkhau': matkhau,
      };

      await productsRef.child(productId).set(productData);
      print('Tài khoản đã được thêm thành công.');
    } catch (error) {
      print('Lỗi khi thêm tài khoản: $error');
      throw error;
    }
  }

  static Future<bool> kiemTraTaiKhoanTonTai(String ten) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('taikhoan');
    DatabaseEvent event = await ref.orderByChild('taikhoan').equalTo(ten).once();
    DataSnapshot snapshot = event.snapshot;

    return snapshot.value != null;
  }


//đăng nhập tài khoản 
  static Future<bool> dangNhap(String taiKhoan, String matKhau) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('taikhoan');
    DatabaseEvent event = await ref.orderByChild('taikhoan').equalTo(taiKhoan).once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;
      for (var user in userData.values) {
        if (user['matkhau'] == matKhau) {
          return true;
        }
      }
    }
    return false;
  }
}

class cmucDo {
  int mamucdo;
  String tenmucdo;
  int soan;
  int diem;

  cmucDo({
    required this.mamucdo,
    required this.tenmucdo,
    required this.soan,
    required this.diem,
  });

  factory cmucDo.fromJson(String key, Map<dynamic, dynamic> json) {
    return cmucDo(
      mamucdo: json['mamucdo'] ?? 0,
      tenmucdo: json['tenmucdo'] ?? "",
      soan: json['soan'] ?? 0,
      diem: json['diem'] is int ? json['diem'] : int.tryParse(json['diem'].toString()) ?? 0,
    );
  }

  static DatabaseReference hienthimucdo() {
    return FirebaseDatabase.instance.ref().child('mucdo');
  }

  static Future<List<cmucDo>> dsMucDo() async {
    DatabaseReference reference = hienthimucdo();
    DatabaseEvent event = await reference.once();
    DataSnapshot dataSnapshot = event.snapshot;

    Map<dynamic, dynamic>? values;

    if (dataSnapshot.value != null && dataSnapshot.value is Map) {
      values = dataSnapshot.value as Map<dynamic, dynamic>;
      print("Data snapshot is a map: $values");
    } else {
      print("Data snapshot is not a map or is null");
      return [];
    }

    List<cmucDo> lmucdo = [];
    values.forEach((key, value) {
      print("Processing key: $key, value: $value");
      lmucdo.add(cmucDo.fromJson(key, value as Map<dynamic, dynamic>));
    });

    return lmucdo;
  }
}

class cManThuThach {
  late int maman;
  late String tenman;

  cManThuThach({required this.maman, required this.tenman});

  factory cManThuThach.fromJson(String key, Map<dynamic, dynamic> json) {
    return cManThuThach(
      maman: json['maman'] ?? 0,
      tenman: json['tenman'] ?? "",
    );
  }

  static DatabaseReference dsThuThach() {
    return FirebaseDatabase.instance.ref().child('thuthach');
  }

  static Future<List<cManThuThach>> taiDanhSachMan() async {
    DatabaseReference reference = dsThuThach();
    DatabaseEvent event = await reference.once();
    DataSnapshot dataSnapshot = event.snapshot;
    Map<dynamic, dynamic>? values =
        dataSnapshot.value as Map<dynamic, dynamic>?;

    List<cManThuThach> man = [];
    if (values != null) {
      values.forEach((key, value) {
        man.add(cManThuThach.fromJson(key, value));
      });
    }
    return man;
  }
}
