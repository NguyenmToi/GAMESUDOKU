import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class taiKhoan {
  String id;
  String taikhoan;
  String matkhau;
  bool chucvu;
  bool trangthai;
  String anh;

  taiKhoan({
    required this.id,
    required this.taikhoan,
    required this.matkhau,
    required this.chucvu,
    required this.trangthai,
    required this.anh,
  });

  factory taiKhoan.fromSnapshot(DataSnapshot snapshot) {
    Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
    return taiKhoan(
      taikhoan: data['displayName'] ?? "",
      matkhau: data['email'] ?? "",
      chucvu: data['persission'] ?? false,
      trangthai: data['status'] ?? true,
      anh: data['image'] ?? "",
      id: data['id'].toString(),
    );
  }

  Future<void> updateInformation(String newUsername, String newPassword,
      bool newRole, bool newStatus, String newImage, String id) async {
    DatabaseReference userReference =
        FirebaseDatabase.instance.ref().child('taikhoan').child(id);
    await userReference.update({
      'displayName': newUsername,
      'email': newPassword,
      'persission': newRole,
      'status': newStatus,
      'image': newImage,
    });
  }

  static Future<taiKhoan> fetchUser(String userId) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child("taikhoan").child(userId);
    DatabaseEvent event = await reference.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      return taiKhoan.fromSnapshot(snapshot);
    } else {
      throw Exception("User not found");
    }
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
