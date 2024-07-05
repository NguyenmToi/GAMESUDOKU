import 'dart:math';

import 'package:firebase_database/firebase_database.dart';

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

// thử thách
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

class cmucDo {
  String key;
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
      diem: json['diem'] is int
          ? json['diem']
          : int.tryParse(json['diem'].toString()) ?? 0,
    );
  }

  static Future<void> themMucDoChoi(
      int mamucdo, String tenmucdo, int soan, int diem) async {
    try {
      DatabaseReference dtrMucDo =
          FirebaseDatabase.instance.ref().child('mucdo');

      String manId = dtrMucDo.push().key!;

      Map<String, dynamic> DuLieuMucDo = {
        'mamucdo': mamucdo,
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

  static Future<void> capNhatMucDoChoi(
      int mamucdo, String tenmucdo, int soan, int diem) async {
    try {
      DatabaseReference dtrMucDo =
          FirebaseDatabase.instance.reference().child('mucdo');

      // Tìm mức độ chơi cần cập nhật dựa trên mamucdo
      List<cmucDo> danhSachMucDo = await dsMucDo();
      String? idCanCapNhat;

      for (int i = 0; i < danhSachMucDo.length; i++) {
        if (danhSachMucDo[i].mamucdo == mamucdo) {
          idCanCapNhat =
              danhSachMucDo[i].key; // Sử dụng key của mức độ để cập nhật
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

    int MaLonNhat =
        lmucdo.map((mucdo) => mucdo.mamucdo).reduce((a, b) => a > b ? a : b);
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

class ctaiKhoan {
  int diem;
  int man;
  String taikhoan;
  String tentaikhoan;
  String matkhau;
  bool quanly;
  bool trangthai;
  String anh;
  int mdsovandachoi;
  int mdsovanthang;
  int mdsovanthangkhongloi;

  ctaiKhoan({
    required this.diem,
    required this.man,
    required this.taikhoan,
    required this.tentaikhoan,
    required this.matkhau,
    required this.quanly,
    required this.trangthai,
    required this.anh,
    required this.mdsovandachoi,
    required this.mdsovanthang,
    required this.mdsovanthangkhongloi
  });

  factory ctaiKhoan.fromMap(Map<dynamic, dynamic> data) {
    return ctaiKhoan(
      diem: data['diem'] ?? 0,
      man: data['man'] ?? 0,
      taikhoan: data['taikhoan'] ?? "",
      tentaikhoan: data['tentaikhoan'] ?? "",
      matkhau: data['matkhau'] ?? "",
      quanly: data['quanly'] ?? false,
      trangthai: data['trangthai'] ?? true,
      mdsovandachoi: data['mucdosovandachoi']?? 0,
      mdsovanthang: data['mucdosovanthang']?? 0,
      mdsovanthangkhongloi: data['mucdosovanthangkhongloi']?? 0,
      anh: data['anh'] ?? "",
    );
  }

static Future<bool> kiemTraTrangThaiTaiKhoan(String taikhoan) async {
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("taikhoan").child(taikhoan);
    DatabaseEvent event = await reference.once();
    DataSnapshot snapshot = event.snapshot;
    
    if (snapshot.value != null) {
    Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;
    ctaiKhoan TaiKhoan = ctaiKhoan.fromMap(map);
      return TaiKhoan.trangthai;
    } else {
      throw Exception("Không lấy được tài khoản");
    }
}

 static Future<List<ctaiKhoan>> layTatCaTaiKhoan() async {
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("taikhoan");
    DatabaseEvent event = await reference.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      List<ctaiKhoan> accounts = [];
      Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;
      map.forEach((key, value) {
        ctaiKhoan account = ctaiKhoan.fromMap(value);
        if (!account.quanly) {
          accounts.add(account);
        }
      });
      return accounts;
    } else {
      throw Exception("không lấy được dữ liệu");
    }
  }

  Future<void> capNhat(int diem, int man, String taikhoan, String tentaikhoan,
      String matkhau, bool quanly, bool trangthai, String anh) async {
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

static Future<void> capNhatDiem(String taikhoan, int diemMoi) async {
    DatabaseReference userReference =
        FirebaseDatabase.instance.ref().child('taikhoan').child(taikhoan);
    await userReference.update({
      'diem': diemMoi,
    });
}
static Future<int> layDiemTaiKhoan(String taikhoan) async {
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('taikhoan').child(taikhoan);
  DatabaseEvent event = await reference.once();
  DataSnapshot snapshot = event.snapshot;

  if (snapshot.value != null) {
    Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;
    ctaiKhoan TaiKhoan = ctaiKhoan.fromMap(map);
      return TaiKhoan.diem;
  } else {
    throw Exception("Không lấy được dữ liệu");
  }
}

static Future<void> capNhatTrangThai(String taikhoan, bool trangThaiMoi) async {
  DatabaseReference userReference =
      FirebaseDatabase.instance.ref().child('taikhoan').child(taikhoan);
  
  try {
    await userReference.update({
      'trangthai': trangThaiMoi,
    });
    print('Đã cập nhật trạng thái thành công cho tài khoản $trangThaiMoi, $taikhoan');
  } catch (e) {
    print('Lỗi khi cập nhật trạng thái của tài khoản $trangThaiMoi ,$taikhoan: $e');
    throw Exception('Không thể cập nhật trạng thái của tài khoản $taikhoan');
  }
}

  static Future<void> ThemTaiKhoan(String taikhoan, String matkhau) async {
    final quanly = false;
    final anh = '';
    final trangthai = true;
    final diem = 0;
    final man = 1;
    final mdsovandachoi = 0;
    final mdsovanthang = 0;
    final mdsovanthangkhongloi = 0;
    try {
      DatabaseReference productsRef =
          FirebaseDatabase.instance.ref().child('taikhoan');

      String mataikhoan = taikhoan;

      Map<String, dynamic> dulieu = {
        'diem': diem,
        'man': man,
        'taikhoan': taikhoan,
        'tentaikhoan': taikhoan,
        'anh': anh,
        'trangthai': trangthai,
        'quanly': quanly,
        'matkhau': matkhau,
        'mucdosovandachoi': mdsovandachoi,
        'mucdosovanthang': mdsovanthang,
        'mucdosovanthangkhongloi': mdsovanthangkhongloi,
      };

      await productsRef.child(mataikhoan).set(dulieu);
      print('Tài khoản đã được thêm thành công.');
    } catch (error) {
      print('Lỗi khi thêm tài khoản: $error');
      throw error;
    }
  }

  static Future<bool> kiemTraTaiKhoanTonTai(String ten) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('taikhoan');
    DatabaseEvent event =
        await ref.orderByChild('taikhoan').equalTo(ten).once();
    DataSnapshot snapshot = event.snapshot;

    return snapshot.value != null;
  }

//đăng nhập tài khoản
  static Future<bool> dangNhap(String taiKhoan, String matKhau) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('taikhoan');
    DatabaseEvent event =
        await ref.orderByChild('taikhoan').equalTo(taiKhoan).once();
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

  static Future<ctaiKhoan?> thongTindangNhap(
      String taiKhoan, String matKhau) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('taikhoan');
    DatabaseEvent event =
        await ref.orderByChild('taikhoan').equalTo(taiKhoan).once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;
      for (var user in userData.values) {
        if (user['matkhau'] == matKhau) {
          // Tạo đối tượng ctaiKhoan từ dữ liệu Firebase
          return ctaiKhoan(
            diem: user['diem'] ?? 0,
            man: user['man'] ?? 0,
            taikhoan: user['taikhoan'] ?? "",
            tentaikhoan: user['tentaikhoan'] ?? "",
            matkhau: user['matkhau'] ?? "",
            quanly: user['quanly'] ?? false,
            trangthai: user['trangthai'] ?? true,
            mdsovandachoi: user['mucdosovandachoi']?? 0,
            mdsovanthang: user['mucdosovanthang']?? 0,
            mdsovanthangkhongloi: user['mucdosovanthangkhongloi']?? 0,
            anh: user['anh'] ?? "",
          );
        }
      }
    }
    return null;
  }

  static Future<List<ctaiKhoan>> layDSTaiKhoan({required bool SapXepDiem}) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('taikhoan');
  DatabaseEvent event = await ref.once();
  DataSnapshot snapshot = event.snapshot;

  List<ctaiKhoan> accounts = [];
  if (snapshot.value != null) {
    Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
    data.forEach((key, value) {
      ctaiKhoan account = ctaiKhoan(
        diem: value['diem'] ?? 0,
        man: value['man'] ?? 0,
        taikhoan: value['taikhoan'] ?? "",
        tentaikhoan: value['tentaikhoan'] ?? "",
        matkhau: value['matkhau'] ?? "",
        quanly: value['quanly'] ?? false,
        trangthai: value['trangthai'] ?? true,
        mdsovandachoi: value['mucdosovandachoi']?? 0,
        mdsovanthang: value['mucdosovanthang']?? 0,
        mdsovanthangkhongloi: value['mucdosovanthangkhongloi']?? 0,
        anh: value['anh'] ?? "",
      );
      accounts.add(account);
    });

    if (SapXepDiem) {
      accounts.sort((a, b) => b.diem.compareTo(a.diem));
    } else {
      accounts.sort((a, b) => b.man.compareTo(a.man));
    }
  }

  return accounts.take(10).toList();
}

static Future<void> capNhatSoVanDaChoi(String taikhoan, int soVanChoiMoi) async {
  DatabaseReference userReference =
      FirebaseDatabase.instance.ref().child('taikhoan').child(taikhoan);
  DatabaseEvent event = await userReference.once();
  DataSnapshot snapshot = event.snapshot;

  if (snapshot.value != null) {
    Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;
    int soVanChoiHienTai = map['mucdosovandachoi'] ?? 0;
    int tongSoVanChoi = soVanChoiHienTai + soVanChoiMoi;
    await userReference.update({
      'mucdosovandachoi': tongSoVanChoi,
    });
    DatabaseEvent updatedEvent = await userReference.once();
    DataSnapshot updatedSnapshot = updatedEvent.snapshot;

    if (updatedSnapshot.value != null) {
      Map<dynamic, dynamic> updatedMap = updatedSnapshot.value as Map<dynamic, dynamic>;
      ctaiKhoan TaiKhoan = ctaiKhoan.fromMap(updatedMap);
      print('Số ván chơi của tài khoản $taikhoan là ${TaiKhoan.mdsovandachoi}');
    } else {
      throw Exception("Không lấy được dữ liệu sau khi cập nhật");
    }
  } else {
    throw Exception("Không lấy được dữ liệu ban đầu");
  }
}

static Future<void> capNhatSoVanDaChoiThang(String taikhoan, int soVanChoiThangMoi) async {
  DatabaseReference userReference =
      FirebaseDatabase.instance.ref().child('taikhoan').child(taikhoan);
  DatabaseEvent event = await userReference.once();
  DataSnapshot snapshot = event.snapshot;

  if (snapshot.value != null) {
    Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;
    int soVanChoiThangHienTai = map['mucdosovanthang'] ?? 0;
    int tongSoVanChoiThang = soVanChoiThangHienTai + soVanChoiThangMoi;
    await userReference.update({
      'mucdosovanthang': tongSoVanChoiThang,
    });
    DatabaseEvent updatedEvent = await userReference.once();
    DataSnapshot updatedSnapshot = updatedEvent.snapshot;

    if (updatedSnapshot.value != null) {
      Map<dynamic, dynamic> updatedMap = updatedSnapshot.value as Map<dynamic, dynamic>;
      ctaiKhoan TaiKhoan = ctaiKhoan.fromMap(updatedMap);
      print('Số ván chơi của tài khoản $taikhoan là ${TaiKhoan.mdsovanthang}');
    } else {
      throw Exception("Không lấy được dữ liệu sau khi cập nhật");
    }
  } else {
    throw Exception("Không lấy được dữ liệu ban đầu");
  }
}

static Future<void> capNhatSoVanDaChoiThangKhongLoi(String taikhoan, int soVanChoiThangKhongLoiMoi) async {
  DatabaseReference userReference =
      FirebaseDatabase.instance.ref().child('taikhoan').child(taikhoan);
  DatabaseEvent event = await userReference.once();
  DataSnapshot snapshot = event.snapshot;

  if (snapshot.value != null) {
    Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;
    int soVanChoiThangKhongLoiHienTai = map['mucdosovanthangkhongloi'] ?? 0;
    int tongSoVanChoiThangKhongLoi = soVanChoiThangKhongLoiHienTai + soVanChoiThangKhongLoiMoi;
    await userReference.update({
      'mucdosovanthangkhongloi': tongSoVanChoiThangKhongLoi,
    });
    DatabaseEvent updatedEvent = await userReference.once();
    DataSnapshot updatedSnapshot = updatedEvent.snapshot;

    if (updatedSnapshot.value != null) {
      Map<dynamic, dynamic> updatedMap = updatedSnapshot.value as Map<dynamic, dynamic>;
      ctaiKhoan TaiKhoan = ctaiKhoan.fromMap(updatedMap);
      print('Số ván chơi của tài khoản $taikhoan là ${TaiKhoan.mdsovanthangkhongloi}');
    } else {
      throw Exception("Không lấy được dữ liệu sau khi cập nhật");
    }
  } else {
    throw Exception("Không lấy được dữ liệu ban đầu");
  }
}

}

//hàm giải trò chơi
class GiaiSudoku {
  final List<List<int>> bang;

  GiaiSudoku(this.bang);

  bool giai() {
    for (int dong = 0; dong < 9; dong++) {
      for (int cot = 0; cot < 9; cot++) {
        if (bang[dong][cot] == 0) {
          for (int so = 1; so <= 9; so++) {
            if (ktHopLe(dong, cot, so)) {
              bang[dong][cot] = so;
              if (giai()) {
                return true;
              }
              bang[dong][cot] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  bool ktHopLe(int dong, int cot, int so) {
    // Kiểm tra dòng
    for (int i = 0; i < 9; i++) {
      if (bang[dong][i] == so) {
        return false;
      }
    }

    // Kiểm tra cột
    for (int i = 0; i < 9; i++) {
      if (bang[i][cot] == so) {
        return false;
      }
    }

    // Kiểm tra ô 3x3
    int batDauDong = dong - dong % 3;
    int batDauCot = cot - cot % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (bang[i + batDauDong][j + batDauCot] == so) {
          return false;
        }
      }
    }

    return true;
  }
}

//kiểm tra màn chơi đã tồn tại chưa
Future<bool> kiemTraManChoi(String maman) async {
  DatabaseEvent event = await FirebaseDatabase.instance
      .reference()
      .child('thuthach')
      .orderByKey()
      .equalTo(maman)
      .once();

  DataSnapshot snapshot = event.snapshot;

  return snapshot.value != null;
}

class cMucDoChoiNgauNhien {
  late String taikhoan;
  late String tenman;
  late int soloi;
  late DateTime ngay;
  late int thoigian;
  late int diem;
  late List<List<int>> bang;

  cMucDoChoiNgauNhien({
    this.taikhoan = "",
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
      taikhoan: json['taikhoan'] ?? "",
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
      'taikhoan': taikhoan,
      'tenman': tenman,
      'soloi': soloi,
      'ngay': ngay.toIso8601String(),
      'thoigian': thoigian,
      'diem': diem,
      'bang': bang,
    };
  }

  static Future<void> themManChoiNgauNhien(String taikhoan,String tenman, int soloi,
      DateTime ngay, int thoigian, int diem, List<List<int>> bang) async {
    try {
      DatabaseReference manRef =
          FirebaseDatabase.instance.ref().child('manchoingaunhien');

       String ManID = taikhoan + Random().nextInt(100000).toString().padLeft(8, '0');
       
      Map<String, dynamic> manData = {
      'taikhoan': taikhoan,
        'tenman': tenman,
        'soloi': soloi,
        'ngay': ngay.toIso8601String(),
        'thoigian': thoigian,
        'diem': diem,
        'bang': bang,
      };

      await manRef.child(ManID).set(manData);
      print('Mục đã được thêm thành công.');
    } catch (error) {
      print('Lỗi khi thêm mục: $error');
      throw error;
    }
  }
  
  static DatabaseReference dsManChoiNgauNhien() {
    return FirebaseDatabase.instance.ref().child('manchoingaunhien');
  }
static Future<List<cMucDoChoiNgauNhien>> taiDanhSachMan(String taiKhoan) async {
  DatabaseReference reference = dsManChoiNgauNhien();
  DatabaseEvent event = await reference.once();
  DataSnapshot dataSnapshot = event.snapshot;
  Map<dynamic, dynamic>? values = dataSnapshot.value as Map<dynamic, dynamic>?;

  List<cMucDoChoiNgauNhien> man = [];
  if (values != null) {
  values.forEach((key, value) {
    cMucDoChoiNgauNhien ManID = cMucDoChoiNgauNhien.fromJson(key, value);
    if (ManID.taikhoan.replaceAll(RegExp(r'[0-9]'), '') == taiKhoan) {
      String updatedTaikhoan = ManID.taikhoan.replaceFirst(RegExp(r'\d{8}$'), '');
      ManID.taikhoan = updatedTaikhoan;
      man.add(ManID);
    }
  });
}
  return man;
}

}