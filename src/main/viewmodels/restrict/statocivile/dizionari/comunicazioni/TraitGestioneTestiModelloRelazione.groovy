package restrict.statocivile.dizionari.comunicazioni

import it.finmatica.de4gsdzk.GestioneTestiGsdModello
import it.finmatica.de4gsdzk.GestioneTestiModelloRelazioneService
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaModello
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import it.finmatica.de4gsdzk.statocivile.CivComunicazione
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneAtto
import it.finmatica.de4gsdzk.statocivile.GestioneTestiModelloRelazione
import it.finmatica.de4gsdzk.utils.EAmbito
import it.finmatica.de4gsdzk.utils.EGruppo
import it.finmatica.de4gsdzk.utils.ETipoModello
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.event.UploadEvent
import restrict.TraitGestioneTestiModello

trait TraitGestioneTestiModelloRelazione extends TraitGestioneTestiModello{

    GestioneTestiModelloRelazione modelloRelazione

    GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService

    void doInitModelloRelazione( GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService) {
        this.gestioneTestiModelloRelazioneService = gestioneTestiModelloRelazioneService
    }

    /**
     * Crea un modello in relazione con una comunicazioneAtto
     * @param comunicazioneAtto
     */
    void creaModelloRelazione(CivComunicazioneAtto comunicazioneAtto) {
        modelloRelazione = gestioneTestiModelloRelazioneService.getByIdComunicazioneAtto(comunicazioneAtto.id)
        if (!modelloRelazione) {
            GestioneTestiGsdModello modello = new GestioneTestiGsdModello(ambito: EAmbito.CO, gruppo: EGruppo.CIV)
            creaModelloRelazione(comunicazioneAtto: comunicazioneAtto, modello: modello)
        }
    }

    /**
     * Crea un modello in relazione con una comunicazione
     * @param comunicazione
     */
    void creaModelloRelazione(CivComunicazione comunicazione) {
        modelloRelazione = gestioneTestiModelloRelazioneService.getByIdComunicazione(comunicazione.id)
        if (!modelloRelazione) {
            GestioneTestiGsdModello modello = new GestioneTestiGsdModello(ambito: EAmbito.CO, gruppo: EGruppo.CIV)
            creaModelloRelazione(comunicazione: comunicazione, modello: modello)
        }
    }

    /**
     * Carica o crea un modello in relazione con un tipo certificato
     * @param tipoCertificato
     */
    void creaModelloRelazione(CerTipoCertificato tipoCertificato) {
        if (tipoCertificato.id != null) {
            modelloRelazione = gestioneTestiModelloRelazioneService.getByIdTipoCertificato(tipoCertificato.id)
        }
        if (!modelloRelazione) {
            GestioneTestiGsdModello modello = new GestioneTestiGsdModello(ambito: EAmbito.TC, gruppo: EGruppo.CER)
            creaModelloRelazione(tipoCertificato: tipoCertificato, modello: modello)
        }
    }

    /**
     * Carica o crea un modello in relazione con un modello anagrafe
     * @param modello
     */
    void creaModelloRelazione(AnaModello modelloAnagrafe) {
        if (modelloAnagrafe.id != null) {
            modelloRelazione = gestioneTestiModelloRelazioneService.getByIdModelloAnagrafe(modelloAnagrafe.id)
        }
        if (!modelloRelazione) {
            EAmbito ambito
            if (modelloAnagrafe.tipoModello == ETipoModello.P || modelloAnagrafe.tipoModello == ETipoModello.C) {
                ambito = EAmbito.CO
            } else if (modelloAnagrafe.tipoModello == ETipoModello.F) {
                ambito = EAmbito.CF
            } else if (modelloAnagrafe.tipoModello == ETipoModello.E) {
                ambito = EAmbito.ET
            }
            GestioneTestiGsdModello modello = new GestioneTestiGsdModello(ambito: ambito, gruppo: EGruppo.ANA)
            creaModelloRelazione(modelloAnagrafe: modelloAnagrafe, modello: modello)
        }
    }


    /**
     * Crea un nuovo modello relazione (da zero, per inserimento)
     * @param params
     */
    void creaModelloRelazione(Map params) {
        modelloRelazione = new GestioneTestiModelloRelazione(params)
    }

    @Command void onUploadAllegato(@ContextParam(ContextType.TRIGGER_EVENT) UploadEvent event) {
        uploadModello(event, modelloRelazione.modello)
    }

    @Command void onDownloadAllegato() {
        downloadModello(modelloRelazione.modello)
    }

}