import 'package:flutter/material.dart';
import 'package:test001/o3d/o3d.dart';


class Test3DPage extends StatefulWidget {
  const Test3DPage({super.key, required this.path});
  final String path;

  @override
  State<Test3DPage> createState() => _Test3DPageState();
}

class _Test3DPageState extends State<Test3DPage> {
  // to control the animation
  O3DController controller = O3DController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('O3D Viewer'),
        actions: [
          IconButton(
              onPressed: () => controller.cameraOrbit(20, 20, 5),
              icon: const Icon(Icons.change_circle)),
          IconButton(
              onPressed: () => controller.cameraTarget(1.2, 1, 4),
              icon: const Icon(Icons.change_circle_outlined)),
        ],
      ),
      body: O3D(
        controller: controller,
        src: widget.path,
      ),
    );
  }
}