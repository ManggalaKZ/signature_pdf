import 'package:flutter/material.dart';

class SignatureHintOverlay extends StatelessWidget {
  const SignatureHintOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      alignment: Alignment.center,
      child: Text(
        'Tap di area mana saja untuk memberi tanda tangan',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
