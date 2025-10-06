package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.IAttoMatUci
import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoAtto
import it.finmatica.de4gsdzk.statocivile.CivMatrimonio
import it.finmatica.de4gsdzk.statocivile.CivMorte
import it.finmatica.de4gsdzk.statocivile.CivUnioneCivile

import static it.finmatica.de4gsdzk.utils.Etichette.*
import static it.finmatica.de4gsdzk.utils.EtichetteMessaggi.*

class FormUtils {

    static String getAttoFormLabel(ETipoOperazione tipoOperazione, CivAttoBaseDomain atto, Map e) {
        if (atto.natura == ENaturaAtto.N) {
            return txt(e, ATTO_ANNULLATO)
        }

        if (atto.getBloccato()) {
            return txt(e, ATTO_BLOCCATO)
        }

        if (atto.isCodRec3()){
            return txt(e, ATTO_IN_INSERIMENTO) + (atto.isProvvisorio()?" (${txt(e, Provvisorio)})":"")
        }

        if (tipoOperazione.isInsert()) {
            return txt(e, ATTO_PREGRESSO_IN_INSERIMENTO)
        } else {
            return txt(e, ATTO_CONSOLIDATO)
        }
    }

    static String getAttoButtonConsolidamentoLabel(CivAttoBaseDomain atto, Map e){
        if (atto.getBloccato()) {
            return ""
        }

        if (atto.isCodRec3()) {
            return txt(e, Chiudi_atto)
        } else {
            return txt(e, Blocca_atto)
        }
    }

