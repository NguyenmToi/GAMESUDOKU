import 'package:flutter/material.dart';

import 'package:sudoku/ManHinh/ManHinhChoiThuThach.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

class ChonManCHoi extends StatefulWidget {
  const ChonManCHoi({super.key});

  @override
  State<ChonManCHoi> createState() => _ChonManCHoiState();
}

class _ChonManCHoiState extends State<ChonManCHoi> {
  late Future<List<cManThuThach>> _dsManThuThach;

  @override
  void initState() {
    super.initState();
    _dsManThuThach = cManThuThach
        .taiDanhSachMan(); // Gọi hàm để load danh sách màn thử thách
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
            Navigator.pop(context);
          },
        ),
        title: const Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(right: 40.0),
                child: Text(
                  "Chọn màn chơi",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
            7, 10, 7, 5), // Thêm khoảng cách padding ở trên
        child: FutureBuilder<List<cManThuThach>>(
          future: _dsManThuThach,
          builder: (BuildContext context,
              AsyncSnapshot<List<cManThuThach>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available'));
            } else {
              List<cManThuThach> manThuThachList = snapshot.data!;

              // Sắp xếp danh sách theo mã màn
              manThuThachList.sort((a, b) => a.maman.compareTo(b.maman));

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.8, // tỉ lệ dài - rộng
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: manThuThachList.length,
                itemBuilder: (BuildContext context, int index) {
                  cManThuThach manThuThach = manThuThachList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManHinhChoiThuThach(
                            tenMan: manThuThach.tenman,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          ' ${manThuThach.tenman}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
