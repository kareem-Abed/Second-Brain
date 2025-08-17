class Item {
          String id;
          String listId;
          String title;
          bool isCompleted;

          Item({
            required this.id,
            required this.listId,
            required this.title,
            this.isCompleted = false,  // Default value
          });

          Map<String, dynamic> toJson() {
            return {
              'id': id,
              'listId': listId,
              'title': title,
              'isCompleted': isCompleted,
            };
          }

          factory Item.fromJson(Map<String, dynamic> json) {
            return Item(
              id: json['id'] as String,
              listId: json['listId'] as String,
              title: json['title'] as String,
              isCompleted: json['isCompleted'] as bool? ?? false,  // Handle null case
            );
          }
        }