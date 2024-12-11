import 'package:flutter/material.dart';
import 'image_download_service.dart';
import 'api_response.dart';
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '画像ダウンローダー',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '画像ダウンローダー'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImageDownloadService _service = ImageDownloadService();
  Uint8List? _imageBytes;
  String? _errorMessage;

  Future<void> _downloadImage() async {
    setState(() {
      _imageBytes = null;
      _errorMessage = null;
    });

    final response = await _service.downloadImage(
      'https://cdn.pixabay.com/photo/2024/09/19/07/30/wild-horse-9057944_1280.jpg',
    );

    switch (response) {
      case Success(data: final bytes):
        setState(() {
          _imageBytes = Uint8List.fromList(bytes);
        });
      case Failure(message: final message):
        setState(() {
          _errorMessage = message;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_imageBytes != null)
              Image.memory(_imageBytes!)
            else if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              )
            else
              const Text('画像をダウンロードするにはボタンを押してください')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _downloadImage,
        tooltip: 'Download Image',
        child: const Icon(Icons.download),
      ),
    );
  }
}
