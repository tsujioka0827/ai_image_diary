import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
// Amplify関連
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import '../models/ModelProvider.dart';

class DiaryEntryPage extends StatefulWidget {
  // 編集する場合のために、元の日記データを受け取れるようにする
  final Diary? diaryToEdit;

  const DiaryEntryPage({super.key, this.diaryToEdit});

  @override
  State<DiaryEntryPage> createState() => _DiaryEntryPageState();
}

class _DiaryEntryPageState extends State<DiaryEntryPage> {
  final TextEditingController _titleController =
      TextEditingController(); // ★タイトル用
  final TextEditingController _diaryController = TextEditingController();
  final TextEditingController _promptController = TextEditingController();

  Uint8List? _imageData;
  bool _isLoading = false;
  String? _currentImageKey; // 編集時に元々あった画像のキーを覚えておく

  @override
  void initState() {
    super.initState();
    // 編集モードなら、元の日記の内容をセットする
    if (widget.diaryToEdit != null) {
      _titleController.text = widget.diaryToEdit!.title ?? '';
      _diaryController.text = widget.diaryToEdit!.content;
      _currentImageKey = widget.diaryToEdit!.imageKey;
    }
  }

  // AI画像生成
  Future<void> _generateImage() async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    _imageData = null;

    try {
      final body = jsonEncode({'prompt': _promptController.text});
      final restOperation = Amplify.API.post(
        '/generate',
        apiName: 'apiForImage',
        body: HttpPayload.string(body),
      );
      final response = await restOperation.response;

      if (response.statusCode == 200) {
        final String responseString = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = jsonDecode(responseString);
        setState(() {
          _imageData = base64Decode(data['image_data']);
        });
      } else {
        safePrint('Error: ${response.body}');
        if (mounted)
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('画像生成エラー')));
      }
    } catch (e) {
      safePrint('Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 保存（新規作成 または 更新）
  Future<void> _saveDiary() async {
    if (_titleController.text.isEmpty || _diaryController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('タイトルと本文を入力してください')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? imageKey = _currentImageKey; // 元の画像キーをデフォルトにする

      // 新しい画像が生成されていたらアップロードしてキーを更新
      if (_imageData != null) {
        final filename =
            'public/diary_${DateTime.now().millisecondsSinceEpoch}.png';
        final result = await Amplify.Storage.uploadData(
          data: StorageDataPayload.bytes(_imageData!),
          path: StoragePath.fromString(filename),
        ).result;
        imageKey = result.uploadedItem.path;
      }

      if (widget.diaryToEdit == null) {
        // --- 新規作成モード ---
        final newDiary = Diary(
          title: _titleController.text,
          content: _diaryController.text,
          date: TemporalDate(DateTime.now()),
          imageKey: imageKey,
        );
        final request = ModelMutations.create(newDiary);
        await Amplify.API.mutate(request: request).response;
      } else {
        // --- 編集モード ---
        // copyWithを使って元のデータを引き継ぎつつ、変更点だけ上書き
        final updatedDiary = widget.diaryToEdit!.copyWith(
          title: _titleController.text,
          content: _diaryController.text,
          imageKey: imageKey,
        );
        final request = ModelMutations.update(updatedDiary);
        await Amplify.API.mutate(request: request).response;
      }

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('保存しました！')));
        Navigator.pop(context); // 一覧に戻る
      }
    } catch (e) {
      safePrint('Save Error: $e');
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('エラー: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 編集モードかどうかでタイトルを変える
    final isEdit = widget.diaryToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? '日記を編集' : '日記を書く'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveDiary,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ★タイトル入力欄
            const Text('タイトル', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'タイトルを入力',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 本文入力欄
            const Text('今日の日記', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _diaryController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '今日はどんな1日でしたか？',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // AI画像エリア
            const Text('AI挿絵をつくる',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promptController,
                    decoration: const InputDecoration(
                      hintText: '挿絵のイメージ (英語推奨)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _generateImage,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('生成'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 新しく生成した画像を表示
            if (_imageData != null)
              Center(
                child: Column(
                  children: [
                    const Text('生成された画像（保存すると反映されます）',
                        style: TextStyle(color: Colors.blue)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(_imageData!),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
