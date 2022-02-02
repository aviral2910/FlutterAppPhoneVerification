class ItemsModel {
  final String ids, title, description, image;
  DateTime date;
  ItemsModel(
      {required this.ids,
      required this.title,
      required this.description,
      required this.image,
      required this.date});

  ItemsModel.fromJson(Map<String, Object?> json)
      : this(
            ids: json["ids"] as String,
            title: json["title"] as String,
            description: json['description']! as String,
            image: json['image'] as String,
            date: json['date'] as DateTime);

  Map<String, Object?> toJson() => {
        "ids": ids,
        'title': title,
        'description': description,
        'image': image,
        'date': date
      };
}
