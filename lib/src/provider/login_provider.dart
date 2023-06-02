import 'package:flutter/cupertino.dart';
import 'package:tiffanyapp/src/db/db.dart';
import 'package:tiffanyapp/src/pages/home_page.dart';
import 'package:tiffanyapp/src/tools/preferences.dart';

// Esta clase manejara el estado de inicio de sesion
class LoginProvider extends ChangeNotifier {
  // GlobalKey sirve para ver el estado del fomulario
  GlobalKey<FormState> formulario = GlobalKey<FormState>();

  // Este metodo regresa si el formulario se valido o no
  Future<bool> esValidoFormulario(
      BuildContext context, String usuario, String password) async {
    // En caso de que si regresa verdadero
    if (formulario.currentState!.validate()) {
      // Hace la consulta
      await DB.consultarAdmin(usuario, password).then((value) {
        // Si no viene vacio es por que el usuario existe
        if (value.isNotEmpty) {
          Preferences.idAdmin = value[0].idAdmin!;
          Preferences.idTipo = value[0].idTipo!;
          Preferences.nombre = value[0].nombre;
          Preferences.usuario = value[0].usuario;
          // Navigator se usa para las rutas, en este caso usare pushAndRemoveUntil el cual indica que entrara en la pagina HomePage sin que puedas regresar
          // a LoginPage al menos que cierres
          Navigator.pushAndRemoveUntil(context,CupertinoPageRoute(builder: (_) => const HomePage()),(route) => false);
        } else {
          _alerta(context);
        }
      });
    }
    // Si no pos regresa un falso
    return formulario.currentState?.validate() ?? false;
  }

  void _alerta(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
        title: const Text("Error"),
        content: const Text("El usuario o contraseña es incorrecto o no existe."),
        actions: [
          CupertinoDialogAction(onPressed: ()=>Navigator.pop(context),child: const Text("Cerrar"))
        ],
    ));
  }
}
