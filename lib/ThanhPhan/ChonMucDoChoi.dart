import 'package:flutter/material.dart';

class ChonMucDoChoi extends StatelessWidget {
  const ChonMucDoChoi({Key? key, required bool showBottomSheet});

  void _showDifficultyLevels(BuildContext context, {bool showBottomSheet = true}) {
    if (showBottomSheet) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.sentiment_satisfied),
                title: const Text('Dễ'),
                onTap: () {
                  Navigator.pop(context); // Dismiss the bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EasyScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.sentiment_neutral),
                title: const Text('Trung Bình'),
                onTap: () {
                  Navigator.pop(context); // Dismiss the bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MediumScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.sentiment_dissatisfied),
                title: const Text('Khó'),
                onTap: () {
                  Navigator.pop(context); // Dismiss the bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HardScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.sentiment_very_dissatisfied),
                title: const Text('Ác Mộng'),
                onTap: () {
                  Navigator.pop(context); // Dismiss the bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NightmareScreen()),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      // Optional: Direct navigation without showing the bottom sheet
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EasyScreen()), // Replace with appropriate screen
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _showDifficultyLevels(context),
        child: const Text('Chọn Mức Độ Chơi'),
      ),
    );
  }
}

class EasyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dễ'),
      ),
      body: Center(
        child: const Text('Mức độ Dễ'),
      ),
    );
  }
}

class MediumScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trung Bình'),
      ),
      body: Center(
        child: const Text('Mức độ Trung Bình'),
      ),
    );
  }
}

class HardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khó'),
      ),
      body: Center(
        child: const Text('Mức độ Khó'),
      ),
    );
  }
}

class NightmareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ác Mộng'),
      ),
      body: Center(
        child: const Text('Mức độ Ác Mộng'),
      ),
    );
  }
}
