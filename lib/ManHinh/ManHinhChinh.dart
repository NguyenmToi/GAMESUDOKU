import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sudoku/ManHinh/ChonManChoi.dart';
import 'package:sudoku/ManHinh/LichSuChoi.dart';
import 'package:sudoku/ManHinh/ManHinhChoiMucDo.dart';
import 'package:sudoku/ManHinh/QuanLyManChoi.dart';
import 'package:sudoku/ManHinh/QuanLyThongTinCaNhan.dart';
import 'package:sudoku/ManHinh/ThongKe.dart';
import 'package:sudoku/ManHinh/XepHang.dart';
import 'package:sudoku/ManHinh/QuanLyTaiKhoan.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

class ManHinhChinh extends StatefulWidget {
  const ManHinhChinh({Key? key, required this.ttTaiKhoan}) : super(key: key);
  final ctaiKhoan ttTaiKhoan;

  @override
  State<ManHinhChinh> createState() => _ManHinhChinhState();
}

class _ManHinhChinhState extends State<ManHinhChinh> {
  int _currentIndex = 0;
  late Future<List<cmucDo>> _dsmucDo;

  @override
  void initState() {
    super.initState();
    _dsmucDo = cmucDo.dsMucDo();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void HienThiMucDo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<cmucDo>>(
          future: _dsmucDo,
          builder:
              (BuildContext context, AsyncSnapshot<List<cmucDo>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Không có dữ liệu'));
            } else {
              List<cmucDo> mucDos = snapshot.data!;
              mucDos.sort((a, b) => a.soan.compareTo(b.soan));
              return Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Mức độ chơi',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: mucDos.length,
                        itemBuilder: (context, index) {
                          cmucDo mucDo = mucDos[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                _navigateToManHinhChoiMucDo(mucDo);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                  child: Text(
                                    mucDo.tenmucdo,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
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
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //đặt màn hình không thể xoay ngang
    final List<Widget> _pages = [
      TrangChu(ttTaiKhoan: widget.ttTaiKhoan),
      const XepHang(),
      ThongKe(
        ttTaiKhoan: widget.ttTaiKhoan,
        key: UniqueKey(),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Màn Hình Chính',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Xếp Hạng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Thống Kê',
          ),
        ],
      ),
    );
  }

  void _navigateToManHinhChoiMucDo(cmucDo mucDo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Manhinhchoimucdo(
          mucdo: mucDo.tenmucdo,
          soan: mucDo.soan,
          diem: mucDo.diem,
          taikhoan: widget.ttTaiKhoan.taikhoan,
        ),
      ),
    );
  }

  void DuLieuLichSuCHoi() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LichSuaChoi(
          taikhoan: widget.ttTaiKhoan.taikhoan,
        ),
      ),
    );
  }
}

class TrangChu extends StatefulWidget {
  final ctaiKhoan ttTaiKhoan;

  TrangChu({Key? key, required this.ttTaiKhoan}) : super(key: key);

