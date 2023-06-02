// Importamos el material para agregar las clases de flutter o el material design, es lo mismo.
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tiffanyapp/src/pages/pages.dart';
import 'package:tiffanyapp/src/provider/providers.dart';
import 'package:tiffanyapp/src/tools/preferences.dart';
// Creo el metodo padre del cual es el que ejecuta la aplicacion en su inicio
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  runApp(const AppState());
  }


// Esta es una clase donde importamos un paquete llamado Provider el cual es un gestor de estados
class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider sirve para cargar los providers que yo quiera
    return MultiProvider(
      providers: [
        // Especificamos los providers
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => AdministratorProvider()),
        ChangeNotifierProvider(create: (context) => ClothesProvider()),
        ChangeNotifierProvider(create: (context) => SalesProvider(),)
      ],
      // Ya nomas se lo pasamos al Material
      child: const MyApp(),
    );
  }
}

// Creo una clase extendiendola o heredando de n StatelessWidget la cual hace que no se redibujen los widgets
class MyApp extends StatelessWidget {
// De paso su constructor el cual no espera nada
  const MyApp({Key? key}) : super(key: key);
// El metodo build es lo que hace dibujar el widget
  @override
  Widget build(BuildContext context) {
    //retornamos el MaterialApp para una aplicacion que utiliza material design
    return MaterialApp(
      title: 'Tiffany',
      // Asigno que la app sea en tema negro
      theme: ThemeData(
        brightness: Brightness.dark
      ),
      // Indico que tanto para android y IOS aplicare un idioma
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      // El idioma sera español
      supportedLocales: const [
        Locale("es","ES")
      ],
      // Lo primero que mostrara la app sera la pagina LoginPage
      home: (Preferences.esPrimeraVez)
      ? const AdministratorPage(esPrimeraVez: true,)
      :(Preferences.idAdmin != 0)
      ?const HomePage()
      :const LoginPage(),
    );
  }
}