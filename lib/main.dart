import 'package:flutter/material.dart';
// Amplify関連のインポート
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';

// 生成されたモデルと設定ファイル
import 'models/ModelProvider.dart';
import 'amplifyconfiguration.dart';

// 画面のインポート
import 'screens/home_page.dart';
// ※もしhome_screen.dartという名前なら 'screens/home_screen.dart' に直してください

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      if (Amplify.isConfigured) return;

      final auth = AmplifyAuthCognito();

      final api = AmplifyAPI(
          options: APIPluginOptions(modelProvider: ModelProvider.instance));

      final storage = AmplifyStorageS3();

      await Amplify.addPlugins([auth, api, storage]);
      await Amplify.configure(amplifyconfig);

      safePrint('Amplify configured successfully'); // printの代わりにsafePrint推奨
    } on Exception catch (e) {
      safePrint('Error configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AI Diary',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        builder: Authenticator.builder(),
        home: const HomePage(), // ※クラス名が HomeScreen なら書き換えてください
      ),
    );
  }
}