    static Map<String, String> getAttoCustomLabels(ETipoAtto tipoAttoEnum, Map e) {
        // Per mat/Uci la data evento può essere la data del matrimonio o del divorzio
        Map<String, String> exportLabels = [:]
        exportLabels.put("Cognome1",    txt(e, Cognome))
        exportLabels.put("Nome1",       txt(e, Nome))
        exportLabels.put("Residenza1",  txt(e, Residenza))
        switch (tipoAttoEnum) {
            case ETipoAtto.NAS:
                exportLabels.put("Elenco",      txt(e, Elenco_Nascite))
                exportLabels.put("DataEvento",  txt(e, Data_Nascita))
                exportLabels.put("Atto",        txt(e, Atto_Nascita))
                exportLabels.put("Extra1",      txt(e, Paternita))
                exportLabels.put("Extra2",      txt(e, Maternita))

                exportLabels.put("campi_obbligatori_soggetto_1", txt(e, Compilare_campi_obbligatori_nato))
                break
            case ETipoAtto.MOR:
                exportLabels.put("Elenco",      txt(e, Elenco_Morti))
                exportLabels.put("DataEvento",  txt(e, Data_Decesso))
                exportLabels.put("Atto",        txt(e, Atto_Morte))
                exportLabels.put("Extra1",      txt(e, Stato_Civile))
                exportLabels.put("Extra2",      txt(e, Data_Decesso))
                exportLabels.put("Extra3",      txt(e, Comune_Decesso))

                exportLabels.put(ETipoFormulaAnnotazioneDaAtto.NAS_1.name(), txt(e, Annotazione_su_atto_nascita_deceduto))

                exportLabels.put("campi_obbligatori_soggetto_1", txt(e, Compilare_campi_obbligatori_deceduto_a))
                break
            case ETipoAtto.PUB:
                exportLabels.put("DataEvento",  txt(e, Data_Pubblicazione))
                exportLabels.put("Cognome1",    txt(e, Cognome_Sposo))
                exportLabels.put("Nome1",       txt(e, Nome_Sposo))
                exportLabels.put("Cognome2",    txt(e, Cognome_Sposa))
                exportLabels.put("Nome2",       txt(e, Nome_Sposa))

                exportLabels.put("campi_obbligatori_soggetto_1", txt(e, Compilare_campi_obbligatori_sposo))
                exportLabels.put("campi_obbligatori_soggetto_2", txt(e, Compilare_campi_obbligatori_sposa))
                break
            case ETipoAtto.PVU:
                exportLabels.put("DataEvento",  txt(e, Data_Pubblicazione))
                exportLabels.put("Cognome1",    txt(e, Cognome_Contraente_1))
                exportLabels.put("Nome1",       txt(e, Nome_Contraente_1))
                exportLabels.put("Cognome2",    txt(e, Cognome_Contraente_2))
                exportLabels.put("Nome2",       txt(e, Nome_Contraente_2))

                exportLabels.put("campi_obbligatori_soggetto_1", txt(e, Compilare_campi_obbligatori_contraente_1))
                exportLabels.put("campi_obbligatori_soggetto_2", txt(e, Compilare_campi_obbligatori_contraente_2))
                break
            case ETipoAtto.MAT:
                exportLabels.put("Elenco",      txt(e, Elenco_Matrimoni))
                exportLabels.put("DataEvento",  txt(e, Data_Evento))
                exportLabels.put("LuogoEvento", txt(e, Luogo_Matrimonio))
                exportLabels.put("Cognome1",    txt(e, Cognome_Sposo))
                exportLabels.put("Nome1",       txt(e, Nome_Sposo))
                exportLabels.put("Cognome2",    txt(e, Cognome_Sposa))
                exportLabels.put("Nome2",       txt(e, Nome_Sposa))
                exportLabels.put("AttoDivorzio",txt(e, Atto_Divorzio))
                exportLabels.put("Residenza1",  txt(e, Residenza_Sposo))
                exportLabels.put("Residenza2",  txt(e, Residenza_Sposa))
                exportLabels.put("Atto",        txt(e, Atto_Matrimonio))
                exportLabels.put("Avvocato1",   txt(e, Avvocato_Marito))
                exportLabels.put("Avvocato2",   txt(e, Avvocato_Moglie))
                exportLabels.put("SEZIONE_SOGGETTO1",   txt(e, SEZIONE_MARITO))
                exportLabels.put("SEZIONE_SOGGETTO2",   txt(e, SEZIONE_MOGLIE))

                exportLabels.put("inserisci_plus",  txt(e, Atto_Matrimonio))
                exportLabels.put("inserisci_custom",txt(e, Atto_Divorzio))

                exportLabels.put("SEZIONE_MATUCI",  txt(e, SEZIONE_DATI_MATRIMONIO))
                exportLabels.put("DataMatUci",      txt(e, Data_Matrimonio))
                exportLabels.put("ComuneMatUci",    txt(e, Comune_Matrimonio))
                exportLabels.put("statoCivilePre",  txt(e, Stato_Civile_Pre_Matrimonio))

                exportLabels.put(ETipoFormulaAnnotazioneDaAtto.NAS_1.name(), txt(e, Annotazione_su_atto_nascita_sposo))
                exportLabels.put(ETipoFormulaAnnotazioneDaAtto.NAS_2.name(), txt(e, Annotazione_su_atto_nascita_sposa))
                exportLabels.put(ETipoFormulaAnnotazioneDaAtto.MAT.name(),   txt(e, Annotazione_su_atto_matrimonio))

                exportLabels.put("campi_obbligatori_soggetto_1", txt(e, Compilare_campi_obbligatori_sposo))
                exportLabels.put("campi_obbligatori_soggetto_2", txt(e, Compilare_campi_obbligatori_sposa))
                break
            case ETipoAtto.UCI:
                exportLabels.put("Elenco",      txt(e, Elenco_Unioni_Civili))
                exportLabels.put("DataEvento",  txt(e, Data_Evento))
                exportLabels.put("LuogoEvento", txt(e, Comune_Unione_Civile))
                exportLabels.put("Cognome1",    txt(e, Cognome_Contraente_1))
                exportLabels.put("Nome1",       txt(e, Nome_Contraente_1))
                exportLabels.put("Cognome2",    txt(e, Cognome_Contraente_2))
                exportLabels.put("Nome2",       txt(e, Nome_Contraente_2))
                exportLabels.put("AttoDivorzio",txt(e, Atto_Scioglimento))
                exportLabels.put("Residenza1",  txt(e, Residenza_Contraente)+" 1")
                exportLabels.put("Residenza2",  txt(e, Residenza_Contraente)+" 2")
                exportLabels.put("Atto",        txt(e, Atto_Unione_Civile))
                exportLabels.put("Avvocato1",   txt(e, Avvocato_Contraente_1))
                exportLabels.put("Avvocato2",   txt(e, Avvocato_Contraente_2))
                exportLabels.put("SEZIONE_SOGGETTO1",   txt(e, SEZIONE_CONTRAENTE_1))
                exportLabels.put("SEZIONE_SOGGETTO2",   txt(e, SEZIONE_CONTRAENTE_2))

                exportLabels.put("inserisci_plus",  txt(e, Atto_Unione_Civile))
                exportLabels.put("inserisci_custom",txt(e, Atto_Scioglimento))

                exportLabels.put("SEZIONE_MATUCI",  txt(e, SEZIONE_DATI_UNIONE_CIVILE))
                exportLabels.put("DataMatUci",      txt(e, Data_Unione_Civile))
                exportLabels.put("ComuneMatUci",    txt(e, Comune_Unione_Civile))
                exportLabels.put("statoCivilePre",  txt(e, Stato_Civile_Pre_Unione))

                exportLabels.put(ETipoFormulaAnnotazioneDaAtto.NAS_1.name(), txt(e, Annotazione_su_atto_nascita_contraente_1))
                exportLabels.put(ETipoFormulaAnnotazioneDaAtto.NAS_2.name(), txt(e, Annotazione_su_atto_nascita_contraente_2))
                exportLabels.put(ETipoFormulaAnnotazioneDaAtto.MAT.name(),   txt(e, Annotazione_su_atto_unione_civile))

                exportLabels.put("campi_obbligatori_soggetto_1", txt(e, Compilare_campi_obbligatori_contraente_1))
                exportLabels.put("campi_obbligatori_soggetto_2", txt(e, Compilare_campi_obbligatori_contraente_2))
                break
            case ETipoAtto.CIT:
                exportLabels.put("Elenco",      txt(e, Elenco_Cittadinanze))
                exportLabels.put("DataEvento",  txt(e, Data_Cittadinanza))
                exportLabels.put("Atto",        txt(e, Atto_Cittadinanza))
                exportLabels.put("Extra2",      txt(e, Data_Cittadinanza))
                exportLabels.put("Extra3",      txt(e, Tipo_Atto))

                exportLabels.put(ETipoFormulaAnnotazioneDaAtto.NAS_1.name(), txt(e, Annotazione_su_atto_nascita_intestatario))

                exportLabels.put("campi_obbligatori_soggetto_1", txt(e, Compilare_campi_obbligatori_intestatario))
                break
        }
        return exportLabels
    }

