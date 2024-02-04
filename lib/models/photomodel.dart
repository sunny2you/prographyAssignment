class PhotoModel {
  final String id, username, description;

  PhotoModel(
      {required this.id, required this.username, required this.description});

  PhotoModel.fromJson(Map<String, dynamic> json)
      : id = json['urls']['regular'],
        username = json['user']['username'],
        description = json['alt_description'] ??
            'json["description"]' ??
            'json["created_at"]';
}
