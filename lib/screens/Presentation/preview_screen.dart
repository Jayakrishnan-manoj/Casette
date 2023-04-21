import 'dart:io';

import 'package:casette/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PreviewScreen extends StatefulWidget {
  final String filePath;
  const PreviewScreen({
    super.key,
    required this.filePath,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    _videoPlayerController!.initialize().then((_) {
      _videoPlayerController!.setLooping(false);
      _videoPlayerController!.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Preview"),
        backgroundColor: kAppBarColor,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ),
            label: const Text(
              "POST",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: kScaffoldBackgroundColor,
      body: SafeArea(
        child: VideoPlayer(_videoPlayerController!),
      ),
    );
  }
}
