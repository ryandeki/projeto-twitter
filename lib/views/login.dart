import 'package:flutter/material.dart';
import 'package:projeto_twitter_ryan_mateo/database/user_dao.dart';
import 'package:projeto_twitter_ryan_mateo/views/create_user.dart';
import 'package:projeto_twitter_ryan_mateo/views/feed.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TWITTER")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade600),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextInput(
                          controller: _usernameController,
                          label: "Nome de usuário",
                          invalidMessage: "Digite o nome de usuário",
                          isInvisible: false,
                        ),
                        const SizedBox(height: 10),
                        TextInput(
                          controller: _passwordController,
                          label: "Senha",
                          invalidMessage: "Digite uma senha válida",
                          isInvisible: true,
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final username = _usernameController.text.trim();
                              final password = _passwordController.text;

                              final user = await UserDao.instance
                                  .getUserByUsernameAndPassword(
                                    username,
                                    password,
                                  );

                              if (!mounted) return;

                              if (user != null) {
                                // Usuário encontrado: entra no Feed
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Feed(user: user),
                                  ),
                                );
                              } else {
                                // Usuário não encontrado no SQLite: exibe a mensagem de erro
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Cadastro não realizado"),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  ),
                                );

                                // Aguarda a exibição da mensagem antes de redirecionar para a tela de cadastro
                                await Future.delayed(
                                  const Duration(seconds: 2),
                                );

                                if (!mounted) return;

                                // Redireciona para a tela de cadastro de usuário
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CreateUser(),
                                  ),
                                );
                              }
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateUser()),
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
