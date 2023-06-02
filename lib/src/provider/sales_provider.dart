import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tiffanyapp/src/db/db.dart';
import 'package:tiffanyapp/src/models/sales_details_model.dart';

class SalesProvider extends ChangeNotifier{

  // Creo un mapeo con clave y valor el cual guardara el valor de las fechas
  Map<String, DateTime> fechaMapa = Map.fromEntries([
    MapEntry("fechaInicial",DateTime.now()),
    MapEntry("fechaFinal",DateTime.now())
  ]);

  // Esta lista regresa el total de las ventas de la app a base de fechas
  List<SalesDetailsModel> listaVentas = [];
  // Estas variables mostraran el total que generaron los admins de dinero y prendas
  double total = 0;
  int totalPrendas = 0;

  // Al inicio traera el total de efecto y de prendas
  SalesProvider(){
    consultarVentas(DateFormat("yyyy-MM-dd").format(DateTime.now()),DateFormat("yyyy-MM-dd").format(DateTime.now()));
    consultarTotalPrendas();
  }

  void consultarVentas(String fechaInicial, String fechaFinal) async{
    // Primero limpio la lista
    listaVentas.clear();
    // Consulto el total
    await DB.consultarTotal(fechaInicial, fechaFinal).then((value){
      // Si no viene vacio lo regreso con el total y si viene vacio se le pondra 0
        total = value[0].total?.toDouble() ?? 0;
    });
    // Consulto las ventas
    await DB.consultarVentas(fechaInicial, fechaFinal).then((value) => listaVentas.addAll(value));
    notifyListeners();
  }

  void consultarTotalPrendas() async{
    await DB.consultarTotalPrendas().then((value) => totalPrendas = value[0].total?.toInt()?? 0);
    notifyListeners();
  }

}