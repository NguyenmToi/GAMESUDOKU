import 'package:flutter/material.dart';
import 'package:sudoku/ManHinh/CapNhatManChoi.dart';
import 'package:sudoku/ManHinh/TaoManChoi.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

class QuanLyThuThach extends StatefulWidget {
  const QuanLyThuThach({Key? key}) : super(key: key);

  @override
  State<QuanLyThuThach> createState() => _QuanLyThuThachState();
}

class _QuanLyThuThachState extends State<QuanLyThuThach> {
  late Future<List<cManThuThach>> _dsManThuThach;

  @override
  void initState() {
    super.initState();
    _dsManThuThach =
        cManThuThach.taiDanhSachMan(); // Load danh sách màn từ Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(7.0),
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
              List<cManThuThach> dsManThuThach = snapshot.data!;

              dsManThuThach.sort((a, b) => a.maman.compareTo(b.maman));
              SizedBox(
                height: 10,
              );
              return ListView.builder(
                itemCount: dsManThuThach.length,
                itemBuilder: (BuildContext context, int index) {
                  cManThuThach manThuThach = dsManThuThach[index];
                  return _xayDungCacThanhPhan(
                    title: manThuThach.tenman,
                    color: Colors.lightBlue[100]!,
                    onTapEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CapNhatManChoi(),
                        ),
                      );
                    },
                    onTapDelete: () {},
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _xayDungCacThanhPhan({
    required String title,
    required Color color,
    VoidCallback? onTapEdit,
    VoidCallback? onTapDelete,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: onTapEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.black),
              onPressed: onTapDelete,
            ),
          ],
        ),
      ),
    );
  }
}
