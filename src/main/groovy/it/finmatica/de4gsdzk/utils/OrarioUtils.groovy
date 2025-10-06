package it.finmatica.de4gsdzk.utils

class OrarioUtils {

    static Boolean isOraValida(String ora){
        if ( (ora?:"") == "" ){
            return true
        }
        try {
            int o = Integer.parseInt(ora)
            if (o > 24){
                return false
            }
            if (o < 0){
                return false
            }
        } catch (NumberFormatException ex){
            return false
        }
        return true
    }

    static Boolean isMinutoValido(String minuto){
        if ( (minuto?:"") == "" ){
            return true
        }
        try {
            int o = Integer.parseInt(minuto)
            if (o > 59){
                return false
            }
            if (o < 0){
                return false
            }
        } catch (NumberFormatException ex){
            return false
        }
        return true
    }


}
