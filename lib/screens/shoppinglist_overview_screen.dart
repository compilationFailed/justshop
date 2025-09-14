// Firebase Authentication package for login and logout
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justshop/providers/shoppinglistentry_provider.dart';
import 'package:justshop/screens/edit_entry_screen.dart';
import 'package:justshop/screens/login_screen.dart';
import 'package:justshop/widgets/shoppinglist_tile.dart';
import 'package:provider/provider.dart';

class ShoppinglistsOverviewScreen extends StatefulWidget {
  const ShoppinglistsOverviewScreen({super.key});

  @override
  State<ShoppinglistsOverviewScreen> createState() =>
      _ShoppinglistsScreenState();
}

class _ShoppinglistsScreenState extends State<ShoppinglistsOverviewScreen> {
  late Future<void> _initialLoad;
  @override
  void initState() {
    super.initState();
    _initialLoad = Provider.of<ShoppinglistProvider>(
      context,
      listen: false, // verhindert unnötige Rebuilds während des Ladens
    ).fetchGroupedShoppinglists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Lists'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Logout-Icon
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
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
              onRefresh: () => shoppinglistProvider.fetchGroupedShoppinglists(),
              child: shoppinglistProvider.shoppinglists.isEmpty
                  ? Center(child: Text('No entries yet.'))
                  : ListView.builder(
                      itemCount: shoppinglistProvider.shoppinglists.length,
                      itemBuilder: (_, i) => ShoppinglistTile(
                        shoppinglist: shoppinglistProvider.shoppinglists[i],
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
