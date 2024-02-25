class Chat_user {
  String? image;
  String? about;
  String? name;
  String? id;
  String? lastActive;
  String? isOnline;
  String? pushToken;
  String? last_mes;
  String? email;

  Chat_user(
      {this.image,
        this.about,
        required this.name,
        this.id,
        this.lastActive,
        this.isOnline,
        this.pushToken,
        this.last_mes,
        this.email});

  // to construct objects from server response
  Chat_user.fromJson(Map<String, dynamic> json) {
    // Dart's null safety feature requires all non-nullable instance fields to be initialized
    // either at their declaration or in the constructor. When you initially encountered the error(String name instead of String? name),
    // it was because the name field was declared as non-nullable (String name;), but it wasn't being
    // initialized in the constructor, leading to the error.
    image = json['image'] ?? "";
    about = json['about'] ?? "";
    name = json['name'] ?? "";
    id = json['id'] ?? "";
    lastActive = json['last_active'] ?? "";
    isOnline = json['is_online'] ?? "";
    pushToken = json['push_token'] ?? "";
    last_mes = json["last_mes"] ?? "";
    email = json['email'] ?? "";
  }

  // for sending data to server
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    data['push_token'] = pushToken;
    data['email'] = email;
    return data;
  }
}