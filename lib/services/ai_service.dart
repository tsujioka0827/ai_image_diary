import 'dart:convert';
import 'dart:math'; // ランダムな数字を作るために必要
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AiService {
  Future<Uint8List?> generateImage(String prompt) async {
    // 毎回違う数字(シード値)を生成して、サーバーに「新しい注文だよ」と伝える
    final int seed = Random().nextInt(1000000);

    // 日本語をURL用にエンコード
    final encodedPrompt = Uri.encodeComponent(prompt);

    // URLにパラメータを追加（幅・高さ・シード値・ロゴなし）
    // width=512&height=512 にすることで処理を軽くします
    final url = Uri.parse(
        'https://image.pollinations.ai/prompt/$encodedPrompt?width=512&height=512&seed=$seed&nologo=true');

    try {
      print('AI画像生成中(再挑戦): $prompt (seed: $seed)');

      // タイムアウトを10秒に設定（これ以上かかったら諦める）
      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('サーバーエラー: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('例外が発生しました: $e');
      return null;
    }
  }
}
