package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.IAttoMatUci
import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoAtto
import it.finmatica.de4gsdzk.statocivile.CivMatrimonio
import it.finmatica.de4gsdzk.statocivile.CivMorte
import it.finmatica.de4gsdzk.statocivile.CivUnioneCivile

class FormUtils {

    static String getAttoFormLabel(ETipoOperazione tipoOperazione, CivAttoBaseDomain atto, Map e) {
        if (atto.natura == ENaturaAtto.N) {
            return txt(e, Etichette.getEtichetta("ATTO_ANNULLATO"))
        }

        if (atto.getBloccato()) {
            return txt(e, Etichette.getEtichetta("ATTO_BLOCCATO"))
        }

        if (atto.isCodRec3()){
            return txt(e, Etichette.getEtichetta("ATTO_IN_INSERIMENTO")) + (atto.isProvvisorio()? " (${txt(e, Etichette.getEtichetta("Provvisorio"))})":"")
        }

        if (tipoOperazione.isInsert()) {
            return txt(e, Etichette.getEtichetta("ATTO_PREGRESSO_IN_INSERIMENTO"))
        } else {
            return txt(e, Etichette.getEtichetta("ATTO_CONSOLIDATO"))
        }
    }

    static String getAttoButtonConsolidamentoLabel(CivAttoBaseDomain atto, Map e){
        if (atto.getBloccato()) {
            return ""
        }

        if (atto.isCodRec3()) {
            return txt(e, Etichette.getEtichetta("Chiudi_atto"))
        } else {
            return txt(e, Etichette.getEtichetta("Blocca_atto"))
        }
    }

