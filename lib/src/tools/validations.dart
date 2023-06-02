// Esta clase tendra las validaciones para cada input
class Validations{

  static String? valCampo(String valor, String campo){
    if(valor == ""){
      return campo;
    } else{
      return null;
    }
  }

    static String? valExistencias(String valor){
    if(valor == ""){
      return "Las existencias no pueden ir vacias";
    } else{
      String pattern = "^[0-9]+\$";
      RegExp regExp = RegExp(pattern);
      if(!regExp.hasMatch(valor)){
        return "El codigo solo lleva numeros";
      } else{
      return null;
      }
    }
  }

  static String? valCodigo(String valor){
    if(valor == ""){
      return "El codigo no puede ir vacio";
    } else{
      String pattern = "^[0-9]+\$";
      RegExp regExp = RegExp(pattern);
      if(!regExp.hasMatch(valor)){
        return "El codigo solo lleva numeros";
      } else{
        if(valor.length < 5){
          return "El codigo lleva 5 digitos";
        } else{
          return null;
        }
      }
    }
  }

  static String? valPrecio(String valor){

if(valor == ""){
      return "El precio no puede ir vacio";
    } else{
      if(valor[0] == "."){
        return "Ingresa un precio valido";
      } else{
        String pattern = "^[0-9.]+\$";
      RegExp regExp = RegExp(pattern);
      if(!regExp.hasMatch(valor)){
        return "El precio solo lleva numeros";
      } else{
        return null;
      }
      }
    }
  }
    static String? valNombre(String valor){
      String pattern = "^[a-zA-Z áéíóú]+\$";
      RegExp regExp = RegExp(pattern);
    if(valor == ""){
      return "El nombre no puede ir vacio";
    } else{
      if(!regExp.hasMatch(valor)){
        return "El nombre solo lleva letras";
      }
      return null;
    }
  }

}