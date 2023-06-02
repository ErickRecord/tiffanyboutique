// Este sera el modelo de los tipos de administradores
class TypeAdminModel {
  int idTipo;
  String nombre;
  TypeAdminModel({required this.idTipo, required this.nombre});

  // Este constructor.fromMap es para parsear un objeto y convertirlo a un mapa
  factory TypeAdminModel.fromMap(Map<String, dynamic> map) =>
      TypeAdminModel(
        idTipo: map["idTipo"],
        nombre: map["nombre"]
        );
  // Regresa un mapa el cual lo uso para regresar la info a la db
  Map<String, dynamic> toMap() => {
    "idTipo": idTipo,
    "nombre": nombre
    };
}