    static Map<String, String> getAttoCustomLabels(ETipoAtto tipoAttoEnum, Map e) {
        // Per mat/Uci la data evento può essere la data del matrimonio o del divorzio
        Map<String, String> exportLabels = [:]
        exportLabels.put("Cognome1",    txt(e, Etichette.getEtichetta("Cognome")))
        exportLabels.put("Nome1",       txt(e, Etichette.getEtichetta("Nome")))
        exportLabels.put("Residenza1",  txt(e, Etichette.getEtichetta("Residenza")))
        switch (tipoAttoEnum) {
            case ETipoAtto.NAS:
                exportLabels.put("Elenco",      txt(e, Etichette.getEtichetta("Elenco_Nascite")))
                exportLabels.put("DataEvento",  txt(e, Etichette.getEtichetta("Data_Nascita")))
                exportLabels.put("Atto",        txt(e, Etichette.getEtichetta("Atto_Nascita")))
                exportLabels.put("Extra1",      txt(e, Etichette.getEtichetta("Paternita")))
                exportLabels.put("Extra2",      txt(e, Etichette.getEtichetta("Maternita")))

                exportLabels.put("campi_obbligatori_soggetto_1", txt(e, Etichette.getEtichetta("Compilare_campi_obbligatori_nato")))
                break
            case ETipoAtto.MOR:
                exportLabels.put("Elenco",      txt(e, Etichette.getEtichetta("Elenco_Morti")))
                exportLabels.put("DataEvento",  txt(e, Etichette.getEtichetta("Data_Decesso")))
                exportLabels.put("Atto",        txt(e, Etichette.getEtichetta("Atto_Morte")))
                exportLabels.put("Extra1",      txt(e, Etichette.getEtichetta("Stato_Civile")))
                exportLabels.put("Extra2",      txt(e, Etichette.getEtichetta("Data_Decesso")))
                exportLabels.put("Extra3",      txt(e, Etichette.getEtichetta("Comune_Decesso")))

                exportLabels.put(ETipoFormulaAnnotazioneDaAtto.NAS_1.name(), txt(e, Etichette.getEtichetta("Annotazione_su_atto_nascita_deceduto")))

                exportLabels.put("campi_obbligatori_soggetto_1", txt(e, Etichette.getEtichetta("Compilare_campi_obbligatori_deceduto_a")))
                break
            case ETipoAtto.PUB:
                exportLabels.put("DataEvento",  txt(e, Etichette.getEtichetta("Data_Pubblicazione")))
                exportLabels.put("Cognome1",    txt(e, Etichette.getEtichetta("Cognome_Sposo")))
                exportLabels.put("Nome1",       txt(e, Etichette.getEtichetta("Nome_Sposo")))
                exportLabels.put("Cognome2",    txt(e, Etichette.getEtichetta("Cognome_Sposa")))
                exportLabels.put("Nome2",       txt(e, Etichette.getEtichetta("Nome_Sposa")))

                exportLabels.put("campi_obbligatori_soggetto_1", txt(e, Etichette.getEtichetta("Compilare_campi_obbligatori_sposo")))
                exportLabels.put("campi_obbligatori_soggetto_2", txt(e, Etichette.getEtichetta("Compilare_campi_obbligatori_sposa")))
                break
            case ETipoAtto.PVU:
                exportLabels.put("DataEvento",  txt(e, Etichette.getEtichetta("Data_Pubblicazione")))
                exportLabels.put("Cognome1",    txt(e, Etichette.getEtichetta("Cognome_Contraente_1")))
                exportLabels.put("Nome1",       txt(e, Etichette.getEtichetta("Nome_Contraente_1")))
                exportLabels.put("Cognome2",    txt(e, Etichette.getEtichetta("Cognome_Contraente_2")))
                exportLabels.put("Nome2",       txt(e, Etichette.getEtichetta("Nome_Contraente_2")))

                exportLabels.put("campi_obbligatori_soggetto_1", txt(e, Etichette.getEtichetta("Compilare_campi_obbligatori_contraente_1")))
                exportLabels.put("campi_obbligatori_soggetto_2", txt(e, Etichette.getEtichetta("Compilare_campi_obbligatori_contraente_2")))
                break
            case ETipoAtto.MAT:
                exportLabels.put("Elenco",      txt(e, Etichette.getEtichetta("Elenco_Matrimoni")))
                exportLabels.put("DataEvento",  txt(e, Etichette.getEtichetta("Data_Evento")))
                exportLabels.put("LuogoEvento", txt(e, Etichette.getEtichetta("Luogo_Matrimonio")))
                exportLabels.put("Cognome1",    txt(e, Etichette.getEtichetta("Cognome_Sposo")))
                exportLabels.put("Nome1",       txt(e, Etichette.getEtichetta("Nome_Sposo")))
                exportLabels.put("Cognome2",    txt(e, Etichette.getEtichetta("Cognome_Sposa")))
                exportLabels.put("Nome2",       txt(e, Etichette.getEtichetta("Nome_Sposa")))
                exportLabels.put("AttoDivorzio",txt(e, Etichette.getEtichetta("Atto_Divorzio")))
                exportLabels.put("Residenza1",  txt(e, Etichette.getEtichetta("Residenza_Sposo")))
                exportLabels.put("Residenza2",  txt(e, Etichette.getEtichetta("Residenza_Sposa")))
                exportLabels.put("Atto",        txt(e, Etichette.getEtichetta("Atto_Matrimonio")))
                exportLabels.put("Avvocato1",   txt(e, Etichette.getEtichetta("Avvocato_Marito")))
                exportLabels.put("Avvocato2",   txt(e, Etichette.getEtichetta("Avvocato_Moglie")))
                exportLabels.put("SEZIONE_SOGGETTO1",   txt(e, Etichette.getEtichetta("SEZIONE_MARITO")))
                exportLabels.put("SEZIONE_SOGGETTO2",   txt(e, Etichette.getEtichetta("SEZIONE_MOGLIE")))

                exportLabels.put("inserisci_plus",  txt(e, Etichette.getEtichetta("Atto_Matrimonio")))
                exportLabels.put("inserisci_custom",txt(e, Etichette.getEtichetta("Atto_Divorzio")))

                exportLabels.put("SEZIONE_MATUCI",  txt(e, Etichette.getEtichetta("SEZIONE_DATI_MATRIMONIO")))
                exportLabels.put("DataMatUci",      txt(e, Etichette.getEtichetta("Data_Matrimonio")))
                exportLabels.put("ComuneMatUci",    txt(e, Etichette.getEtichetta("Comune_Matrimonio")))
                exportLabels.put("statoCivilePre",  txt(e, Etichette.getEtichetta("Stato_Civile_Pre_Matrimonio")))

                exportLabels.put(ETipoFormulaAnnotazioneDaAtto.NAS_1.name(), txt(e, Etichette.getEtichetta("Annotazione_su_atto_nascita_sposo")))
                exportLabels.put(ETipoFormulaAnnotazioneDaAtto.NAS_2.name(), txt(e, Etichette.getEtichetta("Annotazione_su_atto_nascita_sposa")))
                exportLabels.put(ETipoFormulaAnnotazioneDaAtto.MAT.name(),   txt(e, Etichette.getEtichetta("Annotazione_su_atto_matrimonio")))

                exportLabels.put("campi_obbligatori_soggetto_1", txt(e, Etichette.getEtichetta("Compilare_campi_obbligatori_sposo")))
                exportLabels.put("campi_obbligatori_soggetto_2", txt(e, Etichette.getEtichetta("Compilare_campi_obbligatori_sposa")))
                break
            case ETipoAtto.UCI:
                exportLabels.put("Elenco",      txt(e, Etichette.getEtichetta("Elenco_Unioni_Civili")))
                exportLabels.put("DataEvento",  txt(e, Etichette.getEtichetta("Data_Evento")))
                exportLabels.put("LuogoEvento", txt(e, Etichette.getEtichetta("Comune_Unione_Civile")))
                exportLabels.put("Cognome1",    txt(e, Etichette.getEtichetta("Cognome_Contraente_1")))
                exportLabels.put("Nome1",       txt(e, Etichette.getEtichetta("Nome_Contraente_1")))
                exportLabels.put("Cognome2",    txt(e, Etichette.getEtichetta("Cognome_Contraente_2")))
                exportLabels.put("Nome2",       txt(e, Etichette.getEtichetta("Nome_Contraente_2")))
                exportLabels.put("AttoDivorzio",txt(e, Etichette.getEtichetta("Atto_Scioglimento")))
                exportLabels.put("Residenza1",  txt(e, Etichette.getEtichetta("Residenza_Contraente"))+" 1")
                exportLabels.put("Residenza2",  txt(e, Etichette.getEtichetta("Residenza_Contraente"))+" 2")
                exportLabels.put("Atto",        txt(e, Etichette.getEtichetta("Atto_Unione_Civile")))
                exportLabels.put("Avvocato1",   txt(e, Etichette.getEtichetta("Avvocato_Contraente_1")))
                exportLabels.put("Avvocato2",   txt(e, Etichette.getEtichetta("Avvocato_Contraente_2")))
                exportLabels.put("SEZIONE_SOGGETTO1",   txt(e, Etichette.getEtichetta("SEZIONE_CONTRAENTE_1")))
                exportLabels.put("SEZIONE_SOGGETTO2",   txt(e, Etichette.getEtichetta("SEZIONE_CONTRAENTE_2")))

                exportLabels.put("inserisci_plus",  txt(e, Etichette.getEtichetta("Atto_Unione_Civile")))
                exportLabels.put("inserisci_custom",txt(e, Etichette.getEtichetta("Atto_Scioglimento")))

                exportLabels.put("SEZIONE_MATUCI",  txt(e, Etichette.getEtichetta("SEZIONE_DATI_UNIONE_CIVILE")))
                exportLabels.put("DataMatUci",      txt(e, Etichette.getEtichetta("Data_Unione_Civile")))
                exportLabels.put("ComuneMatUci",    txt(e, Etichette.getEtichetta("Comune_Unione_Civile")))
                exportLabels.put("statoCivilePre",  txt(e, Etichette.getEtichetta("Stato_Civile_Pre_Unione")))

                exportLabels.put(ETipoFormulaAnnotazioneDaAtto.NAS_1.name(), txt(e, Etichette.getEtichetta("Annotazione_su_atto_nascita_contraente_1")))
                exportLabels.put(ETipoFormulaAnnotazioneDaAtto.NAS_2.name(), txt(e, Etichette.getEtichetta("Annotazione_su_atto_nascita_contraente_2")))
                exportLabels.put(ETipoFormulaAnnotazioneDaAtto.MAT.name(),   txt(e, Etichette.getEtichetta("Annotazione_su_atto_unione_civile")))

                exportLabels.put("campi_obbligatori_soggetto_1", txt(e, Etichette.getEtichetta("Compilare_campi_obbligatori_contraente_1")))
                exportLabels.put("campi_obbligatori_soggetto_2", txt(e, Etichette.getEtichetta("Compilare_campi_obbligatori_contraente_2")))
                break
            case ETipoAtto.CIT:
                exportLabels.put("Elenco",      txt(e, Etichette.getEtichetta("Elenco_Cittadinanze")))
                exportLabels.put("DataEvento",  txt(e, Etichette.getEtichetta("Data_Cittadinanza")))
                exportLabels.put("Atto",        txt(e, Etichette.getEtichetta("Atto_Cittadinanza")))
                exportLabels.put("Extra2",      txt(e, Etichette.getEtichetta("Data_Cittadinanza")))
                exportLabels.put("Extra3",      txt(e, Etichette.getEtichetta("Tipo_Atto")))

                exportLabels.put(ETipoFormulaAnnotazioneDaAtto.NAS_1.name(), txt(e, Etichette.getEtichetta("Annotazione_su_atto_nascita_intestatario")))

                exportLabels.put("campi_obbligatori_soggetto_1", txt(e, Etichette.getEtichetta("Compilare_campi_obbligatori_intestatario")))
                break
        }
        return exportLabels
    }

    static Map<String, String> getTipoDivorzioCustomLabels(CivCategoriaTipoAtto categoriaTipoAtto, Map e) {
        Map<String, String> exportLabels = [:]
        exportLabels.put("Separazione", txt(e, Etichette.getEtichetta("Separazione")))
        exportLabels.put("Scioglimento", txt(e, Etichette.getEtichetta("Scioglimento")))
        exportLabels.put("Altro", txt(e, Etichette.getEtichetta("Altro")))
        if (categoriaTipoAtto?.codice == CivCategoriaTipoAtto.TRI) {
            exportLabels.put("Cessazione", txt(e, Etichette.getEtichetta("Cessazione_Annullamento")))
        } else if (categoriaTipoAtto?.codice == CivCategoriaTipoAtto.EST) {
            exportLabels.put("Cessazione", txt(e, Etichette.getEtichetta("Annullamento")))
        } else {
            exportLabels.put("Cessazione", txt(e, Etichette.getEtichetta("Cessazione")))
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
