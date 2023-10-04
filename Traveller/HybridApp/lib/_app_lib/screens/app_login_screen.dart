import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/account.dart';

class AppLoginScreen extends StatefulWidget {
  const AppLoginScreen({super.key});

  @override
  State<AppLoginScreen> createState() => _AppLoginScreenState();
}

class _AppLoginScreenState extends State<AppLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final ctrEmail = TextEditingController();
  final ctrPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: ctrEmail,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: "Insert email",
                icon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return "Please insert email";
                return null;
              },
            ),
            TextFormField(
              controller: ctrPassword,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: "Insert password",
                icon: Icon(Icons.password),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return "Please insert password";
                return null;
              },
            ),
            ElevatedButton(
                child: const Text("Submit"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    late Account account = Account(
                        email: ctrEmail.value.text,
                        password: ctrPassword.value.text);
                    //Add to bloc
                    context.go('/tickets');
                  }
                })
          ],
        ),
      ),
    );
  }
}