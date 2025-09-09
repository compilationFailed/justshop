import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justshop/models/shoppinglist_entry.dart';

class ShoppinglistProvider with ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final List<Shoppinglistentry> _shoppinglistentries = [];

  List<Shoppinglistentry> get shoppinglistentries => [
    ..._shoppinglistentries,
  ]; // return a copy

  Future<void> fetchShoppinglistentries() async {
    print("fetch");
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('shoppinglistentries')
        .get();
    _shoppinglistentries.clear();
    _shoppinglistentries.addAll(
      snap.docs.map((doc) => Shoppinglistentry.fromMap(doc.id, doc.data())),
    );
    notifyListeners();
  }

  Future<void> addShoppinglistentry(String name, String shoppingdate) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = await _db
        .collection('users')
        .doc(uid)
        .collection('shoppinglistentries')
        .add({'name': name, 'shoppingdate': shoppingdate});
    _shoppinglistentries.add(
      Shoppinglistentry(id: docRef.id, name: name, shoppingdate: shoppingdate),
    );
    notifyListeners();
  }

  Future<void> updateShoppinglistentry(
    String id,
    String name,
    String shoppingdate,
  ) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _db
        .collection('users')
        .doc(uid)
        .collection('shoppinglistentries')
        .doc(id)
        .update({'name': name, 'shoppingdate': shoppingdate});

    final index = _shoppinglistentries.indexWhere((note) => note.id == id);
    if (index != -1) {
      _shoppinglistentries[index] = Shoppinglistentry(
        id: id,
        name: name,
        shoppingdate: shoppingdate,
      );
      notifyListeners();
    }
  }

  Future<void> deleteShoppinglistentry(String id) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _db
        .collection('users')
        .doc(uid)
        .collection('shoppinglistentries')
        .doc(id)
        .delete();
    _shoppinglistentries.removeWhere(
      (shoppinglistentry) => shoppinglistentry.id == id,
    );
    notifyListeners();
  }
}
