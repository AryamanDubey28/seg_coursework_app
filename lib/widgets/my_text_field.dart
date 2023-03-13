import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final isNumericKeyboard;

  const MyTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.isNumericKeyboard = false,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  Widget getTextField() {
    if (!widget.isPassword) {
      if (!widget.isNumericKeyboard) {
        return TextField(
          cursorColor: Colors.black,
          controller: widget.controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hint,
          ),
        );
      } else {
        //is numeric keyboard
        return TextField(
          cursorColor: Colors.black,
          controller: widget.controller,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(
                RegExp(r'[0-9]')), //only numbers can be entered
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hint,
          ),
        );
      }
    } else {
      if (!widget.isNumericKeyboard) {
        return TextField(
          cursorColor: Colors.black,
          obscureText: !passwordVisible,
          enableSuggestions: false,
          autocorrect: false,
          controller: widget.controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hint,
            suffixIcon: IconButton(
              key: Key("visibilityButton"),
              color: Colors.grey[500],
              icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(
                  () {
                    passwordVisible = !passwordVisible;
                  },
                );
              },
            ),
          ),
        );
      } else {
        return TextField(
          cursorColor: Colors.black,
          obscureText: !passwordVisible,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(
                RegExp(r'[0-9]')), //only numbers can be entered
            FilteringTextInputFormatter.digitsOnly
          ],
          controller: widget.controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hint,
            suffixIcon: IconButton(
              key: Key("visibilityButton"),
              color: Colors.grey[500],
              icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(
                  () {
                    passwordVisible = !passwordVisible;
                  },
                );
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
            padding: const EdgeInsets.only(left: 20.0), child: getTextField()),
      ),
    );
  }
}
