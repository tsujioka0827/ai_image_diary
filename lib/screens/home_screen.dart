import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/ModelProvider.dart';
import 'login_screen.dart';
import 'create_diary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Diary> _diaries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getDiaries();
  }

  Future<void> _getDiaries() async {
    try {
      final request = ModelQueries.list(Diary.classType);
      final response = await Amplify.API.query(request: request).response;

      final data = response.data;
      if (data != null) {
        setState(() {
          _diaries = data.items.whereType<Diary>().toList();
          _isLoading = false;
        });
      }
    } on ApiException catch (e) {
      safePrint('取得エラー: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteDiary(Diary diaryToDelete) async {
    // 念の為の確認ダイアログ
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('本当に消しますか？'),
        content: Text('タイトル: ${diaryToDelete.title}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('削除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (result != true) return; // キャンセルなら何もしない

    try {
      final request = ModelMutations.delete(diaryToDelete);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        safePrint('削除成功: ${response.data!.id}');
        setState(() {
          _diaries.removeWhere((d) => d.id == diaryToDelete.id);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('削除しました')),
          );
        }
      }
    } on ApiException catch (e) {
      safePrint('削除エラー: $e');
    }
  }

  // diaryToEdit があれば「編集」、なければ「新規」として扱う
  Future<void> _goToCreateDiary({Diary? diaryToEdit}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        // ここでデータを渡す！
        builder: (context) => CreateDiaryScreen(diaryToEdit: diaryToEdit),
      ),
    );
    _getDiaries(); // 戻ってきたらリスト更新
  }

  Future<void> _signOut() async {
    try {
      await Amplify.Auth.signOut();
      if (mounted) {
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
          IconButton(icon: const Icon(Icons.logout), onPressed: _signOut),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _diaries.isEmpty
              ? const Center(child: Text('日記を作成してみましょう！'))
              : ListView.builder(
                  itemCount: _diaries.length,
                  itemBuilder: (context, index) {
                    final diary = _diaries[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(diary.title ?? '無題',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          diary.content ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // ボタンを2つ並べるために Row を使う
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min, // ボタンの幅を最小限にする呪文
                          children: [
                            // 編集ボタン（ペン）
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // この日記データを持たせて移動！
                                _goToCreateDiary(diaryToEdit: diary);
                              },
                            ),
                            // 削除ボタン（ゴミ箱）
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteDiary(diary),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        // 新規作成ボタンは、引数なし（空っぽ）で呼ぶ
        onPressed: () => _goToCreateDiary(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
