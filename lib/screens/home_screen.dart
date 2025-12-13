import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart'; // API機能
import '../models/ModelProvider.dart'; // モデル定義
import 'login_screen.dart';
import 'create_diary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 日記データを保持するリスト
  List<Diary> _diaries = [];
  // 読み込み中かどうか
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getDiaries(); // 画面起動時にデータを取得
  }

  // --- 1. 日記一覧を取得 (Read) ---
  Future<void> _getDiaries() async {
    try {
      final request = ModelQueries.list(Diary.classType);
      final response = await Amplify.API.query(request: request).response;

      final data = response.data;
      if (data != null) {
        setState(() {
          // 取得したデータをリストに格納
          // (必要に応じてここで日付順にsortなどが可能です)
          _diaries = data.items.whereType<Diary>().toList();
          _isLoading = false;
        });
      }
    } on ApiException catch (e) {
      safePrint('取得エラー: $e');
      setState(() => _isLoading = false);
    }
  }

  // --- 2. 日記を削除 (Delete) ---
  Future<void> _deleteDiary(Diary diaryToDelete) async {
    try {
      // AWSから削除
      final request = ModelMutations.delete(diaryToDelete);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        safePrint('削除成功: ${response.data!.id}');
        // 成功したら、画面のリストからも削除して再描画
        setState(() {
          _diaries.removeWhere((d) => d.id == diaryToDelete.id);
        });
      }
    } on ApiException catch (e) {
      safePrint('削除エラー: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('削除に失敗しました: ${e.message}')),
      );
    }
  }

  // ログアウト処理
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

  // 日記作成画面への移動
  Future<void> _goToCreateDiary() async {
    // 画面遷移し、戻ってくるのを待つ
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CreateDiaryScreen()),
    );
    // 戻ってきたらリストを再読み込みして、新しい日記を表示させる
    _getDiaries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日記一覧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      // 読み込み中ならグルグル、データがなければメッセージ、あればリスト表示
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
                        // タイトル
                        title: Text(
                          diary.title ?? '無題',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // 内容（少しだけ表示）
                        subtitle: Text(
                          diary.content ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // 右端に削除ボタン
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // 本当に消していいか確認せずにサクッと消す設定（開発用）
                            _deleteDiary(diary);
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCreateDiary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
