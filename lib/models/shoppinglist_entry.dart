// ---------------------------
// Datamodell for a shopping list entry
// ---------------------------
class Shoppinglistentry {
  final String id;

  // name of shopping item
  final String name;

  //Date of shopping
  final String shoppingdate;

  final bool isDone;
  //constructor
  Shoppinglistentry({
    required this.id,
    required this.name,
    required this.shoppingdate,
    required this.isDone,
  });

  Map<String, dynamic> toMap() => {'name': name, 'shoppingdate': shoppingdate};
  factory Shoppinglistentry.fromMap(String id, Map<String, dynamic> data) {
    return Shoppinglistentry(
      id: id, // Dokument-ID
      name: data['name'],
      shoppingdate: data['shoppingdate'],
      isDone: data['isDone'] ?? false,
    );
  }
}
