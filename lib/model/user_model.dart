class UserModel {
  String? uid;
  String? username;
  String? lastname;
  String? email;
  String? imageUrl;

  UserModel({
    this.uid,
    this.username,
    this.lastname,
    this.email,
    this.imageUrl,
  });

  //receiving data from server side
  factory UserModel.fromMap(map) {
    final uid = map['uid'];
    final username = map['username'];
    final lastname = map['lastname'];
    final email = map['email'];
    final imageUrl = map['imageUrl'];
    return UserModel(
      uid: uid,
      username: username,
      lastname: lastname,
      email: email,
      imageUrl: imageUrl,
    );
  }

  //sending data to server side
  //We know that the output of the data we send to the server is of this type Map<String,dynamic>
  // We know that the output of the data we send to the server is of this type Map <String, dynamic> so the output of this method is exactly the input of the method of receiving data from the server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'lastname': lastname,
      'email': email,
      'imageUrl': imageUrl,
    };
  }
}
