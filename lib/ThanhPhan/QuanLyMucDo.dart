import 'package:flutter/material.dart';

class QuanLyMucDo extends StatefulWidget {
  const QuanLyMucDo({super.key});

  @override
  State<QuanLyMucDo> createState() => _QuanLyMucDoState();
}

class _QuanLyMucDoState extends State<QuanLyMucDo> {
  List<String> levels = ['Dễ', 'Trung bình', 'Khó', 'Ác mộng'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nút "thêm mức độ chơi" được nhấn
              },
              child: Text('Thêm mức độ chơi'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Co giãn theo màn hình
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15), // Thêm bán kính bo tròn
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.blue,
                    child: ListTile(
                      title: Text(
                        levels[index],
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              // Xử lý khi nhấn icon sửa
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
                            onPressed: () {
                              // Xử lý khi nhấn icon xóa
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
