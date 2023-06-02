// Realizo importaciones
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiffanyapp/src/provider/login_provider.dart';
import 'package:tiffanyapp/src/tools/validations.dart';
import 'package:tiffanyapp/src/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    // El widget Scaffold es el encargado de utilizar toda la pantalla
    return Scaffold(
      // SingleChildScrollView indica que la pagina puede generar scroll
      body: SingleChildScrollView(
        child: Column(
          // children indica los hijos que esta puede tener
          children: [
            // SizedBox es un contenedor que le puedes definir un tamaño, en este caso pondre un tamaño de 290px
            //que de hijo guarda una imagen la cual con el fit se expande hasta adaptarse a los 290px
            SizedBox(
                height: 290,
                child: Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.cover,
                )),
            // ClipRRect genera un borde redondeado a los widgets hijos, en este caso sera a la imagen icono
            ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                child: Image.asset(
                  "assets/icono.jpg",
                  height: 150,
                )),
            const SizedBox(
              height: 10,
            ),
            const Text("Iniciar sesion",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _Formulario(),
            ),
          ],
        ),
      ),
    );
  }
}
// Cree esta clase para separar el codigo
class _Formulario extends StatefulWidget {
  

  const _Formulario({Key? key,}) : super(key: key);

  @override
  State<_Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<_Formulario> {
  // Indico los controladores
  final TextEditingController _controllerUsuario = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
      // Form se utiliza para validar los campos
    return Form(
      // Color el formulario del provider
      key: loginProvider.formulario,
      // Regreso una columna
      child: Column(
        children: [
          // Coloco los inputs con sus parametros requeridos
          InputWidget(
            label: "Usuario",
            icono: Icons.person,
            control: _controllerUsuario,
            validacion: (valor) =>
                Validations.valCampo(_controllerUsuario.text, "El usuario no puede ir vacio"),
          ),
          const SizedBox(
            height: 10,
          ),
           InputWidget(label: "Contraseña",icono: Icons.lock,control: _controllerPassword,validacion: (valor)=>Validations.valCampo(_controllerPassword.text,"La contraseña no puede ir vacia")),
          const SizedBox(
            height: 20,
          ),
          ButtonWidget(
              texto: "Iniciar sesion",
              funcion: () async {
                loginProvider.esValidoFormulario(context,_controllerUsuario.text, _controllerPassword.text);
              },
              esTamanoCompleto: true,)
        ],
      ),
    );
  }
}