    static Map<String, String> getTipoDivorzioCustomLabels(CivCategoriaTipoAtto categoriaTipoAtto, Map e) {
        Map<String, String> exportLabels = [:]
        exportLabels.put("Separazione", txt(e, Separazione))
        exportLabels.put("Scioglimento", txt(e, Scioglimento))
        exportLabels.put("Altro", txt(e, Altro))
        if (categoriaTipoAtto?.codice == CivCategoriaTipoAtto.TRI || categoriaTipoAtto?.codice == CivCategoriaTipoAtto.EST) {
            exportLabels.put("Cessazione", txt(e, Cessazione_Annullamento))
        } else {
            exportLabels.put("Cessazione", txt(e, Cessazione))
        }
        return exportLabels
    }

    private static String txt(Map etichette, Map<String, String> etichetta) {
        return etichetta ? (String) etichette.get(etichetta.codice) : ""
    }

    static String getAttoCellSclass(CivAttoBaseDomain a) {
        return ((a?.isCodRec3())?"testoRilevante":"")
    }

    static String getUriPreviewANSC(CivAttoBaseDomain atto) {
        String anscUri = ""
        switch (atto.tipoAttoEnum) {
            case ETipoAtto.NAS:
                anscUri = "/restrict/statocivile/nascita/nascitaANSCLista.zul"
                break
            case ETipoAtto.MOR:
                anscUri = "/restrict/statocivile/morte/morteANSCLista.zul"
                break
            case ETipoAtto.MAT:
                if (atto instanceof IAttoMatUci){
                    if (((IAttoMatUci)atto).divorzio){
                        anscUri = "/restrict/statocivile/matrimonio/matrimonio/divorzioANSCLista.zul"
                    } else {
                        anscUri = "/restrict/statocivile/matrimonio/matrimonio/matrimonioANSCLista.zul"
                    }
                }
                break
            case ETipoAtto.UCI:
                if (atto instanceof IAttoMatUci) {
                    if (((IAttoMatUci) atto).divorzio) {
                        anscUri = "/restrict/statocivile/unione/unione/scioglimentoANSCLista.zul"
                    } else {
                        anscUri = "/restrict/statocivile/unione/unione/unioneCivileANSCLista.zul"
                    }
                }
                break
            case ETipoAtto.CIT:
                anscUri = "/restrict/statocivile/cittadinanza/cittadinanzaANSCLista.zul"
                break
        }
        return anscUri
    }

