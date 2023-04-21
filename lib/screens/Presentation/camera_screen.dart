import 'dart:math';

import 'package:camera/camera.dart';
import 'package:casette/constants/constants.dart';
import 'package:casette/screens/Presentation/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  bool _isLoading = true;
  bool _isRecording = false;
  bool frontCamera = false;

  @override
  void initState() {
    cameraBack();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  cameraBack() async {
    frontCamera = false;
    final camera = await availableCameras();
    final back = camera.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(back, ResolutionPreset.max);
    await _cameraController!.initialize();
    setState(() {
      _isLoading = false;
    });
  }

  cameraFront() async {
    frontCamera = true;
    final camera = await availableCameras();
    final front = camera.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController!.initialize();
    setState(() {
      _isLoading = false;
    });
  }

  recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewScreen(filePath: file.path)));
    } else {
      await _cameraController!.prepareForVideoRecording();
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(builder: (context, snapshot) {
            if (_isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: kAppBarColor),
              );
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CameraPreview(_cameraController!),
              );
            }
          }),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: kScaffoldBackgroundColor,
              padding: EdgeInsets.only(top: 5, bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        backgroundColor: kAppBarColor,
                        onPressed: () async {
                          recordVideo();
                        },
                        child: Icon(_isRecording ? Icons.stop : Icons.circle),
                      ),
                      IconButton(
                          icon: const Icon(
                            Icons.flip_camera_android,
                            color: kAppBarColor,
                            size: 40,
                          ),
                          onPressed: () async {
                            setState(() {
                              frontCamera = !frontCamera;
                            });
                            cameraFront();
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
