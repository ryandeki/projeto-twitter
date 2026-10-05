import 'package:flutter/material.dart';
import 'package:projeto_twitter_ryan_mateo/views/login.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
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
                      TextInput(
                        controller: passwordController,
                        label: "Confirmar senha",
                        invalidMessage: "As senhas não são compatíveis",
                        isInvisible: true,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {}
                        },
                        child: const Text("Cadastrar"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Já tem uma conta?",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: ((context) => const Login())),
                );
              },
              child: Text(
                "Entrar",
                style: TextStyle(color: Colors.blue.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