    static String getUriModelloIstat(CivAttoBaseDomain atto) {
        String istatUri = ""
        switch (atto.getTipoAttoEnum()) {
            case ETipoAtto.NAS:
                istatUri = "/restrict/statocivile/nascita/nascitaP4Dettaglio.zul"
                break
            case ETipoAtto.MOR:
                if (atto instanceof CivMorte) {
                    if (atto.hasModelloD4) {
                        istatUri = "/restrict/statocivile/morte/morteD4Dettaglio.zul"
                    }
                    if (atto.hasModelloD4Bis) {
                        istatUri = "/restrict/statocivile/morte/morteD4BisDettaglio.zul"
                    }
                }
                break
            case ETipoAtto.PUB:
                istatUri = "/restrict/statocivile/matrimonio/pubblicazione/pubblicazioneD3Dettaglio.zul"
                break
            case ETipoAtto.MAT:
                if (atto instanceof CivMatrimonio) {
                    if (((CivMatrimonio) atto).divorzio) {
                        if (atto.hasModelloSC) {
                            istatUri = "/restrict/statocivile/matrimonio/matrimonio/divorzioSCDettaglio.zul"
                        }
                        if (atto.hasModelloSDSU) {
                            istatUri = "/restrict/statocivile/matrimonio/matrimonio/divorzioSDSUDettaglio.zul"
                        }
                    } else {
                        istatUri = "/restrict/statocivile/matrimonio/matrimonio/matrimonioD3Dettaglio.zul"
                    }
                }
                break
            case ETipoAtto.PVU:
                istatUri = "/restrict/statocivile/unione/processoVerbale/processoVerbaleD3UDettaglio.zul"
                break
            case ETipoAtto.UCI:
                if (atto instanceof CivUnioneCivile) {
                    if (((CivUnioneCivile) atto).divorzio) {
                        istatUri = "/restrict/statocivile/unione/unione/scioglimentoSDSUDettaglio.zul"
                    } else {
                        istatUri = "/restrict/statocivile/unione/unione/unioneCivileD3UDettaglio.zul"
                    }
                }
                break
        }
        return istatUri
    }

    static String getUriTestoAtto(CivAttoBaseDomain atto) {
        String uriTesto
        switch (atto.getTipoAttoEnum()) {
            case ETipoAtto.PUB:
            case ETipoAtto.PVU:
                uriTesto = "/restrict/statocivile/previewAttoA4PubPvu.zul"
                break
            default:
                uriTesto = "/restrict/statocivile/previewAttoA4.zul"
        }
        return uriTesto
    }

    static String getUriAnagrafeSelect(Boolean ricercaInANPRAttiva=Boolean.TRUE) {
        if (ricercaInANPRAttiva){
            return "/restrict/anagrafe/anagrafeAllSelect.zul" // default
        } else {
            return "/restrict/anagrafe/anagrafeSelect.zul"  // solo anagrafe locale
        }
    }

}
