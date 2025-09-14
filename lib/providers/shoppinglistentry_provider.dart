import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justshop/models/shoppinglist_entry.dart';
import 'package:justshop/models/shoppinglist.dart';

class ShoppinglistProvider with ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final List<Shoppinglistentry> _shoppinglistentries = [];
  final List<Shoppinglist> _shoppinglists = [];

  List<Shoppinglistentry> get shoppinglistentries => [
    ..._shoppinglistentries,
  ]; // return a copy

  List<Shoppinglist> get shoppinglists => [..._shoppinglists]; // return a copy

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

  //get shoppinglistitems for a specific date
  Future<void> fetchShoppinglistentriesForDate(String date) async {
    print("fetch for date: $date");
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('shoppinglistentries')
        .where('shoppingdate', isEqualTo: date)
        .get();
    _shoppinglistentries.clear();
    _shoppinglistentries.addAll(
      snap.docs.map((doc) => Shoppinglistentry.fromMap(doc.id, doc.data())),
    );
    notifyListeners();
  }

  //Fetch and group shoppinglistentries by shoppingdate
  Future<void> fetchGroupedShoppinglists() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('shoppinglistentries')
        .get();

    //Group entries by shoppingdate
    Map<String, List<Shoppinglistentry>> grouped = {};
    List<Shoppinglistentry> allEntries = [];
    for (var doc in snap.docs) {
      final entry = Shoppinglistentry.fromMap(doc.id, doc.data());
      allEntries.add(entry);
      final date = entry.shoppingdate;
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(entry);
    }
    _shoppinglistentries.clear();
    _shoppinglistentries.addAll(allEntries);

    _shoppinglists.clear();

    grouped.forEach((date, entries) {
      _shoppinglists.add(
        Shoppinglist(name: date, shoppingitemsCount: entries.length),
      );
    });
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
      Shoppinglistentry(
        id: docRef.id,
        name: name,
        shoppingdate: shoppingdate,
        isDone: false,
      ),
    );
    fetchGroupedShoppinglists();
    notifyListeners();
  }

  Future<void> updateShoppinglistentry(
    String id,
    String name,
    String shoppingdate,
    bool isDone,
  ) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _db
        .collection('users')
        .doc(uid)
        .collection('shoppinglistentries')
        .doc(id)
        .update({'name': name, 'shoppingdate': shoppingdate, 'isDone': isDone});

    final index = _shoppinglistentries.indexWhere((note) => note.id == id);
    if (index != -1) {
      _shoppinglistentries[index] = Shoppinglistentry(
        id: id,
        name: name,
        shoppingdate: shoppingdate,
        isDone: isDone,
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

  Future<void> switchShoppinglistentryStatus(String id) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    bool newStatus = !_shoppinglistentries
        .firstWhere((entry) => entry.id == id)
        .isDone;
    await _db
        .collection('users')
        .doc(uid)
        .collection('shoppinglistentries')
        .doc(id)
        .update({'isDone': newStatus});

    final index = _shoppinglistentries.indexWhere((note) => note.id == id);
    if (index != -1) {
      _shoppinglistentries[index] = Shoppinglistentry(
        id: id,
        name: _shoppinglistentries[index].name,
        shoppingdate: _shoppinglistentries[index].shoppingdate,
        isDone: newStatus,
      );
      notifyListeners();
    }
  }
}
