import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  void _showFullScreenModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor:
          Colors.transparent, // Make the modal background transparent
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: DraggableScrollableSheet(
            initialChildSize: 1.0,
            expand: false,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16.0)),
                child: Container(
                  color: Theme.of(context).canvasColor,
                  child: SafeArea(
                    child: SearchableList(
                      scrollController: scrollController,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Full Screen Modal Bottom Sheet')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showFullScreenModal(context),
          child: Text('Show Modal'),
        ),
      ),
    );
  }
}

class SearchableList extends StatefulWidget {
  final ScrollController scrollController;

  SearchableList({required this.scrollController});

  @override
  _SearchableListState createState() => _SearchableListState();
}

class _SearchableListState extends State<SearchableList> {
  TextEditingController _searchController = TextEditingController();
  List<String> _items = List.generate(100, (index) => 'Item $index');
  late List<String> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = _items;
    _searchController.addListener(() {
      setState(() {
        _filteredItems = _items
            .where((item) => item
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredItems[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
