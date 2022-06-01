import 'package:LCI/ViewModel/BaseViewModel.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import 'PrimaryLoading.dart';

class Camera extends StatefulWidget {
  final BaseViewModel viewModel;

  const Camera({required this.viewModel});

  _Camera createState() => _Camera();
}

class _Camera extends State<Camera> {
  List<CameraDescription>? cameras;
  CameraController? controller;
  bool _isReady = false;

  get viewModel => widget.viewModel;

  void initState() {
    super.initState();
    setupCameras();
  }

  Future<void> setupCameras() async {
    cameras = await availableCameras();

    controller = CameraController(cameras!.firstWhere((element) => element.lensDirection == CameraLensDirection.front), ResolutionPreset.max);

    await controller!.initialize();

    if (!mounted) return;
    setState(() {
      _isReady = true;
    });
  }

  Widget build(BuildContext context) {
    if (!_isReady) return PrimaryLoading();
    return CameraPreview(controller!);
  }
}
