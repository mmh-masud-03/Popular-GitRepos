import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  const SearchBarWidget({
    Key? key,
    required this.searchQuery,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _searchController;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: widget.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search repositories...',
          filled: true,
          fillColor: theme.scaffoldBackgroundColor,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: widget.searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              widget.onSearchChanged('');
              _searchFocusNode.unfocus();
            },
          )
              : null,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),

        ),
      ),
    );
  }
}
