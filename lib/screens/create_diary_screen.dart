import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart'; // ← これが必要！
import '../models/ModelProvider.dart';

class CreateDiaryScreen extends StatefulWidget {
  const CreateDiaryScreen({super.key});

  @override
  State<CreateDiaryScreen> createState() => _CreateDiaryScreenState();
}

class _CreateDiaryScreenState extends State<CreateDiaryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  Future<void> _saveDiary() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('タイトルと本文を入力してください')),
      );
      return;
    }

    try {
      final newDiary = Diary(
        title: title,
        content: content,
        date: TemporalDate(DateTime.now()),
      );

      // ★ここが重要！DataStoreではなくAPIを使って保存します
      final request = ModelMutations.create(newDiary);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        print('保存エラー: ${response.errors}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存エラー: ${response.errors.first.message}')),
        );
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('保存しました！'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('保存エラー: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラー: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('日記を書く')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                  labelText: 'タイトル', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                  labelText: '本文', border: OutlineInputBorder()),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveDiary,
                child: const Text('保存する'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
