import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

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

  static Future<void> createUser(String taikhoan, String matkhau, bool vaitro,
      bool trangthai, String anh) async {
    DatabaseReference userReference =
        FirebaseDatabase.instance.ref().child('taikhoan ').push();
    await userReference.set({
      'tentaikhoan': taiKhoan,
      'matkhau': matkhau,
      'persission': vaitro,
      'trangthai': trangthai,
      'anh': anh,
      'id': userReference.key,
    });
  }
}
