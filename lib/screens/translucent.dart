import 'package:flutter/material.dart';

class TranslucentScreen extends StatelessWidget {
  const TranslucentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          // ModalBarrier to create a translucent effect
          ModalBarrier(color: Colors.black54, dismissible: false),
        ],
      ),
    );
  }
}
