package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.IRiferimentoAttoDomain
import it.finmatica.de4gsdzk.statocivile.*

class TipoAttoUtils {

    static ETipoAtto fromValore(int valore) {

        ETipoAtto ret = null

        for (ETipoAtto e : ETipoAtto.values()) {
            if (e.valore == valore) {
                if (ret)
                    throw new IllegalArgumentException("Valore ETipoAtto ambiguo: " + valore)
                ret = e
            }
        }

        if (!ret)
            throw new IllegalArgumentException("Valore ETipoAtto non riconosciuto: " + valore)

        return ret
    }

    static ETipoAtto fromValoreDefault(int valore) {
        return valore==ETipoAtto.UCI.valore ? ETipoAtto.UCI : fromValore(valore)
    }

    static Boolean isAttoDiAltroComune(Integer tipoAtto){
        return ( (tipoAtto.intValue() == CivCittadinanza.tipoAttoAnnotazioneSuAttoNascitaAltroComune) || (tipoAtto.intValue() == CivMatrimonio.tipoAttoAnnotazioneSuAttoNascitaAltroComune) ||
                 (tipoAtto.intValue() == CivUnioneCivile.tipoAttoAnnotazioneSuAttoNascitaAltroComune)  || (tipoAtto.intValue() == CivMorte.tipoAttoAnnotazioneSuAttoNascitaAltroComune)  ||
                 (tipoAtto.intValue() == CivMatrimonio.tipoAttoAnnotazioneSuAttoMatrimonioAltroComune) || (tipoAtto.intValue() == CivUnioneCivile.tipoAttoAnnotazioneSuAttoUnioneCivileAltroComune) )
    }

    static Boolean isSerieOk(ETipoAtto tipoAttoEnumSource, String serie) {
        Boolean serieOk = Boolean.TRUE
        switch (tipoAttoEnumSource) {
            case ETipoAtto.NAS:
                serieOk = ( ((serie?: "") == "") || (serie == CivTipoAtto.SERIE_A) || (serie == CivTipoAtto.SERIE_B) )
                break
            case ETipoAtto.MAT:
                serieOk = ( ((serie?: "") == "") || (serie == CivTipoAtto.SERIE_A) || (serie == CivTipoAtto.SERIE_B) || (serie == CivTipoAtto.SERIE_C) )
                break
            case ETipoAtto.MOR:
                serieOk = ( ((serie?: "") == "") || (serie == CivTipoAtto.SERIE_A) || (serie == CivTipoAtto.SERIE_B) || (serie == CivTipoAtto.SERIE_C) || serie.toUpperCase().contains(CivTipoAtto.SERIE_BIS) )
                break
        }
        return serieOk
    }

    static Boolean isParteOk(ETipoAtto tipoAttoEnumSource, Integer parte, boolean optional = true) {
        if (parte == null && optional) {
            return true
        }
        if (parte == null && !optional) {
            // parte potrebbe essere null per i processi verbali (natura V)
            // parte è null per le cittadinanze
            return tipoAttoEnumSource == ETipoAtto.UCI ||
                    tipoAttoEnumSource == ETipoAtto.CIT
        }
        switch (tipoAttoEnumSource) {
            case ETipoAtto.NAS: // parte non può essere null
            case ETipoAtto.MAT: // parte non può essere null
            case ETipoAtto.UCI: // parte potrebbe essere null per i processi verbali (natura V)
            case ETipoAtto.MOR: // parte non può essere null
                return (parte?.intValue() == 1) || (parte?.intValue() == 2)
        }
        return true
    }

    static Boolean isAttoOk(Integer i, boolean optional = true) {
        if (i == null && optional) {
            return true
        }
        if (i == null && !optional) {
            return false
        }
        Boolean isAttoOk = (i.compareTo(new Integer(10000)) < 0)
        return isAttoOk
    }

    static Boolean isAnnoOk(Integer i, boolean optional = true) {
        if (i == null && optional) {
            return true
        }
        if (i == null && !optional) {
            return false
        }

        Boolean isAnnoOk = ((i.compareTo(new Integer(1800)) >= 0) && (i.compareTo(new Integer(10000)) < 0))
        return isAnnoOk
    }

    static Boolean isEstremiAttoEmpty(IRiferimentoAttoDomain obj, ETipoAtto tipoAttoEnumSource){
        Boolean emptyMandatoryFields = Boolean.TRUE
        switch (tipoAttoEnumSource) {
            case ETipoAtto.NAS:
            case ETipoAtto.MAT:
            case ETipoAtto.MOR:
                //FIXME: check su obbligatorietà serie per atti "normali" e atti pregressi
                emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) || (obj.parte == null) )
                break
            case ETipoAtto.PUB:
            case ETipoAtto.UCI:
                emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) || (obj.parte == null) )
                break
            case ETipoAtto.PVU:
            case ETipoAtto.CIT:
                //I processi verbali hanno lo stesso tipo_atto delle unioni civili ma non hanno nè parte, nè serie
                //Le cittadinanze non hanno nè parte nè serie
                emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) )
                break
        }
        return emptyMandatoryFields
    }

    static List<Integer> listTipiAttoAltroComunePerAtto(ETipoAtto tipoAttoEnum, Boolean attoDivorzio){
        Integer tipoAttoAnnNasAltroComune = null
        Integer tipoAttoAnnMatAltroComune = null
        switch (tipoAttoEnum) {
            case ETipoAtto.MAT:
                tipoAttoAnnNasAltroComune = new Integer(CivMatrimonio.tipoAttoAnnotazioneSuAttoNascitaAltroComune)
                if (attoDivorzio) {
                    tipoAttoAnnMatAltroComune = new Integer(CivMatrimonio.tipoAttoAnnotazioneSuAttoMatrimonioAltroComune)
                }
                break
            case ETipoAtto.UCI:
                tipoAttoAnnNasAltroComune = new Integer(CivUnioneCivile.tipoAttoAnnotazioneSuAttoNascitaAltroComune)
                if (attoDivorzio) {
                    tipoAttoAnnMatAltroComune = new Integer(CivUnioneCivile.tipoAttoAnnotazioneSuAttoUnioneCivileAltroComune)
                }
                break
            case ETipoAtto.MOR:
                tipoAttoAnnNasAltroComune = new Integer(CivMorte.tipoAttoAnnotazioneSuAttoNascitaAltroComune)
                break
            case ETipoAtto.CIT:
                tipoAttoAnnNasAltroComune = new Integer(CivCittadinanza.tipoAttoAnnotazioneSuAttoNascitaAltroComune)
                break
        }
        List l = []
        if (tipoAttoAnnNasAltroComune){
            l.add(tipoAttoAnnNasAltroComune)
        }
        if (tipoAttoAnnMatAltroComune){
            l.add(tipoAttoAnnMatAltroComune)
        }
        return l
    }

    final static List<ETipoAtto> listaTipiAttoDefault = [ETipoAtto.NAS, ETipoAtto.PUB, ETipoAtto.MAT, ETipoAtto.UCI, ETipoAtto.MOR, ETipoAtto.CIT]

    final static List<ETipoAtto> listaTipiAttoCertificabili = [ETipoAtto.NAS, ETipoAtto.MAT, ETipoAtto.UCI, ETipoAtto.MOR, ETipoAtto.CIT]

}
