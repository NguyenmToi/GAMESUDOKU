import 'package:flutter/material.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

class ThongKe extends StatefulWidget {
  ThongKe({super.key, required this.ttTaiKhoan});
  final ctaiKhoan ttTaiKhoan;

  @override
  State<ThongKe> createState() => _ThongKeState();
}

class _ThongKeState extends State<ThongKe> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double tyle = 0.0;
    if (widget.ttTaiKhoan.taikhoan != null &&
        widget.ttTaiKhoan!.mdsovandachoi != 0) {
      tyle =
          (widget.ttTaiKhoan!.mdsovanthang / widget.ttTaiKhoan!.mdsovandachoi) *
              100;
    }

    double tilethuthach = 0.0;

    if (widget.ttTaiKhoan!.man >= 2) {
      tilethuthach =
          ((widget.ttTaiKhoan!.man - 1) / widget.ttTaiKhoan!.ttsovandachoi) *
              100;
    } else {
      tilethuthach = 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thống kê',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.amber[200],
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: widget.ttTaiKhoan != null
                      ? NetworkImage(widget.ttTaiKhoan!.anh)
                      : null,
                  backgroundColor: Colors.white,
                ),
                SizedBox(width: 16),
                Text(
                  widget.ttTaiKhoan!.tentaikhoan,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Thống kê mức độ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            buildStatContainer(
                'Số ván đã chơi',
                widget.ttTaiKhoan!.mdsovandachoi.toString(),
                'Số ván đã thắng',
                widget.ttTaiKhoan!.mdsovanthang.toString(),
                'Tỷ lệ thắng',
                tyle.toStringAsFixed(2) + '%',
                'Ván thắng không lỗi',
                widget.ttTaiKhoan!.mdsovanthangkhongloi.toString()),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Thống kê thử thách',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            buildStatContainer(
              'Số ván đã chơi',
              widget.ttTaiKhoan.ttsovandachoi.toString(),
              'Màn cao nhất được mở khóa',
              widget.ttTaiKhoan.man.toString(),
              'Số ván thắng không lỗi',
              widget.ttTaiKhoan.ttsovanthangkhongloi.toString(),
              'Tỉ lệ mở khóa màn mới',
              tilethuthach.toStringAsFixed(2) + '%',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatContainer(
      String label1,
      String value1,
      String label2,
      String value2,
      String label3,
      String value3,
      String label4,
      String value4) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildStatRow(label1, value1),
          buildDivider(),
          buildStatRow(label2, value2),
          buildDivider(),
          buildStatRow(label3, value3),
          buildDivider(),
          buildStatRow(label4, value4),
        ],
      ),
    );
  }

  Widget buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Divider(
      color: Colors.black,
      thickness: 1,
    );
  }
}
