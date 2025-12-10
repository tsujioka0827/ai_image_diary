import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'login_screen.dart'; // ログアウト時に戻るために必要

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ログアウト処理
  Future<void> _signOut(BuildContext context) async {
    try {
      await Amplify.Auth.signOut();
      if (context.mounted) {
        // ログイン画面に戻る
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      debugPrint('ログアウトエラー: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日記一覧'),
        actions: [
          // ログアウトボタン
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'ここに日記が並びます',
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ),
      // 日記追加ボタン（今は飾り）
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
