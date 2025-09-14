// ---------------------------
// Datamodell for a shopping list
// ---------------------------
class Shoppinglist {
  // name of shopping item
  final String name;

  //Count of shopping items
  final int shoppingitemsCount;

  //constructor
  Shoppinglist({required this.name, required this.shoppingitemsCount});

  Map<String, dynamic> toMap() => {
    'name': name,
    'shoppingitemsCount': shoppingitemsCount,
  };
  factory Shoppinglist.fromMap(String id, Map<String, dynamic> data) {
    return Shoppinglist(
      name: data['name'],
      shoppingitemsCount: data['shoppingitemsCount'],
    );
  }
}
