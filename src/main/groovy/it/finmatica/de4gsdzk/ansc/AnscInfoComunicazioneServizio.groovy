package it.finmatica.de4gsdzk.ansc

import groovy.json.JsonException
import groovy.json.JsonSlurper
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.utils.AnscPaginazione
import it.finmatica.de4gsdzk.utils.DataUtils
import it.finmatica.de4gsdzk.utils.ETipoContenutoAnsc
import it.finmatica.de4gsdzk.utils.ETipologiaAnsc

class AnscInfoComunicazioneServizio{

    private final String retVal
    private final Long idComunicazione
    private final String stringResponse

    AnscInfoComunicazioneServizio(String retVal, Long idComunicazione){
        this.retVal = retVal
        this.idComunicazione = idComunicazione
        this.stringResponse = null
    }

    AnscInfoComunicazioneServizio(String retVal, Long idComunicazione, String stringResponse){
        this.retVal = retVal
        this.idComunicazione = idComunicazione
        this.stringResponse = stringResponse
    }

    String getRetVal() {
        return retVal
    }

    Long getIdComunicazione() {
        return idComunicazione
    }

    String getStringResponse() {
        return stringResponse
    }

    AnscInfoEvento getInfoEvento(){
        AnscInfoEvento infoEvento = null
        if (stringResponse){
            try {
                def jsonResponse = new JsonSlurper().parseText(stringResponse)
                if (jsonResponse?.modelEventoDTO instanceof ArrayList){
                    def eventoNotifica = jsonResponse.modelEventoDTO.get(0)
                    String idAnsc = eventoNotifica.idAnsc
                    String testo = eventoNotifica.composizioneCompleta
                    ETipoContenutoAnsc tipoContenutoAnsc = AnscUtils.fromValoreTipoContenuto(new Integer(eventoNotifica.idtipocontenuto))

                    def evePrimario = eventoNotifica.eventoPrimario

                    infoEvento = new AnscInfoEvento(idAnsc,
                            tipoContenutoAnsc,
                            testo)


                    if (evePrimario != null) {
                        ETipologiaAnsc tipologiaAnscPrimario = AnscUtils.fromValoreTipologia(evePrimario.tipologia as Integer)
                        Comune comunePrimario = new Comune(descrizione: evePrimario.nomeComuneRegistrazione, siglaProvincia: evePrimario.siglaProvinciaRegistrazione)
                        EstremiAtto estremiAttoPrimario = new EstremiAtto(idAttoAnsc: evePrimario.idAnsc, atto: evePrimario.numeroatto as Integer, parte: evePrimario.parte as Integer, serie: evePrimario.serie, anno: evePrimario.annoAtto as Integer)

                        infoEvento.setPrimario(tipologiaAnscPrimario, comunePrimario, estremiAttoPrimario)
                    }
                }
            } catch (JsonException jex){
                // FIXME: gestire errore specifico?
                infoEvento = null
            }
        }
        return infoEvento
    }

    AnscPaginazione getPaginazione(){
        AnscPaginazione paginazione = null
        if (stringResponse){
            try {
                def jsonResponse = new JsonSlurper().parseText(stringResponse)
                if (jsonResponse?.datiPaginazione instanceof Map){
                    def datiPaginazione = jsonResponse.datiPaginazione
                    paginazione = new AnscPaginazione(datiPaginazione?.numPagina, datiPaginazione?.numRecordPagina, datiPaginazione?.numRecordTotali)
                }
            } catch (JsonException jex){
                // FIXME: gestire errore specifico?
                paginazione = null
            }
        }
        return paginazione
    }

    String getCodiceErrore(){
        String codice = null
        if (stringResponse) {
            try {
                def jsonResponse = new JsonSlurper().parseText(stringResponse)
                if (jsonResponse?.errors instanceof ArrayList) {
                    codice = jsonResponse.errors.code.get(0)
                }
            } catch (JsonException jex){
                // FIXME: gestire codice errore specifico?
                codice = null
            }
        }
        return codice
    }

    /*
    List<AnscInfoSoggetto> getInfoSoggetti(){
        List<AnscInfoSoggetto> infoSoggetti = []
        if (stringResponse) {
            def jsonResponse = new JsonSlurper().parseText(stringResponse)
            if (jsonResponse?.modelEventoDTO instanceof ArrayList){
                List<Map> intestatari = jsonResponse.modelEventoDTO.intestatari.get(0)
                for (Map mi : intestatari){
                    infoSoggetti.add(new AnscInfoSoggetto((String)mi.id, (String)mi.nome, (String)mi.cognome))
                }
            }
        }
        return infoSoggetti
    }
    */

}
