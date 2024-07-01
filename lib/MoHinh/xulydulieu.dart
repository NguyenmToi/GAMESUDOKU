import 'dart:convert';
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
  String key; // Firebase key
  int mamucdo;
  String tenmucdo;
  int soan;
  int diem;

  cmucDo({
    required this.key,
    required this.mamucdo,
    required this.tenmucdo,
    required this.soan,
    required this.diem,
  });

  factory cmucDo.fromJson(String key, Map<dynamic, dynamic> json) {
    return cmucDo(
      key: key,
      mamucdo: json['mamucdo'] ?? 0,
      tenmucdo: json['tenmucdo'] ?? "",
      soan: json['soan'] ?? 0,
      diem: json['diem'] is int ? json['diem'] : int.tryParse(json['diem'].toString()) ?? 0,
    );
  }

  static Future<void> themMucDoChoi(int mamucdo,String tenmucdo, int soan, int diem) async {
  try {
    DatabaseReference dtrMucDo = FirebaseDatabase.instance.ref().child('mucdo');

    String manId = dtrMucDo.push().key!;

    Map<String, dynamic> DuLieuMucDo = {
      'mamucdo':mamucdo,
      'tenmucdo': tenmucdo,
      'soan': soan,
      'diem': diem,
    };

    await dtrMucDo.child(manId).set(DuLieuMucDo);
    print('Mục đã được thêm thành công.');
  } catch (error) {
    print('Lỗi khi thêm mục: $error');
    throw error;
  }
}
static Future<void> capNhatMucDoChoi(int mamucdo, String tenmucdo, int soan, int diem) async {
  try {
    DatabaseReference dtrMucDo = FirebaseDatabase.instance.reference().child('mucdo');

    // Tìm mức độ chơi cần cập nhật dựa trên mamucdo
    List<cmucDo> danhSachMucDo = await dsMucDo();
    String? idCanCapNhat;

    for (int i = 0; i < danhSachMucDo.length; i++) {
      if (danhSachMucDo[i].mamucdo == mamucdo) {
        idCanCapNhat = danhSachMucDo[i].key; // Sử dụng key của mức độ để cập nhật
        break;
      }
    }

    if (idCanCapNhat == null) {
      print('Không tìm thấy mức độ để cập nhật.');
      return;
    }

    // Chuẩn bị dữ liệu cập nhật
    Map<String, dynamic> duLieuMucDo = {
      'tenmucdo': tenmucdo,
      'soan': soan,
      'diem': diem.toString(),
    };

    // Thực hiện cập nhật
    await dtrMucDo.child(idCanCapNhat).update(duLieuMucDo);
    print('Mức độ đã được cập nhật thành công.');
  } catch (error) {
    print('Lỗi khi cập nhật mức độ: $error');
    throw error;
  }
}





 static Future<int> LayMaMucDoLonNhat() async {
    List<cmucDo> lmucdo = await dsMucDo();
    if (lmucdo.isEmpty) {
      return 0;
    }

    int MaLonNhat = lmucdo.map((mucdo) => mucdo.mamucdo).reduce((a, b) => a > b ? a : b);
    return MaLonNhat;
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
  late int soloi;
  late int sogoiy;
  late int thoigian;
  late List<List<int>> bang;
  late List<List<int>> banggiai;

  cManThuThach(
      {required this.maman,
      required this.tenman,
      this.soloi = 0,
      this.sogoiy = 0,
      this.thoigian = 0,
      required this.bang,
      required this.banggiai});

  factory cManThuThach.fromJson(String key, Map<dynamic, dynamic> json) {
    List<List<int>> bang = (json['bang'] as List<dynamic>? ?? [])
        .map((row) => (row as List<dynamic>? ?? [])
            .map((cell) => cell as int? ?? 0)
            .toList())
        .toList();
    List<List<int>> banggiai = (json['banggiai'] as List<dynamic>? ?? [])
        .map((row) => (row as List<dynamic>? ?? [])
            .map((cell) => cell as int? ?? 0)
            .toList())
        .toList();

    return cManThuThach(
        maman: json['maman'] ?? 0,
        tenman: json['tenman'] ?? "",
        soloi: json['soloi'] ?? 0,
        sogoiy: json['sogoiy'] ?? 0,
        thoigian: json['thoigian'] ?? 0,
        bang: bang,
        banggiai: banggiai);
  }

  Map<String, dynamic> toJson() {
    return {
      'maman': maman,
      'tenman': tenman,
      'soloi': soloi,
      'sogoiy': sogoiy,
      'thoigian': thoigian,
      'board': bang.map((row) => row.map((cell) => cell).toList()).toList(),
    };
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



class cMucDoChoiNgauNhien {
  late String tenman;
  late int soloi;
  late DateTime ngay;
  late int thoigian;
  late int diem;
  late List<List<int>> bang;

  cMucDoChoiNgauNhien({
    required this.tenman,
    this.soloi = 0,
    required this.ngay,
    this.thoigian = 0,
    this.diem = 0,
    required this.bang,
  });

  factory cMucDoChoiNgauNhien.fromJson(String key, Map<dynamic, dynamic> json) {
    List<List<int>> bang = (json['bang'] as List<dynamic>? ?? [])
        .map((row) => (row as List<dynamic>? ?? [])
            .map((cell) => cell as int? ?? 0)
            .toList())
        .toList();

    return cMucDoChoiNgauNhien(
      tenman: json['tenman'] ?? "",
      soloi: json['soloi'] ?? 0,
      ngay: json['ngay'] != null ? DateTime.parse(json['ngay']) : DateTime.now(),
      thoigian: json['thoigian'] ?? 0,
      diem: json['diem'] ?? 0,
      bang: bang,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenman': tenman,
      'soloi': soloi,
      'ngay': ngay.toIso8601String(),
      'thoigian': thoigian,
      'diem': diem,
      'bang': bang,
    };
  }

 static Future<void> themManChoiNgauNhien(String tenman, int soloi, DateTime ngay, int thoigian, int diem, List<List<int>> bang) async {
  try {
    DatabaseReference manRef = FirebaseDatabase.instance.ref().child('manchoingaunhien');

    String manId = manRef.push().key!; // Tạo khóa ngẫu nhiên cho mỗi mục

    Map<String, dynamic> manData = {
      'tenman': tenman,
      'soloi': soloi,
      'ngay': ngay.toIso8601String(),
      'thoigian': thoigian,
      'diem': diem,
      'bang': bang,
    };

    await manRef.child(manId).set(manData);
    print('Mục đã được thêm thành công.');
  } catch (error) {
    print('Lỗi khi thêm mục: $error');
    throw error;
  }
}
  static DatabaseReference dsManChoiNgauNhien() {
    return FirebaseDatabase.instance.ref().child('manchoingaunhien');
  }

  static Future<List<cMucDoChoiNgauNhien>> taiDanhSachMan() async {
    DatabaseReference reference = dsManChoiNgauNhien();
    DatabaseEvent event = await reference.once();
    DataSnapshot dataSnapshot = event.snapshot;
    Map<dynamic, dynamic>? values =
        dataSnapshot.value as Map<dynamic, dynamic>?;

    List<cMucDoChoiNgauNhien> man = [];
    if (values != null) {
      values.forEach((key, value) {
        man.add(cMucDoChoiNgauNhien.fromJson(key, value));
      });
    }
    return man;
  }
}