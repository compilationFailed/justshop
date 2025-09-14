import 'package:flutter/material.dart';
import 'package:justshop/providers/shoppinglistentry_provider.dart';
import 'package:justshop/screens/edit_entry_screen.dart';
import 'package:justshop/widgets/shoppinglistentry_tile.dart';
import 'package:provider/provider.dart';

class ShoppinglistsScreen extends StatefulWidget {
  const ShoppinglistsScreen({super.key, this.listDate});

  final String? listDate;

  @override
  State<ShoppinglistsScreen> createState() => _ShoppinglistsScreenState();
}

class _ShoppinglistsScreenState extends State<ShoppinglistsScreen> {
  late Future<void> _initialLoad;
  @override
  void initState() {
    super.initState();
    final listDate = widget.listDate ?? '';
    _initialLoad = Provider.of<ShoppinglistProvider>(
      context,
      listen: false, // verhindert unnötige Rebuilds während des Ladens
    ).fetchShoppinglistentriesForDate(listDate);
  }

  @override
  Widget build(BuildContext context) {
    final listDate = widget.listDate ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping List for ${listDate.isNotEmpty ? (() {
                  try {
                    final date = DateTime.parse(listDate);
                    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
                  } catch (_) {
                    return listDate;
                  }
                })() : ''}',
        ),
      ),
      body: FutureBuilder(
        future: _initialLoad, // wartet auf das erste Laden der Notizen
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Consumer<ShoppinglistProvider>(
            builder: (ctx, shoppinglistProvider, _) => RefreshIndicator(
              // Ermöglicht Pull-to-Refresh Geste
              onRefresh: () => shoppinglistProvider
                  .fetchShoppinglistentriesForDate(listDate),
              child: shoppinglistProvider.shoppinglistentries.isEmpty
                  ? Center(child: Text('No entries yet.'))
                  : ListView.builder(
                      itemCount:
                          shoppinglistProvider.shoppinglistentries.length,
                      itemBuilder: (_, i) => ShoppinglistentryTile(
                        shoppinglistentry:
                            shoppinglistProvider.shoppinglistentries[i],
                      ),
                    ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditShoppinglistentryScreen()),
        ),
        child: Icon(Icons.add), // Plus-Symbol
      ),
    );
  }
}
