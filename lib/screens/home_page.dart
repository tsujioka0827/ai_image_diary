import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import '../models/ModelProvider.dart';
import 'diary_entry_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Diary> _diaries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDiaries();
  }

  Future<void> _fetchDiaries() async {
    try {
      final request = ModelQueries.list(Diary.classType);
      final response = await Amplify.API.query(request: request).response;

      final items = response.data?.items;
      if (items != null) {
        setState(() {
          _diaries = items.whereType<Diary>().toList();
          _diaries.sort((a, b) => b.date.compareTo(a.date)); // 日付順
          _isLoading = false;
        });
      }
    } catch (e) {
      safePrint('Fetch error: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI日記一覧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Amplify.Auth.signOut(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // 新規作成へ（引数なし）
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DiaryEntryPage()),
          );
          _fetchDiaries();
        },
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _diaries.isEmpty
              ? const Center(child: Text('日記がありません'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _diaries.length,
                  itemBuilder: (context, index) {
                    final diary = _diaries[index];
                    // タップできるようにInkWellで包む
                    return InkWell(
                      onTap: () async {
                        // 編集へ（選んだ日記データを渡す）
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DiaryEntryPage(diaryToEdit: diary),
                          ),
                        );
                        _fetchDiaries(); // 戻ってきたらリスト更新
                      },
                      child: DiaryItem(diary: diary),
                    );
                  },
                ),
    );
  }
}

class DiaryItem extends StatelessWidget {
  final Diary diary;
  const DiaryItem({super.key, required this.diary});

  Future<String?> _getImageUrl(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(
        path: StoragePath.fromString(key),
      ).result;
      return result.url.toString();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (diary.imageKey != null)
            FutureBuilder<String?>(
              future: _getImageUrl(diary.imageKey!),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Image.network(
                    snapshot.data!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                }
                return const SizedBox(height: 0);
              },
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        diary.title ?? '無題',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      diary.date.toString().split('T')[0],
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  diary.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
