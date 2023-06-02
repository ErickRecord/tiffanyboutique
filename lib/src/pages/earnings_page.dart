import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiffanyapp/src/models/sales_details_model.dart';

class EarningsPage extends StatelessWidget {
  // Solicito la lista que tendra el total de las ganancias
  final List<SalesDetailsModel> listaTotalVenta;
  const EarningsPage({super.key, required this.listaTotalVenta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ventas totales"),
      ),
      // Genero una lista
      body: ListView.builder(
        // Defino de que tamaño sera
        itemCount: listaTotalVenta.length,
        // Le paso el contexto y un contador
        itemBuilder: (_, int i){
        // retorno una ListTile
        return  ListTile(
          // Le asigno el icono de dolar que esta en la parte izquierda
          leading: const FaIcon(FontAwesomeIcons.dollarSign,color: Colors.green,),
          // Le asigno la canitdad
          title: Text("${listaTotalVenta[i].total}"),
          // La fecha
          subtitle: Text("${listaTotalVenta[i].admin} --- ${listaTotalVenta[i].fecha}"),
          // Y cuantas prendas se vendieron ese dia
          trailing: Text("${listaTotalVenta[i].cantidad} Prendas"),
        );
      }),
    );
  }
}