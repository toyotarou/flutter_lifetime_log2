import 'package:flutter/material.dart';

class TemplePhotoDisplayAlert extends StatefulWidget {
  const TemplePhotoDisplayAlert({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  State<TemplePhotoDisplayAlert> createState() => _TemplePhotoDisplayAlertState();
}

class _TemplePhotoDisplayAlertState extends State<TemplePhotoDisplayAlert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Center(child: InteractiveViewer(minScale: 0.5, maxScale: 4.0, child: Image.network(widget.imageUrl))),
    );
  }
}
