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
    final passwordConfirmController = TextEditingController();

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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Digite um nome de usuário";
                          }

                          return null;
                        },
                        isInvisible: false,
                      ),
                      TextInput(
                        controller: passwordController,
                        label: "Senha",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Digite uma senha válida";
                          }

                          return null;
                        },
                        isInvisible: true,
                      ),
                      TextInput(
                        controller: passwordConfirmController,
                        label: "Confirmar senha",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Digite novamente a senha";
                          } else if (value != passwordController.text) {
                            return "As senhas não são compatíveis";
                          }

                          return null;
                        },
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
