import 'package:flutter/material.dart';
import 'package:projeto_twitter_ryan_mateo/views/create_user.dart';
import 'package:projeto_twitter_ryan_mateo/views/feed.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("TWITTER")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height * 0.3,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade600),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextInput(
                        controller: usernameController,
                        label: "Nome de usuário",
                        invalidMessage: "Digite o nome de usuário",
                        isInvisible: false,
                      ),
                      TextInput(
                        controller: passwordController,
                        label: "Senha",
                        invalidMessage: "Digite uma senha válida",
                        isInvisible: true,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => const Feed()),
                              ),
                            );
                          }
                        },
                        child: const Text("Entrar"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Não tem uma conta?",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: ((context) => const CreateUser())),
                );
              },
              child: Text(
                "Registre-se",
                style: TextStyle(color: Colors.blue.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextInput extends StatefulWidget {
  const TextInput({
    super.key,
    required this.controller,
    required this.label,
    required this.invalidMessage,
    required this.isInvisible,
  });
  final TextEditingController controller;
  final String label;
  final String invalidMessage;
  final bool isInvisible;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      obscureText: widget.isInvisible,
      decoration: InputDecoration(
        hintText: widget.label,

        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'ClashGrotesk-Variable',
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.0),
        ),
      ),
      controller: widget.controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return widget.invalidMessage;
        }
        return null;
      },
    );
  }
}
