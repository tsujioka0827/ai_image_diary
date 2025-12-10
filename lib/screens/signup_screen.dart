import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();

  bool _isVerificationStep = false;

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("メールアドレスとパスワードを入力してください");
      return;
    }

    try {
      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: {
            AuthUserAttributeKey.email: email,
          },
        ),
      );

      setState(() {
        _isVerificationStep = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('確認メールを送信しました。コードを入力してください。')),
        );
      }
    } on AuthException catch (e) {
      _showError('登録エラー: ${e.message}');
    } catch (e) {
      _showError('予期せぬエラー: $e');
    }
  }

  Future<void> _confirmSignUp() async {
    final email = _emailController.text.trim();
    final code = _codeController.text.trim();

    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: code,
      );

      if (result.isSignUpComplete) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("登録完了！"),
              content: const Text("アカウント作成に成功しました！"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      }
    } on AuthException catch (e) {
      _showError('認証エラー: ${e.message}');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('新規登録')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _isVerificationStep
              ? _buildVerificationForm()
              : _buildSignUpForm(),
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('アカウント作成',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 30),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
              labelText: 'メールアドレス',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email)),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
              labelText: 'パスワード (大文字・数字含む8文字以上)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock)),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _signUp,
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white),
            child: const Text('登録コードを送信'),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.mark_email_read, size: 80, color: Colors.green),
        const SizedBox(height: 20),
        const Text('確認コードを入力',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text('メールに届いた6桁の数字を入力してください'),
        const SizedBox(height: 30),
        TextField(
          controller: _codeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              labelText: '確認コード (例: 123456)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.vpn_key)),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _confirmSignUp,
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white),
            child: const Text('認証して完了！'),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _isVerificationStep = false),
          child: const Text('戻る'),
        )
      ],
    );
  }
}
