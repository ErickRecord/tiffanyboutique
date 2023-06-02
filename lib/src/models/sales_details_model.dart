class SalesDetailsModel {
  int? idDetallesVentas;
  int idVenta;
  int? idPrenda;
  int cantidad;
  double totalPrenda;
  String? admin;
  double? total;
  String? fecha;

  SalesDetailsModel(
      {this.idDetallesVentas,
      required this.idVenta,
      this.idPrenda,
      required this.cantidad,
      required this.totalPrenda,
      this.admin,
      this.fecha,
      this.total});
  // Este constructor.fromMap es para parsear un objeto y convertirlo a un mapa
  factory SalesDetailsModel.fromMap(Map<String, dynamic> map) =>
      SalesDetailsModel(
          idVenta: map["idVenta"],
          total: map["total"],
          admin: map["usuario"],
          fecha: map["fecha"],
          cantidad: map["cantidad"],
          totalPrenda: map["totalPrenda"],
          );
  // Regresa un mapa el cual lo uso para regresar la info a la db
  Map<String, dynamic> toMap() => {
        "idVenta": idVenta,
        "idPrenda": idPrenda,
        "cantidad": cantidad,
        "total": totalPrenda
      };
}
