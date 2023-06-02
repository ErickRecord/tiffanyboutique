// Este sera el modelo del administrador
class AdministratorModel {
  int? idAdmin;
  String nombre;
  String usuario;
  String password;
  String? tipo;
  int? idTipo;
  int bandera;

// Solicito parametros
  AdministratorModel(
      {this.idAdmin,
      this.tipo,
      this.idTipo,
      required this.nombre,
      required this.usuario,
      required this.password,
      required this.bandera});

  // Este constructor.fromMap es para parsear un objeto y convertirlo a un mapa
  factory AdministratorModel.fromMap(Map<String, dynamic> map) =>
      AdministratorModel(
          idAdmin: map["idAdmin"],
          nombre: map["nombre"],
          usuario: map["usuario"],
          password: map["password"],
          idTipo: map["idTipo"],
          tipo: map["tipo"],
          bandera: map["bandera"]);
  // Regresa un mapa el cual lo uso para regresar la info a la db
  Map<String, dynamic> toMap() => {
        "nombre": nombre,
        "usuario": usuario,
        "password": password,
        "idTipo": idTipo,
        "bandera": bandera
      };
}
