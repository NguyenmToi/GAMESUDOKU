// import 'package:flutter/material.dart';
// import 'package:sudoku/MoHinh/xulydulieu.dart';

// class ThongKe extends StatefulWidget {
//   ThongKe({super.key, required this.ttTaiKhoan});
//   final ctaiKhoan ttTaiKhoan;

//   @override
//   State<ThongKe> createState() => _ThongKeState();
// }

// class _ThongKeState extends State<ThongKe> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double tyle = 0.0;
//     if (widget.ttTaikhoan.taikhoan != null && widget.ttTaikhoan!.mdsovandachoi != 0) {
//       tyle = (widget.ttTaikhoan!.mdsovanthang / widget.ttTaikhoan!.mdsovandachoi) * 100;
//     }
//     return Scaffold(
//       appBar: AppBar(
//       title: Text(
//         'Thống kê',
//         style: TextStyle(
//           fontSize: 25,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       centerTitle: true,
//       automaticallyImplyLeading: false,
//     ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 35,
//                   backgroundImage: widget.ttTaikhoan != null
//                       ? NetworkImage(widget.ttTaikhoan!.anh)
//                       : null,
//                   backgroundColor: Colors.white,
//                 ),
//                 SizedBox(width: 16),
//                 Text(
//                   widget.ttTaikhoan!.tentaikhoan,
//                   style: TextStyle(
//                     fontSize: 25,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 32),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Thống kê mức độ',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(height: 16),
//             buildStatContainer(
//                 'Số ván đã chơi',
//                 widget.ttTaikhoan!.mdsovandachoi.toString(),
//                 'Số ván đã thắng',
//                 widget.ttTaikhoan!.mdsovanthang.toString(),
//                 'Tỷ lệ thắng',
//                 tyle.toStringAsFixed(2) + '%',
//                 'Ván thắng không lỗi',
//                 widget.ttTaikhoan!.mdsovanthangkhongloi.toString()),
//             SizedBox(height: 16),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Thống kê thử thách',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(height: 16),
//             buildStatContainer2(
//                 'Số ván đã chơi',
//                 widget.ttTaiKhoan.ttsovandachoi.toString(),
//                 'Số ván thắng không lỗi',
//                 widget.ttTaiKhoan.ttsovanthangkhongloi.toString(),
//                 'Tỉ lệ mở khóa màn mới',
//                 widget.ttTaiKhoan.tttilemokhoamanmoi.toString()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildStatContainer(
//       String label1,
//       String value1,
//       String label2,
//       String value2,
//       String label3,
//       String value3,
//       String label4,
//       String value4) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           buildStatRow(label1, value1),
//           buildDivider(),
//           buildStatRow(label2, value2),
//           buildDivider(),
//           buildStatRow(label3, value3),
//           buildDivider(),
//           buildStatRow(label4, value4),
//         ],
//       ),
//     );
//   }

//   Widget buildStatContainer2(
//     String label1,
//     String value1,
//     String label2,
//     String value2,
//     String label3,
//     String value3,
//   ) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           buildStatRow(label1, value1),
//           buildDivider(),
//           buildStatRow(label2, value2),
//           buildDivider(),
//           buildStatRow(label3, value3),
//         ],
//       ),
//     );
//   }

//   Widget buildStatRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontSize: 16),
//           ),
//           Text(
//             value,
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildDivider() {
//     return Divider(
//       color: Colors.black,
//       thickness: 1,
//     );
//   }
// }
