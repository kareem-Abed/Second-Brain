class Folder {
  String id;
  String title;

  Folder({required this.id, required this.title});

  // Convert an Item into a Map. The keys must correspond to the names of the fields.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
      };

  // A method that converts a Map into an Item.
  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'],
      title: json['title'],
    );
  }
}
