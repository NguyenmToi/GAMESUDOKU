import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ctaiKhoan {
  int diem;
  int man;
  String taiKhoan;
  String tenTaiKhoan;
  String matkhau;
  bool quanLy;
  bool trangthai;
  String anh;

  ctaiKhoan({
    required this.diem,
    required this.man,
    required this.taiKhoan,
    required this.tenTaiKhoan,
    required this.matkhau,
    required this.quanLy,
    required this.trangthai,
    required this.anh,
  });

  factory ctaiKhoan.fromSnapshot(DataSnapshot snapshot) {
    Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
    return ctaiKhoan(
      diem: data['diem'] ?? 0,
      man: data['man'] ?? 0,
      taiKhoan: data['taiKhoan'] ?? "",
      tenTaiKhoan: data['tenTaiKhoan'] ?? "",
      matkhau: data['matkhau'] ?? "",
      quanLy: data['quanLy'] ?? false,
      trangthai: data['trangthai'] ?? true,
      anh: data['anh'] ?? "",
    );
  }

  Future<void> capNhat(
      int diem,
      int man,
      String taiKhoan,
      String tenTaiKhoan,
      String matKhau,
      bool quanLy,
      bool trangThai,
      String anh) async {
    DatabaseReference userReference =
        FirebaseDatabase.instance.ref().child('taiKhoan').child(taiKhoan);
    await userReference.update({
      'diem': diem,
      'man': man,
      'taiKhoan': taiKhoan,
      'tenTaiKhoan': tenTaiKhoan,
      'matKhau': matKhau,
      'quanLy': quanLy,
      'trangThai': trangThai,
      'anh': anh
    });
  }

  static Future<ctaiKhoan> fetchUser(String userId) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child("taiKhoan").child(userId);
    DatabaseEvent event = await reference.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      return ctaiKhoan.fromSnapshot(snapshot);
    } else {
      throw Exception("User not found");
    }
  }

  static Future<void> ThemTaiKhoan(String ten, String matKhau) async {
    final quanLy = false;
    final anh = '';
    final trangThai = true;
    final diem = 0;
    final man = 1;

    try {
      DatabaseReference productsRef =
          FirebaseDatabase.instance.ref().child('taiKhoan');

      String productId = productsRef.push().key!;

      Map<String, dynamic> productData = {
        'diem': diem,
        'man': man,
        'taiKhoan': ten,
        'tenTaiKhoan': ten,
        'anh': anh,
        'trangThai': trangThai,
        'quanLy': quanLy,
        'matKhau': matKhau,
      };

      await productsRef.child(productId).set(productData);
      print('Tài khoản đã được thêm thành công.');
    } catch (error) {
      print('Lỗi khi thêm tài khoản: $error');
      throw error;
    }
  }

  static Future<bool> kiemTraTaiKhoanTonTai(String ten) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('taiKhoan');
    DatabaseEvent event = await ref.orderByChild('taiKhoan').equalTo(ten).once();
    DataSnapshot snapshot = event.snapshot;

    return snapshot.value != null;
  }


//đăng nhập tài khoản 
  static Future<bool> dangNhap(String taiKhoan, String matKhau) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('taiKhoan');
    DatabaseEvent event = await ref.orderByChild('taiKhoan').equalTo(taiKhoan).once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;
      for (var user in userData.values) {
        if (user['matKhau'] == matKhau) {
          return true;
        }
      }
    }
    return false;
  }
}
