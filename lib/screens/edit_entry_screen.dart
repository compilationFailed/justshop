import 'package:flutter/material.dart';
import 'package:justshop/providers/shoppinglistentry_provider.dart';
import 'package:justshop/models/shoppinglist_entry.dart';
import 'package:provider/provider.dart';

class EditShoppinglistentryScreen extends StatefulWidget {
  const EditShoppinglistentryScreen({super.key, this.shoppinglistentry});
  final Shoppinglistentry? shoppinglistentry;

  @override
  State<EditShoppinglistentryScreen> createState() =>
      _EditShoppinglistentryScreenState();
}

class _EditShoppinglistentryScreenState
    extends State<EditShoppinglistentryScreen> {
  // Controller für Eingabefelder: Name und Datum
  final nameCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  //final contentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.shoppinglistentry != null) {
      nameCtrl.text = widget.shoppinglistentry!.name;
      dateCtrl.text = widget.shoppinglistentry!.shoppingdate.toString();
    }
  }

  void saveShoppinglistentry() {
    final provider = Provider.of<ShoppinglistProvider>(context, listen: false);

    if (widget.shoppinglistentry == null) {
      provider.addShoppinglistentry(nameCtrl.text, dateCtrl.text);
    } else {
      provider.updateShoppinglistentry(
        widget.shoppinglistentry!.id,
        nameCtrl.text,
        dateCtrl.text,
        widget.shoppinglistentry!.isDone,
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final entryId = widget.shoppinglistentry?.id ?? UniqueKey().toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.shoppinglistentry == null
              ? 'New Shopping List Entry'
              : 'Edit Shopping List Entry',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Hero(
              tag: 'entry_$entryId',
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: dateCtrl,
              decoration: InputDecoration(
                labelText: 'Shopping Date',
                filled: true,
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  dateCtrl.text =
                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveShoppinglistentry,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
