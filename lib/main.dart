import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file not found or empty. $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isAmplifyConfigured = false;
  String _errorMsg = "";

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    if (Amplify.isConfigured) {
      setState(() => _isAmplifyConfigured = true);
      return;
    }

    try {
      final userPoolId = dotenv.env['COGNITO_USER_POOL_ID'];
      final clientId = dotenv.env['COGNITO_CLIENT_ID'];
      final region = dotenv.env['COGNITO_REGION'];

      if (userPoolId == null || clientId == null || region == null) {
        throw Exception("IDが.envに設定されていません");
      }

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
                "Default": {"authenticationFlowType": "USER_SRP_AUTH"}
              }
            }
          }
        }
      };

      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);
      await Amplify.configure(jsonEncode(amplifyConfig));

      setState(() => _isAmplifyConfigured = true);
      debugPrint('✅ AWS接続成功！');
    } catch (e) {
      debugPrint('❌ AWS接続エラー: $e');
      setState(() => _errorMsg = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Image Diary',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: _isAmplifyConfigured
          ? const LoginScreen()
          : Scaffold(
              body: Center(
                child: _errorMsg.isEmpty
                    ? const CircularProgressIndicator()
                    : Text("AWS接続エラー:\n$_errorMsg",
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center),
              ),
            ),
    );
  }
}
