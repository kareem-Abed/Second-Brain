class Folder {
  String id;
  int index;
  String title;
  String icon;

  Folder(
      {required this.id,
      required this.title,
      required this.icon,
      required this.index});

  // Convert an Item into a Map. The keys must correspond to the names of the fields.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'icon': icon,
        'index': index,
      };

  // A method that converts a Map into an Item.
  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'],
      title: json['title'],
      icon: json['icon'],
      index: json['index'] ?? 0,
    );
  }
}
