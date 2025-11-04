import 'package:flutter/material.dart';

class StampRallyStampDisplayAlert extends StatelessWidget {
  const StampRallyStampDisplayAlert({super.key, required this.imageUrl});

  final String imageUrl;

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: imageUrl,

          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/no_image.png',
            image: imageUrl,
            imageErrorBuilder: (BuildContext c, Object o, StackTrace? s) => Image.asset('assets/images/no_image.png'),
          ),
        ),
      ),
    );
  }
}
