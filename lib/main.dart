import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

// --- 1. アプリの起動 ---
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // .envファイルを読み込む
  await dotenv.load(fileName: ".env");
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // AWSとの接続状態
  bool _isAmplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  // --- 2. AWSと接続する魔法の関数 ---
  Future<void> _configureAmplify() async {
    try {
      // .envからIDを取り出す
      final userPoolId = dotenv.env['COGNITO_USER_POOL_ID'];
      final clientId = dotenv.env['COGNITO_CLIENT_ID'];
      final region = dotenv.env['COGNITO_REGION'];

      // IDがない場合はエラー
      if (userPoolId == null || clientId == null || region == null) {
        throw Exception('IDが設定されていません。.envを確認してください。');
      }

      // AWSへ渡す設定データを作る（手動設定）
      final amplifyConfig = {
        "UserAgent": "aws-amplify-cli/2.0",
        "Version": "1.0",
        "auth": {
          "plugins": {
            "awsCognitoAuthPlugin": {
              "UserAgent": "aws-amplify-cli/0.1.0",
              "Version": "0.1.0",
              "IdentityManager": {"Default": {}},
              "CognitoUserPool": {
                "Default": {
                  "PoolId": userPoolId,
                  "AppClientId": clientId,
                  "Region": region
                }
              },
              "Auth": {
                "Default": {
                  "authenticationFlowType": "USER_SRP_AUTH"
                }
              }
            }
          }
        }
      };

      // プラグインを追加
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);

      // 設定を適用！
      await Amplify.configure(jsonEncode(amplifyConfig));

      setState(() {
        _isAmplifyConfigured = true;
      });
      print('✅ AWS接続成功！'); // ターミナルに表示されます

    } catch (e) {
      print('❌ AWS接続エラー: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Image Diary',
      theme: ThemeData(useMaterial3: true),
      // 接続が終わったらログイン画面を表示
      home: _isAmplifyConfigured 
          ? const LoginScreen() 
          : const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

// --- 3. ログイン画面（前回と同じ） ---
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('AWS接続済み！', style: TextStyle(fontSize: 20, color: Colors.green)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("ログイン処理は次回実装！");
              },
              child: const Text('ログインボタン'),
            ),
          ],
        ),
      ),
    );
  }
}