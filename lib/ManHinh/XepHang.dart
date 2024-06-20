import 'package:flutter/material.dart';

class XepHang extends StatefulWidget {
  const XepHang({super.key});

  @override
  State<XepHang> createState() => XepHangState();
}

class XepHangState extends State<XepHang> {
  int selectedButton = 0; // Biến lưu trữ nút đang chọn

  // Danh sách người chơi cho từng nút
  final List<Map<String, dynamic>> doKhoPlayers = List.generate(
      10,
      (index) => {
            'name': 'Người chơi độ khó ${index + 1}',
            'score': 1000 - index * 10,
          });

  final List<Map<String, dynamic>> thuThachPlayers = List.generate(
      10,
      (index) => {
            'name': 'Người chơi thử thách ${index + 1}',
            'score': 900 - index * 10,
          });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Bảng xếp hạng'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "data/img/anhCupXepHang.png",
                height: 250,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: selectedButton == 0
                            ? Colors.blue
                            : Colors.grey, // Đổi màu nền nút
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Bo tròn góc nút
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedButton = 0;
                        });
                      },
                      child: Text(
                        'Độ khó',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: selectedButton == 1
                            ? Colors.blue
                            : Colors.grey, // Đổi màu nền nút
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Bo tròn góc nút
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedButton = 1;
                        });
                      },
                      child: Text(
                        'Thử thách',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: selectedButton == 0
                    ? doKhoPlayers.length
                    : thuThachPlayers.length,
                itemBuilder: (context, index) {
                  final player = selectedButton == 0
                      ? doKhoPlayers[index]
                      : thuThachPlayers[index];
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/image/xephang.jpg') // Thay đổi đường dẫn ảnh avatar nếu cần
                        ),
                    title: Text(player['name']),
                    subtitle: Text(
                        'Điểm: ${player['score']}'), // Thay đổi điểm cho phù hợp
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
