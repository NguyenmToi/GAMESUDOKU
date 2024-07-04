import 'package:flutter/material.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

class ThongKe extends StatefulWidget {
  ThongKe({
    super.key,
  });

  @override
  State<ThongKe> createState() => _ThongKeState();
}

class _ThongKeState extends State<ThongKe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thống kê'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                    radius: 35,
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    child: Image.asset("assets/image/avt1.jpg")),
                SizedBox(width: 16),
                Text(
                  'Trương Công Mới',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Thống kê',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            buildStatContainer('Số ván đã chơi', '123', 'Số ván đã thắng', '75',
                'Tỷ lệ thắng', '61%', 'Chuỗi thắng dài nhất', '10'),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Thống kê 2',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            buildStatContainer('Số ván đã chơi', '123', 'Số ván đã thắng', '75',
                'Tỷ lệ thắng', '61%', 'Chuỗi thắng dài nhất', '10'),
            // buildStatContainer2(
            // 'Số ván đã chơi',
            // widget.ttThongKe.ttsovandachoi.toString(),
            // 'Số ván thắng không lỗi',
            // widget.ttThongKe.ttsovanthangkhongloi.toString(),
            // 'Tỉ lệ mở khóa màn mới',
            // widget.ttThongKe.tttilemokhoamanmoi.toString()

            // ),
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

  Widget buildStatContainer2(
    String label1,
    String value1,
    String label2,
    String value2,
    String label3,
    String value3,
  ) {
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
