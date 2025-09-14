import 'package:flutter/material.dart';
import 'package:justshop/models/shoppinglist_entry.dart';
import 'package:justshop/providers/shoppinglistentry_provider.dart';
import 'package:justshop/screens/edit_entry_screen.dart';
import 'package:provider/provider.dart';

class ShoppinglistentryTile extends StatelessWidget {
  final Shoppinglistentry shoppinglistentry;
  const ShoppinglistentryTile({super.key, required this.shoppinglistentry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              EditShoppinglistentryScreen(shoppinglistentry: shoppinglistentry),
        ),
      ),

      child: Hero(
        tag: 'shoppinglistentry_${shoppinglistentry.id}',
        child: Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),

          child: ListTile(
            title: Text(
              shoppinglistentry.name,
              style: TextStyle(
                decoration: shoppinglistentry.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text(
              shoppinglistentry.shoppingdate.isNotEmpty
                  ? (() {
                      try {
                        final date = DateTime.parse(
                          shoppinglistentry.shoppingdate,
                        );
                        return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
                      } catch (_) {
                        return shoppinglistentry.shoppingdate;
                      }
                    })()
                  : '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            leading: Checkbox(
              value: shoppinglistentry.isDone,
              onChanged: (bool? value) {
                Provider.of<ShoppinglistProvider>(
                  context,
                  listen: false,
                ).switchShoppinglistentryStatus(shoppinglistentry.id);
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Provider.of<ShoppinglistProvider>(
                  context,
                  listen: false,
                ).deleteShoppinglistentry(shoppinglistentry.id);
              },
            ),
          ),
        ),
      ),
    );
  }
}
