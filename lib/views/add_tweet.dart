import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_twitter_ryan_mateo/database/database_helper.dart';
import 'package:projeto_twitter_ryan_mateo/models/tweet.dart';

class AddTweet extends StatefulWidget {
  const AddTweet({super.key, this.tweet});
  final Tweet? tweet;

  @override
  State<AddTweet> createState() => _AddTweetState();
}

class _AddTweetState extends State<AddTweet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  File? _fotoSelecionada;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.tweet != null) {
      _textController.text = widget.tweet!.text;
      _fotoSelecionada = widget.tweet!.photo;
    }
  }

  Future<File?> _tirarFoto() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.tweet == null
            ? const Text(
                "Novo Tweet",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'ClashGrotesk-Variable',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const Text(
                "Editar Tweet",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'ClashGrotesk-Variable',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close_rounded, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 278,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade600),
                borderRadius: BorderRadius.circular(8),
              ),

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Digite seu tweet',

                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'ClashGrotesk-Variable',
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                        ),
                        controller: _textController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Você deve escrever um tweet';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      FormField<File>(
                        initialValue: _fotoSelecionada,
                        onSaved: (value) {
                          _fotoSelecionada = value;
                        },
                        builder: (FormFieldState<File> state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final foto = await _tirarFoto();
                                  if (foto != null) {
                                    setState(() {
                                      _fotoSelecionada = foto;
                                    });
                                    state.didChange(foto);
                                  }
                                },
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade700.withValues(
                                      alpha: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.grey.withValues(alpha: 0.0),
                                      width: 2,
                                    ),
                                    image: state.value != null
                                        ? DecorationImage(
                                            image: FileImage(state.value!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: state.value == null
                                      ? Icon(
                                          Icons.camera_alt,
                                          size: 60,
                                          color: Colors.grey.shade700
                                              .withValues(alpha: 0.5),
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 8),

                              if (state.hasError)
                                Text(
                                  state.errorText!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 58),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Tweet novoTweet = Tweet(
                    text: _textController.text,
                    photo: _fotoSelecionada,
                  );
                  _formKey.currentState!.save();

                  if (widget.tweet == null) {
                    int id = await TweetDao.instance.add(novoTweet);
                    novoTweet.id = id;
                  } else {
                    widget.tweet?.text = _textController.text;
                    widget.tweet?.photo = _fotoSelecionada;
                    TweetDao.instance.update(widget.tweet!);
                  }

                  if (!context.mounted) {
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Salvando',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.blue.shade600,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Postar',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'ClashGrotesk-Variable',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
