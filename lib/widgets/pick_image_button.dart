import 'package:flutter/material.dart';

/// A standard button style for the two buttons asking for either
/// uploading or taking an image
class PickImageButton extends StatefulWidget {
  final Text label;
  final Icon icon;
  final VoidCallback onPressed;

  const PickImageButton({super.key, required this.label, required this.icon, required this.onPressed});

  @override
  State<PickImageButton> createState() => _PickImageButtonState();
}

class _PickImageButtonState extends State<PickImageButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(onPressed: widget.onPressed, icon: widget.icon, label: widget.label, style: const ButtonStyle(alignment: Alignment.centerLeft, minimumSize: MaterialStatePropertyAll(Size(200, 20)), foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.black54)));
  }
}
