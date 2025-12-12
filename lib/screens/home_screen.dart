import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/ModelProvider.dart'; // モデル（設計図）
import 'create_diary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 日記のデータを入れるリスト
  List<Diary> _diaries = [];
  // 読み込み中かどうか
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDiaries(); // 画面が開いたらデータを読み込む！
  }

  // クラウドから日記一覧を取得する関数
  Future<void> _fetchDiaries() async {
    try {
      final request = ModelQueries.list(Diary.classType);
      final response = await Amplify.API.query(request: request).response;

      final items = response.data?.items;

      if (mounted) {
        setState(() {
          // 取得したデータをリストに入れる
          _diaries = items?.whereType<Diary>().toList() ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('読み込みエラー: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Image Diary')),
      // 読み込み中ならグルグル、データがあればリストを表示
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _diaries.isEmpty
              ? const Center(child: Text('日記がまだありません'))
              : ListView.builder(
                  itemCount: _diaries.length,
                  itemBuilder: (context, index) {
                    final diary = _diaries[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(diary.title),
                        subtitle: Text(diary.content),
                        // 日付を表示（nullなら空文字）
                        trailing: Text(
                          diary.date != null ? diary.date.toString() : '',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // リストを更新する
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CreateDiaryScreen()),
          );
          _fetchDiaries(); // 戻ってきたタイミングで再読み込み
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
