import 'package:flutter/material.dart';
import 'package:sudoku/MoHinh/xulydulieu.dart';

class LichSuaChoi extends StatefulWidget {
  const LichSuaChoi({super.key});

  @override
  State<LichSuaChoi> createState() => LichSuaChoiState();
}

class LichSuaChoiState extends State<LichSuaChoi> {
  List<cMucDoChoiNgauNhien> sudokuList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      List<cMucDoChoiNgauNhien> man =
          await cMucDoChoiNgauNhien.taiDanhSachMan();
      setState(() {
        sudokuList = man;
        isLoading = false;
      });
    } catch (e) {
      print('lỗi hiển thị dữ liệu: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String dinhDang(int timeInSeconds) {
    int minutes = timeInSeconds ~/ 60;
    int seconds = timeInSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
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
                  "Lịch sử chơi",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : sudokuList.isEmpty
              ? Center(child: Text('No data available'))
              : ListView.builder(
                  itemCount: sudokuList.length,
                  itemBuilder: (context, index) {
                    final sudoku = sudokuList[index];
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ngày: ${sudoku.ngay.day}/${sudoku.ngay.month}/${sudoku.ngay.year}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BangSudoku(bang: sudoku.bang),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Icon(Icons.star_border, size: 25),
                                      SizedBox(width: 5),
                                      Text(
                                        'Mức độ: ${sudoku.tenman} ',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Icon(Icons.timer_outlined, size: 25),
                                      SizedBox(width: 5),
                                      Text(
                                        'Thời gian: ${dinhDang(sudoku.thoigian)}',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Icon(Icons.error_outline_outlined,
                                          size: 25),
                                      SizedBox(width: 5),
                                      Text(
                                        'Lượt sai: ${sudoku.soloi}',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Icon(Icons.add_chart_rounded, size: 25),
                                      SizedBox(width: 5),
                                      Text(
                                        'Điểm: ${sudoku.diem}',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

class BangSudoku extends StatelessWidget {
  final List<List<int>> bang;

  const BangSudoku({required this.bang});

  @override
  Widget build(BuildContext context) {
    double kichThuocBang =
        MediaQuery.of(context).size.width * 0.5; // Lấy 55% chiều rộng màn hình
    return Container(
      width: kichThuocBang,
      height: kichThuocBang,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9, // 9 cột cho bảng Sudoku
          childAspectRatio: 1, // Tỷ lệ chiều rộng và chiều cao là 1
        ),
        itemBuilder: (context, index) {
          int hang = index ~/ 9; // Tính hàng từ chỉ số
          int cot = index % 9; // Tính cột từ chỉ số
          Border border = Border(
            top: BorderSide(
              color: hang == 0
                  ? Colors.black
                  : (hang % 3 == 0)
                      ? Colors.black
                      : Colors.grey, // Đường viền trên
              width: 0.7,
            ),
            left: BorderSide(
              color: cot == 0
                  ? Colors.black
                  : (cot % 3 == 0)
                      ? Colors.black
                      : Colors.grey, // Đường viền trái
              width: 0.7,
            ),
            bottom: BorderSide(
              color: hang == 8
                  ? Colors.black
                  : ((hang + 1) % 3 == 0)
                      ? Colors.black
                      : Colors.grey, // Đường viền dưới
              width: 0.7,
            ),
            right: BorderSide(
              color: cot == 8
                  ? Colors.black
                  : ((cot + 1) % 3 == 0)
                      ? Colors.black
                      : Colors.grey, // Đường viền phải
              width: 0.7,
            ),
          );
          return Container(
            decoration: BoxDecoration(border: border),
            child: Center(
              child: Text(
                '${bang[hang][cot]}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
        itemCount: 81, // Tổng số ô trong bảng Sudoku
      ),
    );
  }
}
