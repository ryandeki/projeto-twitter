import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:projeto_twitter_ryan_mateo/database/user_dao.dart';
import 'package:projeto_twitter_ryan_mateo/models/user.dart';
import 'package:projeto_twitter_ryan_mateo/views/login.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              const Text(
                "Cadastre-se",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ClashGrotesk-Variable',
                ),
              ),
              const SizedBox(height: 40),
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
                        const SizedBox(height: 10),
                        TextInput(
                          controller: _confirmPasswordController,
                          label: "Confirmar senha",
                          invalidMessage: "Confirme a sua senha",
                          isInvisible: true,
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_passwordController.text !=
                                  _confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("As senhas não coincidem!"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final username = _usernameController.text.trim();
                              final hashedPassword = BCrypt.hashpw(
                                _passwordController.text,
                                BCrypt.gensalt(),
                              );

                              final existe = await UserDao.instance
                                  .usernameExists(username);
                              if (existe) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Este nome de usuário já está em uso!",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final novoUsuario = User(
                                username: username,
                                password: hashedPassword,
                              );

                              await UserDao.instance.insertUser(novoUsuario);

                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Usuário cadastrado com sucesso!",
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            }
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
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
      ),
    );
  }
}