  @override
  _TrangChuState createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  File? anh;
  String? dulieuanh;
  bool nhan = false;
  String? duongdananh;
  String? anhhienthi;
  final databaseReference = FirebaseDatabase.instance.reference();
  Future<void> _chonAnh() async {
    if (nhan) {
      return;
    }
    nhan = true; // đang trong quá trình chọn ảnh

    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        FirebaseStorage storage = FirebaseStorage.instance;

        if (duongdananh != null && duongdananh!.isNotEmpty) {
          try {
            await storage.ref('anh/anhsukiensudoku').delete();
          } catch (error) {
            SnackBar(content: Text('Lỗi xóa ảnh: $error'));
          }
        }

        File imageFile = File(pickedFile.path);
        Uint8List imageBytes = await imageFile.readAsBytes();

        Reference reference = storage.ref().child('anh/anhsukiensudoku');
        await reference.putData(imageBytes);
        setState(() {});
      }
    } catch (e) {
      print('Lỗi khi chọn ảnh: $e');
    } finally {
      nhan = false; // quá trình chọn ảnh đã kết thúc
    }
  }

  Future<String> taiAnhSuKien() async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('anh/anhsukiensudoku');
      return await storageReference.getDownloadURL();
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(3, 25, 3, 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuanLyThongTinCaNhan(
                              taikhoan: widget.ttTaiKhoan.taikhoan,
                              anh: widget.ttTaiKhoan.anh,
                              diem: widget.ttTaiKhoan.diem,
                              man: widget.ttTaiKhoan.man,
                              tentaikhoan: widget.ttTaiKhoan.tentaikhoan,
                              matkhau: widget.ttTaiKhoan.matkhau,
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(widget.ttTaiKhoan.anh!),
                        backgroundColor: Colors.black,
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.ttTaiKhoan.tentaikhoan,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Màn ${widget.ttTaiKhoan.man}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              widget.ttTaiKhoan.quanly
                  ? IconButton(
                      icon: Icon(
                        Icons.settings,
                        size: 35,
                        color: Colors.green[200],
                      ),
                      onPressed: () {
                        hienThiHuongDan(context);
                      },
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.question_mark,
                        size: 35,
                        color: Colors.green[200],
                      ),
                      onPressed: () {
                        hienThiHuongDan(context);
                      },
                    )
            ],
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SUDOKU',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                FutureBuilder<String>(
                  future: taiAnhSuKien(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Image.asset(
                            'assets/image/logo.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data!),
                            fit: BoxFit.fill,
                          ),
                          border: Border.all(color: Colors.grey),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 75),
                if (widget.ttTaiKhoan.quanly == true)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuanLyManChoi(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      minimumSize: Size(280, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('Quản lý màn chơi',
                        style: TextStyle(fontSize: 20)),
                  ),
                const SizedBox(height: 15),
                if (widget.ttTaiKhoan.quanly == true)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuanLyTaiKhoan(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      minimumSize: Size(280, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('Quản lý tài khoản',
                        style: TextStyle(fontSize: 20)),
                  ),
                if (widget.ttTaiKhoan.quanly)
                  const SizedBox(height: 15)
                else
                  const SizedBox(height: 130),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChonManChoi(
                          man: widget.ttTaiKhoan.man,
                          matkhau: widget.ttTaiKhoan.matkhau,
                          taikhoan: widget.ttTaiKhoan.taikhoan,
                          ttsovandachoi: widget.ttTaiKhoan.ttsovandachoi,
                          ttsovanthangkhongloi:
                              widget.ttTaiKhoan.ttsovanthangkhongloi,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size(280, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text('Chọn màn', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    // Sử dụng hàm showDifficultyLevels thông qua _ManHinhChinhState
                    (context.findAncestorStateOfType<_ManHinhChinhState>())
                        ?.HienThiMucDo(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    minimumSize: Size(280, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child:
                      const Text('Ngẫu nhiên', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> hienThiHuongDan(BuildContext context) async {
    TextEditingController _noiDungcontroller = TextEditingController();

    // Tham chiếu đến Firebase Realtime Database
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('huongdanchoi/noidung');

    // Lấy dữ liệu từ Firebase Realtime Database
    DataSnapshot snapshot = await reference.get();

    // Trích xuất dữ liệu và đặt vào controller
    if (snapshot.value != null) {
      Map<String, dynamic> dulieu =
          Map<String, dynamic>.from(snapshot.value as Map);
      _noiDungcontroller.text = dulieu['noidung'] ?? '';
    } else {
      _noiDungcontroller.text = '';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Hướng dẫn Chơi'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _noiDungcontroller,
                      readOnly: widget.ttTaiKhoan.quanly ? false : true,
                      maxLines: null, // Cho phép nhiều dòng
                      decoration: InputDecoration(
                        hintText: 'Nhập nội dung hướng dẫn chơi',
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Đổi ảnh sự kiện'),
                  onPressed: () {
                    _chonAnh();
                    Navigator.pop(context);
                  },
                ),
                if (widget.ttTaiKhoan.quanly)
                  TextButton(
                    child: Text('Cập nhật'),
                    onPressed: () async {
                      await reference.set({'noidung': _noiDungcontroller.text});
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
