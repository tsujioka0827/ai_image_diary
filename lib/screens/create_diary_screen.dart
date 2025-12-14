import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/ModelProvider.dart';

class CreateDiaryScreen extends StatefulWidget {
  final Diary? diaryToEdit;

  const CreateDiaryScreen({super.key, this.diaryToEdit});

  @override
  State<CreateDiaryScreen> createState() => _CreateDiaryScreenState();
}

class _CreateDiaryScreenState extends State<CreateDiaryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  // 画面が開いた瞬間の処理
  @override
  void initState() {
    super.initState();
    // もし「編集モード（データが入っている）」なら、最初から入力欄に文字を表示しておく
    if (widget.diaryToEdit != null) {
      _titleController.text = widget.diaryToEdit!.title ?? '';
      _contentController.text = widget.diaryToEdit!.content ?? '';
    }
  }

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
      // AWSへのリクエストを入れる箱を用意
      GraphQLRequest<Diary>? request;

      if (widget.diaryToEdit == null) {
        // A. データがない = 「新規作成 (Create)」
        final newDiary = Diary(
          title: title,
          content: content,
          date: TemporalDate(DateTime.now()),
        );
        request = ModelMutations.create(newDiary);
      } else {
        // B. データがある = 「更新 (Update)」

        // copyWith: 「IDはそのまま」で、タイトルと中身だけ書き換えたコピーを作る
        final updatedDiary = widget.diaryToEdit!.copyWith(
          title: title,
          content: content,
        );
        request = ModelMutations.update(updatedDiary);
      }

      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        print('保存エラー: ${response.errors}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('保存エラー: ${response.errors.first.message}')),
          );
        }
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.diaryToEdit == null ? '保存しました！' : '更新しました！'),
              backgroundColor: Colors.green),
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
    // 画面タイトルも切り替え
    final isEdit = widget.diaryToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? '日記を編集' : '日記を書く'),
      ),
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
                // ボタンの文字も切り替え
                child: Text(isEdit ? '更新する' : '保存する'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
