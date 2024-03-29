import 'package:todo_app/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInPage({Key? key}) : super(key: key);

  // progress indicator
  showProgress(BuildContext context) {
    AlertDialog loadingAlert = const AlertDialog(
        content: Center(
      child: CircularProgressIndicator(),
    ));

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => loadingAlert);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: "Email",
            ),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Password",
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // sign in method handler
              context.read<AuthService>().signIn(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
            },
            child: const Text("Sign in"),
          )
        ],
      ),
    );
  }
}
