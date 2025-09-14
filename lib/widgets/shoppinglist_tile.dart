import 'package:flutter/material.dart';
import 'package:justshop/models/shoppinglist.dart';
import 'package:justshop/providers/shoppinglistentry_provider.dart';
import 'package:justshop/screens/edit_entry_screen.dart';
import 'package:justshop/screens/shoppinglists_screen.dart';
import 'package:provider/provider.dart';

class ShoppinglistTile extends StatelessWidget {
  final Shoppinglist shoppinglist;
  const ShoppinglistTile({super.key, required this.shoppinglist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ShoppinglistsScreen(listDate: shoppinglist.name),
        ),
      ),

      child: Hero(
        tag: 'shoppinglistentry_${shoppinglist.name}',
        child: Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: ListTile(
            title: Text(
              (() {
                try {
                  final date = DateTime.parse(shoppinglist.name);
                  return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
                } catch (_) {
                  return shoppinglist.name;
                }
              })(),
              style: TextStyle(),
            ),

            subtitle: Text(
              shoppinglist.shoppingitemsCount > 0
                  ? '${shoppinglist.shoppingitemsCount} items'
                  : 'No items',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
