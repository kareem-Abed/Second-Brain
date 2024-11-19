class Item {
  String id;
  String listId;
  String title;

  Item({required this.id, required this.listId, required this.title});

  // Convert an Item into a Map. The keys must correspond to the names of the fields.
  Map<String, dynamic> toJson() => {
        'id': id,
        'listId': listId,
        'title': title,
      };

  // A method that converts a Map into an Item.
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      listId: json['listId'],
      title: json['title'],
    );
  }
}