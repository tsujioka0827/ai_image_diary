import 'package:flutter/material.dart';
import 'diary_entry_page.dart'; // 同じフォルダなのでそのまま呼べる

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Diary一覧')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.book, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('まだ日記はありません', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // 日記作成画面へ移動
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DiaryEntryPage()),
          );
        },
      ),
    );
  }
}
