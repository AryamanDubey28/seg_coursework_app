import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final bool isPassword;

  const MyTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.isPassword = false,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool passwordVisible=false;
      
  @override
  void initState(){
    super.initState();
    passwordVisible=false;
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
          padding: const EdgeInsets.only(left: 20.0),
          child: widget.isPassword == false
              ? TextField(
                cursorColor: Colors.black,
                  controller: widget.controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hint,
                  ),
                )
              : TextField(
                cursorColor: Colors.black,
                  obscureText: !passwordVisible,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: widget.controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hint,
                    suffixIcon: IconButton(
                      color: Colors.grey[500],
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(
                          () {
                            passwordVisible = !passwordVisible;
                          },
                        );
                      },
                    ),
                  ),
                  
                ),
        ),
      ),
    );
  }
}
