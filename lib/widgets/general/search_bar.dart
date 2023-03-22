import 'package:flutter/material.dart';

/// This widget returns a search bar to be used in the picture grid.
class SearchBar extends StatefulWidget {
  const SearchBar({super.key, required this.onTextChanged});

  final Function(String) onTextChanged;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController(text: "");

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key("searchBar"),
      controller: _controller,
      onChanged: widget.onTextChanged,
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
