class User {
  final BigInt id;
  final String username;
  final String characterName;
  final String tierName;
  final BigInt xp;
  final int evoState;
  final String evoImage;

  User(this.id, this.username, this.characterName, this.tierName, this.xp,
      this.evoState, this.evoImage);

  // Consumes JSON
  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        characterName = json['characterName'],
        tierName = json['tierName'],
        xp = json['xp'],
        evoState = json['evoState'],
        evoImage = json['evoImage'];

  // Produce JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'characterName': characterName,
        'tierName': tierName,
        'xp': xp,
        'evoState': evoState,
        'evoImage': evoImage,
      };
}
