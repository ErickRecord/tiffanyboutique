class CategoriesModel {
  int idCategoria;
  String nombre;
  CategoriesModel({required this.idCategoria, required this.nombre});

  // Este constructor.fromMap es para parsear un objeto y convertirlo a un mapa
  factory CategoriesModel.fromMap(Map<String, dynamic> map) =>
      CategoriesModel(
        idCategoria: map["idCategoria"],
        nombre: map["nombre"]);
        
  // Regresa un mapa el cual lo uso para regresar la info a la db
  Map<String, dynamic> toMap ()=>{
    "idCategoria" : idCategoria,
    "nombre" : nombre
  };
}
