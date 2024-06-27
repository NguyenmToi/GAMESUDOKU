import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/TaoDoKho.dart';

class ManHinhChoiThuThach extends StatefulWidget {
  const ManHinhChoiThuThach(
      {super.key,
      required this.tenMan,
      required this.bang,
      required this.soloi,
      required this.goiy,
      required this.thoigian});
  final List bang;
  final String tenMan;
  final int soloi;
  final int thoigian;
  final int goiy;

  @override
  State<ManHinhChoiThuThach> createState() => _ManHinhChoiThuThachState();
}

class _ManHinhChoiThuThachState extends State<ManHinhChoiThuThach> {
  late int giay = widget.thoigian;
  late Timer thoiGian;
  int? hangDuocChon;
  int? cotDuocChon;

  @override
  void initState() {
    super.initState();
    batDauThoiGian();
  }

  void batDauThoiGian() {
    const motGiay = Duration(seconds: 1);
    thoiGian = Timer.periodic(motGiay, (Timer thoiGian) {
      setState(() {
        if (giay <= 0) {
          thoiGian.cancel();
          thongBaoThua();
        } else {
          giay--;
        }
      });
    });
  }

  @override
  void dispose() {
    thoiGian.cancel();
    super.dispose();
  }

  String dinhDangThoiGian(int timeInSeconds) {
    int phut = timeInSeconds ~/ 60;
    int giay = timeInSeconds % 60;
    return '${phut.toString().padLeft(1, '0')}:${giay.toString().padLeft(2, '0')}';
  }

  List<List<int>> bangSudoku =
      List.generate(9, (_) => List.generate(9, (_) => 0));

  void xuLyChonO(int hang, int cot) {
    setState(() {
      hangDuocChon = hang;
      cotDuocChon = cot;
    });
  }

  // void xuLyChonSo(int so) {
  //   if (hangDuocChon != null && cotDuocChon != null) {
  //     setState(() {
  //       widget.bang[hangDuocChon!][cotDuocChon!] = so;
  //       hangDuocChon = null;
  //       cotDuocChon = null;
  //     });
  //   }
  // }

  void xuLyChonSo(int so) {
    if (hangDuocChon != null && cotDuocChon != null) {
      // Kiểm tra nếu ô đang chọn là ô có giá trị 0 (chưa có giá trị từ Firebase)
      if (widget.bang[hangDuocChon!][cotDuocChon!] == 0) {
        setState(() {
          widget.bang[hangDuocChon!][cotDuocChon!] = so;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[200], // Màu nền appbar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.grey,
          onPressed: () {
            thongBaoThoat();
          },
        ),
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right: 38.0),
                child: Text(
                  widget.tenMan,
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 40, 5, 60),
        child: Stack(
          children: [
            Column(
              children: [
                Text(
                  'SUDOKU',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.error, size: 18),
                        const SizedBox(width: 5),
                        Text(widget.soloi.toString(),
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.lightbulb, size: 18),
                        const SizedBox(width: 5),
                        Text(widget.goiy.toString(),
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          dinhDangThoiGian(giay),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                        ),
                      ],
                    )
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 9, // số lượng cột trong lưới
                      childAspectRatio: 1, // tỉ lệ giữa chiều rộng và cao
                    ),
                    itemBuilder: (context, index) {
                      int hang = index ~/ 9; // lấy chỉ số hàng, chia lấy nguyên
                      int cot = index % 9; // lấy chỉ số cột, chia lấy dư
                      bool duocChon =
                          hang == hangDuocChon && cot == cotDuocChon;

                      Border border = Border(
                        top: BorderSide(
                          color: hang == 0
                              ? Colors.black
                              : (hang % 3 == 0)
                                  ? Colors.black
                                  : Colors.grey,
                          width: hang == 0 ? 1.0 : 1.0,
                        ),
                        left: BorderSide(
                          color: cot == 0
                              ? Colors.black
                              : (cot % 3 == 0)
                                  ? Colors.black
                                  : Colors.grey,
                          width: cot == 0 ? 1.0 : 1.0,
                        ),
                        bottom: BorderSide(
                          color: hang == 8
                              ? Colors.black
                              : ((hang + 1) % 3 == 0)
                                  ? Colors.black
                                  : Colors.grey,
                          width: hang == 8 ? 1.0 : 1.0,
                        ),
                        right: BorderSide(
                          color: cot == 8
                              ? Colors.black
                              : ((cot + 1) % 3 == 0)
                                  ? Colors.black
                                  : Colors.grey,
                          width: cot == 8 ? 1.0 : 1.0,
                        ),
                      );

                      return InkWell(
                        onTap: () {
                          if (widget.bang != null &&
                              hang < widget.bang.length &&
                              widget.bang[hang] != null &&
                              cot < widget.bang[hang].length &&
                              widget.bang[hang][cot] == 0) {
                            xuLyChonO(hang, cot);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: duocChon ? Colors.blue[100] : null,
                            border: border,
                          ),
                          child: Center(
                            child: Text(
                              widget.bang != null &&
                                      hang < widget.bang.length &&
                                      widget.bang[hang] != null &&
                                      cot < widget.bang[hang].length &&
                                      widget.bang[hang][cot] != 0
                                  ? widget.bang[hang][cot].toString()
                                  : '',
                              style: const TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: 81,
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 1; i <= 5; i++) xayDungSo(i),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 6; i <= 9; i++) xayDungSo(i),
                        Ink(
                            height: 45,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              child: IconButton(
                                onPressed: () {},
                                color: Colors.black,
                                icon: const Icon(Icons.lightbulb_outline_sharp),
                              ),
                            )),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void thongBaoThua() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Trò chơi kết thúc',
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          content: const Text('Bạn đã thua, bạn có muốn chơi lại không ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Thoát'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Đồng ý'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManHinhChoiThuThach(
                      tenMan: widget.tenMan,
                      bang: widget.bang,
                      soloi: widget.soloi,
                      thoigian: widget.thoigian,
                      goiy: widget.goiy,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void thongBaoThoat() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Thoát trò chơi',
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          content:
              const Text('Thoát sẽ hủy kết quả, bạn có muốn thoát không ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Đồng ý'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ở lại'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget xayDungSo(int so) {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          if (so != 0) {
            // Kiểm tra nếu số khác 0 thì mới cho phép chọn
            xuLyChonSo(so);
          }
        },
        child: Container(
          width: 60,
          height: 45,
          alignment: Alignment.center,
          child: Text(
            so.toString(),
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
