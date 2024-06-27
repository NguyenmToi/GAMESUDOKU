import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/LichSuChoi.dart';

class ManHinhChoiThuThach extends StatefulWidget {
  const ManHinhChoiThuThach(
      {super.key,
      required this.tenMan,
      required this.bang,
      required this.banggiai,
      required this.soloi,
      required this.goiy,
      required this.thoigian});
  final List bang;
  final List banggiai;
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
  late List<List<Color>> mauSo;
  late int soloi = widget.soloi;
  late int goiy = widget.goiy;
  int hangDuocChon = -1;
  int cotDuocChon = -1;

  @override
  void initState() {
    super.initState();
    batDauThoiGian();
    mauSo = List.generate(
      widget.bang.length,
      (i) => List.generate(widget.bang[i].length, (j) => Colors.white),
    );
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

  // @override
  // void dispose() {
  //   thoiGian.cancel();
  //   super.dispose();
  // }

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

  void xuLyNhapSo(int so) {
    if (hangDuocChon != -1 && cotDuocChon != -1) {
      setState(() {
        widget.bang[hangDuocChon][cotDuocChon] = so;

        // So sánh số nhập vào với đáp án
        if (so == widget.banggiai[hangDuocChon][cotDuocChon]) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đúng!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1), // Thời gian hiển thị SnackBar
            ),
          );
          mauSo[hangDuocChon][cotDuocChon] = Colors.green;
        } else {
          // Số nhập vào sai
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sai!'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1),
            ),
          );
          mauSo[hangDuocChon][cotDuocChon] = Colors.red;
          setState(() {
            if (soloi == 0) {
              thongBaoThua();
            } else {
              soloi -= 1;
            }

            widget.bang[hangDuocChon][cotDuocChon] = 0;
          });
        }
        kiemTraBangHoanThanh();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[200],
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
        child: Column(
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
                    const Icon(
                      Icons.error,
                      size: 20,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 5),
                    Text(soloi.toString(),
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.lightbulb, size: 20),
                    const SizedBox(width: 5),
                    Text(goiy.toString(), style: const TextStyle(fontSize: 20)),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      dinhDangThoiGian(giay),
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                )
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  int hang = index ~/ 9;
                  int cot = index % 9;
                  bool duocChon = hang == hangDuocChon && cot == cotDuocChon;

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
                        color: duocChon ? Colors.blue[100] : mauSo[hang][cot],
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
                          onPressed: () {
                            widget.bang[hangDuocChon][cotDuocChon] =
                                widget.banggiai[hangDuocChon][cotDuocChon];
                            if (goiy <= 0) {
                              thongBaoHetGoiY();
                            } else {
                              goiy -= 1;
                            }
                          },
                          color: Colors.black,
                          icon: const Icon(Icons.lightbulb_outline_sharp),
                        ),
                      ),
                    ),
                  ],
                ),
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
                Navigator.of(context).pop();
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
                      banggiai: widget.banggiai,
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

  void thongBaoHetGoiY() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Hết gợi ý',
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          content: const Text('Bạn đã hết gợi ý'),
          actions: <Widget>[
            TextButton(
              child: const Text('Đồng ý'),
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
            xuLyNhapSo(so);
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

  void kiemTraBangHoanThanh() {
    bool bangHoanThanh = true;
    for (int i = 0; i < widget.bang.length; i++) {
      for (int j = 0; j < widget.bang[i].length; j++) {
        if (widget.bang[i][j] == 0) {
          bangHoanThanh = false;
          break;
        }
      }
      if (!bangHoanThanh) {
        break;
      }
    }
    if (bangHoanThanh) {
      thoiGian.cancel();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'THÀNH CÔNG',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            content: const Text('Chúc mừng bạn đã hoàn thành màn chơi !'),
            actions: <Widget>[
              TextButton(
                child: const Text('Đóng'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
