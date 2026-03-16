import 'package:flutter/material.dart';

class AppSearchBar extends StatefulWidget {
  final String? initialQuery;
  final ValueChanged<String> onChanged;
  final String hintText;

  const AppSearchBar({
    super.key,
    this.initialQuery,
    required this.onChanged,
    this.hintText = 'Search products...',
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search, size: 22),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (_, value, __) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
