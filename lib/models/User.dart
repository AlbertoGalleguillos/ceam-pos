class User {
  final int id;
  final int username;
  final String name;
  final String typeTitle;
  final String rut;

  User({this.username, this.id, this.name, this.typeTitle, this.rut});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['idEmpresa'],
      username: json['login'],
      name: json['tipoUsuario'],
      typeTitle: json['tipoUsuario'],
      rut: json['rut'],
    );
  }
}
