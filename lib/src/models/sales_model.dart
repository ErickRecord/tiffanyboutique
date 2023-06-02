class SalesModel{
  int? idVenta;
  int? idAdmin;
  double? totalGanancias;
  num? total;
  String? fecha;
  SalesModel({this.idVenta,  this.idAdmin,  this.fecha, this.total, this.totalGanancias});

  // Este constructor.fromMap es para parsear un objeto y convertirlo a un mapa
  factory SalesModel.fromMap(Map<String, dynamic> map) => SalesModel(total:map["total"]);
  
  // Genere dos diferentes por que ocupo uno para las ventas totales y el otro para las del admin
  factory SalesModel.fromMapAdmin(Map<String, dynamic> map) => SalesModel(total:map["totalVentas"],totalGanancias: map["total"]);

  // Regresa un mapa el cual lo uso para regresar la info a la db
  Map<String, dynamic> toMap()=>{
    "idVenta" : idVenta,
    "idAdmin" : idAdmin,
    "total" : total,
    "fecha" : fecha
  };

}