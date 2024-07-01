import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/TaoDoKho.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';
import 'package:sudoku/ThanhPhan/SuaMucDoChoi.dart';

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
    _loadLevels();
  }

  Future<void> _loadLevels() async {
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
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => TaoDoKho()),
            //     );
            //   },
            //   child: Text(
            //     'Tạo mức độ chơi',
            //     style: TextStyle(color: Colors.white, fontSize: 18),
            //   ),
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: Size(double.infinity, 50), // Co giãn theo màn hình
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(15), // Bo tròn góc
            //     ),
            //     backgroundColor: Colors.blue, // Màu nền xanh
            //   ),
            // ),
            // const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: MucDo.length,
                itemBuilder: (context, index) {
                  final level = MucDo[index];
                  return Card(
                    color: Colors.lightBlue[100],
                    child: ListTile(
                      title: Text(
                        level.tenmucdo,
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        'Số ô ẩn: ${level.soan}, Điểm: ${level.diem}',
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
                                    mamucdo: level.mamucdo,
                                    tenmucdo: level.tenmucdo,
                                    soan: level.soan,
                                    diem: level.diem,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Implement delete logic
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
