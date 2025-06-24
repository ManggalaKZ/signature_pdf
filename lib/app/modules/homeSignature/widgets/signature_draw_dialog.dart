import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

class SignatureDrawDialog extends StatefulWidget {
  const SignatureDrawDialog({super.key});

  @override
  State<SignatureDrawDialog> createState() => _SignatureDrawDialogState();
}

class _SignatureDrawDialogState extends State<SignatureDrawDialog> {
  late DrawingController _controller;
  Color selectedColor = Colors.black;
  double strokeWidth = 4.5;

  @override
  void initState() {
    super.initState();
    _controller = DrawingController();
  }

  void _onSave() async {
    final byteData = await _controller.getImageData();
    if (byteData != null) {
      final image = byteData.buffer.asUint8List();
      Navigator.of(context).pop(image);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Gambar Tanda Tangan'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: DrawingBoard(
              controller: _controller,
              background: Container(
                height: 200,
                width: 300,
                color: Colors.transparent,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text("Warna: "),
              ...[
                Colors.red,
                Colors.black,
                Colors.blue,
                Colors.green,
              ].map((c) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = c;
                      _controller.setStyle(
                        color: selectedColor,
                        strokeWidth: strokeWidth,
                      );
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: selectedColor == c
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => _controller.clear(),
          child: Text('Reset'),
        ),
        ElevatedButton(
          onPressed: _onSave,
          child: Text('Simpan'),
        ),
      ],
    );
  }
}
