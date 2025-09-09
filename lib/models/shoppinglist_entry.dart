// ---------------------------
// Datamodell for a shopping list entry
// ---------------------------
class Shoppinglistentry {
  final String id;

  // name of shopping item
  final String name;

  //Date of shopping
  final String shoppingdate;

  //constructor
  Shoppinglistentry({
    required this.id,
    required this.name,
    required this.shoppingdate,
  });

  Map<String, dynamic> toMap() => {'name': name, 'shoppingdate': shoppingdate};
  factory Shoppinglistentry.fromMap(String id, Map<String, dynamic> data) {
    return Shoppinglistentry(
      id: id, // Dokument-ID
      name: data['name'], // Feld "title" aus Firestore
      shoppingdate: data['shoppingdate'], // Feld "content" aus Firestore
    );
  }
}
