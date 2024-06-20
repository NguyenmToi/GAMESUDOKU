import 'package:flutter/material.dart';
import 'package:flutter_application_1/ManHinhChoi.dart';

class ChonManCHoi extends StatefulWidget {
  const ChonManCHoi({super.key});

  @override
  State<ChonManCHoi> createState() => _ChonManCHoiState();
}

class _ChonManCHoiState extends State<ChonManCHoi> {
  int soman = 60;

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
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.8, // tỉ lệ dài - rộng
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: soman,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManHinhChoi(
                          soMan: index + 1, // Truyền số màn vào
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
                        'Màn ${index + 1}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ));
            }),
      ),
    );
  }
}
