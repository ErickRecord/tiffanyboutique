import 'package:flutter/foundation.dart';

class ClothesModel {
  int? idPrenda;
  Uint8List? imagen;
  String codigo;
  String nombre;
  int existencia;
  double precio;
  String color;
  int idCategoria;
  String? categoria;
  int bandera;

  ClothesModel(
      {this.idPrenda,
      this.categoria,
      this.imagen,
      required this.codigo,
      required this.nombre,
      required this.existencia,
      required this.precio,
      required this.color,
      required this.idCategoria,
      required this.bandera});
      
  // Este constructor.fromMap es para parsear un objeto y convertirlo a un mapa
  factory ClothesModel.fromMap(Map<String, dynamic> map) => ClothesModel(
      idPrenda: map["idPrenda"],
      categoria: map["categoria"],
      imagen: map["imagen"],
      codigo: map["codigo"],
      nombre: map["nombre"],
      existencia: map["existencia"],
      precio: map["precio"],
      color: map["color"],
      idCategoria: map["idCategoria"],
      bandera: map["bandera"]);

  // Regresa un mapa el cual lo uso para regresar la info a la db
  Map<String, dynamic> toMap() => {
    // Los if los uso para validar si se manda el idPrenda o imagen
    // Lo coloco para cuando haga un update se mande el idPrenda con la imagen
    // Ya si solo agrego una prenda  nomas no se mandaria el idPrenda
        if(idPrenda != null) "idPrenda": idPrenda,
        if(imagen != null) "imagen": imagen,
        "codigo": codigo,
        "nombre": nombre,
        "existencia": existencia,
        "precio": precio,
        "color": color,
        "idCategoria": idCategoria,
        "bandera": bandera
      };
}
