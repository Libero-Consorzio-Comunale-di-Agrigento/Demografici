package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.archivi.ArcComune

class ComuneUtils {

    static Boolean stessiCodici(Integer codiceComune, Integer codiceProvincia, ArcComune c){
        return stessiCodici(codiceComune, codiceProvincia, c?.codiceComune, c?.codiceProvincia)
    }

    static Boolean stessiCodici(Integer codiceComune, Integer codiceProvincia, Integer codiceComuneConfronto, Integer codiceProvinciaConfronto){
        if ( (codiceComune != null) && (codiceProvincia != null) ){
            if ((codiceComuneConfronto != null) && (codiceProvinciaConfronto != null) ){
                return ( (codiceComuneConfronto.compareTo(codiceComune) == 0) && (codiceProvinciaConfronto.compareTo(codiceProvincia) == 0) )
            } else {
                return false
            }
        }
        return false
    }

}
