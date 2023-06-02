import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiffanyapp/src/pages/pages.dart';
import 'package:tiffanyapp/src/tools/preferences.dart';
class NavigationWidget extends StatelessWidget {
  const NavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Drawer es la navegacion que se ve al presinar el boton de hamburguesa
    return Drawer(
      // Retorno una lista sin padding
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Asigno la imagen superior
          DrawerHeader(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/icono.jpg"),
                      fit: BoxFit.cover)),
              child: Container()),
        // Coloco cada parte de la navegacion
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.gauge),
          title: const Text("Inicio"),
          onTap: ()=>Navigator.push(context, CupertinoPageRoute(builder: (_)=>const HomePage())),
        ),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.shirt),
          title: const Text("Alta prenda"),
          onTap: (){
            Navigator.pop(context);
            Navigator.push(context, CupertinoPageRoute(builder: (_)=>const ClothesDetailsPage(estaComprando: false,)));
          },
        ),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.list),
          title: const Text("Ver prendas"),
          onTap: (){
            Navigator.pop(context);
            Navigator.push(context, CupertinoPageRoute(builder: (_)=>const ClothesPage(estaComprando: false,)));
          },
        ),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.dollarSign),
          title: const Text("Registrar venta"),
          onTap: (){
            Navigator.pop(context);
            Navigator.push(context, CupertinoPageRoute(builder: (_)=>const ClothesPage(estaComprando: true)));
          },
        ),
        if(Preferences.idTipo == 1)
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.users),
          title: const Text("Administradores"),
          onTap: (){
            Navigator.pop(context);
            Navigator.push(context, CupertinoPageRoute(builder: (_)=>const AdministratorsPage()));
          },
            ),
          Ink(
            color: Colors.red,
            child: ListTile(
              leading: const Icon(Icons.output),
              title: const Text("Cerrar sesion"),
              onTap: () {
                Preferences.idAdmin = 0;
                Preferences.idTipo = 0;
                Preferences.nombre = "";
                Preferences.usuario = "";
                Navigator.pushAndRemoveUntil(context,CupertinoPageRoute(builder: (_) => const LoginPage()),(route) => false);
              },
            ),
          ),
        
        ],
      ),
    );
  }
}
