import 'package:flutter/material.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

import '../ManHinh/SuaMucDoChoi.dart';

class QuanLyMucDo extends StatefulWidget {
  const QuanLyMucDo({Key? key}) : super(key: key);

  @override
  State<QuanLyMucDo> createState() => _QuanLyMucDoState();
}

class _QuanLyMucDoState extends State<QuanLyMucDo> {
  List<cmucDo> MucDo = [];

  @override
  void initState() {
    super.initState();
    HienThiMucDo();
  }

  Future<void> HienThiMucDo() async {
    List<cmucDo> LayMucDo = await cmucDo.dsMucDo();
    setState(() {
      MucDo = LayMucDo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: MucDo.length,
                itemBuilder: (context, index) {
                  final mucDo = MucDo[index];
                  return Card(
                    color: Colors.lightBlue[100],
                    child: ListTile(
                      title: Text(
                        mucDo.tenmucdo,
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        'Số ô ẩn: ${mucDo.soan}, Điểm: ${mucDo.diem}',
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SuaMucDoChoi(
                                    mamucdo: mucDo.mamucdo,
                                    tenmucdo: mucDo.tenmucdo,
                                    soan: mucDo.soan,
                                    diem: mucDo.diem,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Xác nhận xóa"),
                                    content: Text(
                                        "Bạn có chắc chắn muốn xóa mức độ này?"),
                                    actions: [
                                      TextButton(
                                        child: Text("Hủy"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Xóa"),
                                        onPressed: () async {
                                          try {
                                            await cmucDo.capNhatMucDoChoi(
                                                mucDo.mamucdo,
                                                mucDo.tenmucdo,
                                                mucDo.soan,
                                                mucDo.diem,
                                                false);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Colors.green,
                                                content: Text(
                                                    "Xóa mức độ thành công"),
                                              ),
                                            );
                                          } catch (error) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                    "Xóa mức độ không thành công"),
                                              ),
                                            );
                                          } finally {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
