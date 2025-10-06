package restrict.statocivile

import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.IAttoMatUci
import it.finmatica.de4gsdzk.ISoggettoAtto1Base
import it.finmatica.de4gsdzk.utils.DataUtils
import it.finmatica.de4gsdzk.utils.ENaturaAtto

trait TraitStampaAttoCampi{

    abstract String getEtichettaCustom(String codice)

    abstract String getEtichettaEnum(Enum e, String etichettaDefault=null)

    Closure<?> calcolaValoreNameEnum = { CivAttoBaseDomain e, String propertyName ->
        return e."$propertyName"?.name()
    }

    Closure<?> calcolaValoreExportLista = { CivAttoBaseDomain e, String propertyName ->
        if (e.natura == ENaturaAtto.N){
            return null
        }
        return e."$propertyName"
    }

    Closure<?> calcolaValoreExportEnum = { CivAttoBaseDomain e, String propertyName ->
        if (e.natura == ENaturaAtto.N){
            return null
        }
        if ( (e instanceof IAttoMatUci) && (e."$propertyName" instanceof Boolean) ){
            if (e.divorzio){
                getEtichettaCustom("AttoDivorzio")
            } else {
                getEtichettaEnum(getTipoAttoEnum())
            }
        } else {
            getEtichettaEnum(e."$propertyName")
        }
    }

    //Può essere il record di un atto o di una rubrica nascita: implementare controllo
    Closure<?> calcolaValoreExportPdf = { def e, String propertyName ->
        if ( (e instanceof CivAttoBaseDomain) && (e.natura == ENaturaAtto.N) ){
            return null
        }
        if (propertyName.startsWith("comune")){
            //calcolaValoreExportComune.call(e, propertyName)
            String luogo = propertyName.substring(6,7).toUpperCase()+propertyName.substring(7)
            String desc = e."descrizioneComune$luogo"
            String prov = e."siglaProvincia$luogo"
            return desc ? desc + (prov ? " (" + prov + ")" : "") : ""
        } else {
            if (e."$propertyName" instanceof Date){
                return DataUtils.fromDateToString(e."$propertyName")
            }
            return e."$propertyName"
        }
    }

    Closure<?> calcolaValoreExportStringFromInteger = { def e, String propertyName ->
        if (e != null) {
            Integer i = e."$propertyName"
            if (i != null){
                return String.valueOf(e."$propertyName")
            } else{
                return null
            }
        } else {
            return null
        }
    }

    Closure<?> calcolaValoreExportNull = { ISoggettoAtto1Base e, String p -> null }
}