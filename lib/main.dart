import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Image Diary',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'AI Image Diary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            // メールアドレス入力欄（見た目だけ）
            const TextField(
              decoration: InputDecoration(
                labelText: 'メールアドレス',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // パスワード入力欄（見た目だけ）
            // AI生成コードを使用。
            // パスワード入力欄なので、obscureText: true で文字を隠す設定にしていることを確認済み。
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'パスワード',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            // ログインボタン
            ElevatedButton(
              onPressed: () {
                // まだ何もしない
                print("ログインボタンが押されました");
              },
              child: const Text('ログイン'),
            ),
          ],
        ),
      ),
    );
  }
}
