import 'dart:io';

import 'package:flutter/material.dart';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ScreenReader extends StatefulWidget {
  const ScreenReader({super.key});

  @override
  State<ScreenReader> createState() => _ScreenReaderState();
}

class _ScreenReaderState extends State<ScreenReader> {
  bool visible = true;
  File? _image;
  String _text = '';
  final picker = ImagePicker();
  //picking the image
  Future getImageFromGallery(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  //reading the text from image

  Future<void> readTextFromImage() async {
    final inputImage = InputImage.fromFile(_image!);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    _text = recognizedText.text;

    textRecognizer.close();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image to Text'),
        ),
        body: Center(
          child: _image == null
              ? const Text('No image selected.')
              : Column(
                  children: [
                    Image.file(
                      _image!,
                      height: MediaQuery.of(context).size.height * 0.5,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await readTextFromImage();
                          showDialog(
                              barrierDismissible: false,
                              // barrierColor: Colors.black,

                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Your Extracted Text'),
                                  content: Text(_text),
                                  actions: [
                                    TextButton.icon(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(Icons.close),
                                        label: const Text('close'))
                                  ],
                                );
                              });
                        },
                        child: const Text("Get Text")),
                  ],
                ),
        ),
        floatingActionButton: Visibility(
            visible: visible,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  visible = false;
                });
                showModalBottomSheet(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height / 4),
                    enableDrag: false,
                    context: context,
                    builder: (context) {
                      return Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text(
                              'Captured image from camera',
                            ),
                            onTap: () {
                              getImageFromGallery(ImageSource.camera);
                              Navigator.of(context).pop();
                            },
                          ),
                          const Divider(
                            color: Colors.black,
                            // thickness: 3,
                            height: 2,
                            indent: 10,
                            endIndent: 10,
                          ),
                          ListTile(
                            leading: const Icon(Icons.image),
                            title: const Text('choose image from gallery'),
                            onTap: () {
                              getImageFromGallery(ImageSource.gallery);
                              Navigator.of(context).pop();
                            },
                          ),
                          const Divider(
                            color: Colors.black,
                            // thickness: 3,
                            height: 2,
                            indent: 10,
                            endIndent: 10,
                          ),
                          ListTile(
                            leading: Icon(Icons.cancel),
                            title: Text('Cancel'),
                            onTap: () {
                              Navigator.of(context).pop();
                              // setState(() {
                              //   visible = true;
                              // });
                            },
                          )
                        ],
                      );
                    }).whenComplete(() {
                      setState(() {
                        visible=true;
                      });
                    });
                  //   timeout(
                  // Duration(seconds: 1),
                  // onTimeout: () {
                  //   Navigator.of(context).pop();
                  //   setState(() {
                  //     visible = true;
                  //   });
                  // },
                  

                  // onTimeout: () {
                  //   return Navigator.of(context).pop();
                  // },
                // );
              },
              child: Icon(Icons.image),
            )));
  }
}
