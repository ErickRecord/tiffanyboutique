import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tiffanyapp/src/models/clothes_model.dart';
import 'package:tiffanyapp/src/pages/pages.dart';
import 'package:tiffanyapp/src/provider/providers.dart';
import 'package:tiffanyapp/src/tools/preferences.dart';
import 'package:tiffanyapp/src/widgets/widgets.dart';

class TotalSalePage extends StatefulWidget {
  final List<ClothesModel> listaPrenda;
  const TotalSalePage({super.key, required this.listaPrenda});

  @override
  State<TotalSalePage> createState() => _TotalSalePageState();
}

class _TotalSalePageState extends State<TotalSalePage> {
  double total = 0;
  int cantidad = 0;
  double precio = 0;
  @override
  Widget build(BuildContext context) {
    final clothesProvider = Provider.of<ClothesProvider>(context);    
    return Scaffold(
      appBar: AppBar(
        // Asigno un titulo en la parte superior
        title: const Text("Total"),
      ),
      // Indico que tendra scroll
      body: SingleChildScrollView(
        // Genero una columna
        child: Column(
          children: [
            // Recorro la lista que mandare por parametros despues
            ListView.builder(
              // Indico que tendra scroll
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // Indico sus elementos
              itemCount: clothesProvider.listaPrendasCarrito.length,
              itemBuilder: (_,int i){
                // Retorno las tarjetas
                // return Text(widget.listaPrenda[i].nombre);
                return ClothesCardWidget(estaComprando: true,prenda: clothesProvider.listaPrendasCarrito[i],estaEnCarrito: true,);
              }),
              // Asigno un espacio
              const SizedBox(height: 30),
              // Muestro el total
              Text("Total: \$${clothesProvider.totalVenta()}",style: const TextStyle(fontSize: 25)),
            const SizedBox(height: 30),
            // Muestro el vendedor
            const Text("Atendido por:",style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 146, 145, 145))),
            const SizedBox(height: 10),
            Text(Preferences.nombre,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Color.fromARGB(255, 146, 145, 145))),
            // Y mustro el boton
            Padding(
              padding: const EdgeInsets.all(15),
              child: ButtonWidget(
                  texto: "Registrar compra",
                  funcion: (){
                    // Al presionar el boton genera la venta, se redibuja el dashboard, manda un mensaje de que agrego y te manda a HomePage
                    clothesProvider.registrarVenta(Preferences.idAdmin);
                    Provider.of<SalesProvider>(context,listen: false).consultarVentas(DateFormat("yyyy-MM-dd").format(DateTime.now()),DateFormat("yyyy-MM-dd").format(DateTime.now()));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Venta registrada con exito")));
                    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (_)=>const HomePage()), (route) => false);
                  },
                  esTamanoCompleto: true),
            ),
          ],
        ),
      ),
    );
  }
}

