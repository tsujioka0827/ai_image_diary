import 'package:flutter/material.dart';
// ↓↓↓ ★ここが魔法の呪文！「偽物のAmplifyAPIは隠す（hide）」という命令です
import 'package:amplify_flutter/amplify_flutter.dart' hide AmplifyAPI;
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart'; // これで本物だけが見えるようになります
import 'package:ai_image_diary/models/ModelProvider.dart';
import 'package:ai_image_diary/amplifyconfiguration.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isAmplifyConfigured = false;
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      if (!Amplify.isConfigured) {
        final auth = AmplifyAuthCognito();

        // ★偽物を隠したので、普通に書くだけで「本物」が使われます！
        final api = AmplifyAPI(
            options: APIPluginOptions(modelProvider: ModelProvider.instance));

        await Amplify.addPlugins([auth, api]);
        await Amplify.configure(amplifyconfig);
      }

      final session = await Amplify.Auth.fetchAuthSession();

      setState(() {
        _isSignedIn = session.isSignedIn;
        _isAmplifyConfigured = true;
      });

      print('Amplify設定完了。ログイン状態: $_isSignedIn');
    } catch (e) {
      print('Amplify設定エラー: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Image Diary',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: _isAmplifyConfigured
          ? (_isSignedIn ? const HomeScreen() : const LoginScreen())
          : const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
