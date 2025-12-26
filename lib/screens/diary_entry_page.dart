import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/ai_service.dart'; // 「1つ上の階層(..)のservicesフォルダ」を見る

class DiaryEntryPage extends StatefulWidget {
  const DiaryEntryPage({super.key});

  @override
  State<DiaryEntryPage> createState() => _DiaryEntryPageState();
}

class _DiaryEntryPageState extends State<DiaryEntryPage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _promptController = TextEditingController();
  final AiService _aiService = AiService();

  Uint8List? _imageData;
  bool _isLoading = false;

  Future<void> _generateImage() async {
    if (_promptController.text.isEmpty) return;
    setState(() {
      _isLoading = true;
      _imageData = null;
    });

    final image = await _aiService.generateImage(_promptController.text);

    setState(() {
      _imageData = image;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('日記を書く')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('今日の日記'),
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            const Text('AI挿絵'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promptController,
                    decoration:
                        const InputDecoration(hintText: '例: flying cat'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isLoading ? null : _generateImage,
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            if (_imageData != null) Image.memory(_imageData!),
          ],
        ),
      ),
    );
  }
}
