class Company {
  String id;
  String rut;
  String name;
  String sector;
  String codSII;
  String address;
  String city;
  String commune;

  Company({
    this.id,
    this.rut,
    this.name,
    this.sector,
    this.codSII,
    this.address,
    this.city,
    this.commune,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['idEmpresa'],
      rut: json['rut'],
      name: json['razonSocial'],
      sector: json['giro'],
      codSII: json['cdgsii'],
      address: json['direccion'],
      city: json['ciudad'],
      commune: json['comuna'],
    );
  }
}
