package restrict

import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.errors.FileNonValidoRuntimeException
import it.finmatica.de4gsdzk.integrazioni.documentale.IDocumentoEsterno
import it.finmatica.de4gsdzk.integrazioni.documentale.IFileDocumentoEsterno
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.BindUtils
import org.zkoss.zk.ui.Executions
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

trait TraitComunicazioni {

    abstract IArchivioComunicazione get_dettaglio()

    abstract IArchivioComunicazioneService getArchivioComunicazioneService()

    abstract IComunicazioneProtocolloService getComunicazioneProtocolloService()

    abstract IComunicazioneDestinatarioService getComunicazioneDestinatarioService()

    abstract IComunicazioneAllegatoService getComunicazioneAllegatoService()

    abstract void setArchivio(IArchivioComunicazione arcCom)

    abstract void showCustomMessagebox(IArchivioComunicazione c)

    abstract void generaTestoComunicazione(IArchivioComunicazione c, Boolean scaricaDopoGenerazione)
    
    abstract Boolean getFirmaRemotaAutomatica()

    abstract void setComunicazioneProtocollo(IComunicazioneProtocollo protocollo)

    abstract IComunicazioneProtocollo getComunicazioneProtocollo()

    abstract List<IArchivioComunicazione> getLista()

    abstract List<IArchivioComunicazione> getListaComunicazioniSelezionate()

    abstract List<IComunicazioneDestinatario> getListaDestinatari()

    abstract void setListaDestinatari(List<IComunicazioneDestinatario> destinatari)

    abstract void setListaAllegati(List<IComunicazioneAllegato> allegati)

    abstract void fileNonValido(IComunicazioneAllegato alleCom, Long id)

    abstract Boolean getMassiveCheck()

    abstract String getEtichetta(Map<String, String> etichetta)

    abstract String getMsgTitle()

    abstract void scaricaAllegatiComeZip(List<IArchivioComunicazione> comunicazioniGenerate)

    abstract GsdService getGsdService()

    abstract GsdFirmaService getGsdFirmaService()

    abstract Boolean getShowRecapMessage()

    abstract String addToRecapMsg(String initStr, ETipoElaborazioneComunicazione tipoElaborazione, IArchivioComunicazione _arcCom)

    abstract void fascicolaComunicazioneEAllegati(IArchivioComunicazione arcCom, Boolean refreshComunicazione)

    abstract String getDettaglioComunicazioneRecapMsg(IArchivioComunicazione _arcCom)


    abstract void refreshUi()
    
    abstract void caricaLista()

    ////////////////////////////////////////////////////////////////////////
    //////////////////////////////// ARCHIVIO ////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    void setDettaglio(IArchivioComunicazione arcCom) {
        archivio = arcCom

        caricaComunicazioneProtocollo(arcCom?.id)
        caricaDestinatari(arcCom)
        caricaAllegati(arcCom)

        BindUtils.postNotifyChange(null, null, this, "dettaglio")
    }

    void selezionaTutte() {
        for (IArchivioComunicazione c : lista) {
            if (massiveCheck && c.protocollato) {
                continue
            }
            seleziona(massiveCheck, c)
        }
        refreshUi()
    }

    void seleziona(Boolean selected, IArchivioComunicazione arcCom, Boolean updateDettaglio = false) {
        if (selected) {
            if (!(isSelezionata(arcCom))) {
                listaComunicazioniSelezionate.add(arcCom)
                if (updateDettaglio) {
                    setDettaglio(arcCom)
                }
            }
        } else {
            if (isSelezionata(arcCom)) {
                listaComunicazioniSelezionate.remove(arcCom)
            }
        }
        BindUtils.postNotifyChange(null, null, this, "listaComunicazioniSelezionate")
    }

    Boolean isSelezionata(IArchivioComunicazione arcCom) {
        for (IArchivioComunicazione c : listaComunicazioniSelezionate) {
            if (c.id.compareTo(arcCom.id) == 0) {
                return Boolean.TRUE
            }
        }
        return Boolean.FALSE
    }

    void eliminaERicaricaComunicazione(IArchivioComunicazione arcCom){
        comunicazioneAllegatoService.deleteComunicazioneEAllegati(arcCom)
    }

    boolean isListaComunicazioniSelezionateEmpty(){
        if (listaComunicazioniSelezionate.size() == 0){
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Warn_Nessuna_comunicazione_selezionata")), msgTitle, Messagebox.OK, Messagebox.ERROR)
            return true
        }
        return false
    }

    boolean isListaComunicazioniDaElaborareEmpty(List<IArchivioComunicazione> listaComunicazioniDaElaborare, ETipoElaborazioneComunicazione tipoElaborazione){
        if (listaComunicazioniDaElaborare.size() == 0){
            String errorMsg
            if (tipoElaborazione == ETipoElaborazioneComunicazione.PROTOCOLLAZIONE){
                errorMsg = getEtichetta(Etichette.getEtichetta("Warn_Nessuna_comunicazione_da_protocollare"))
            } else {
                errorMsg = getEtichetta(Etichette.getEtichetta("Warn_Nessuna_comunicazione_da_inviare_albo"))
            }
            Messagebox.show(errorMsg, msgTitle, Messagebox.OK, Messagebox.ERROR)
            return true
        }
        return false
    }

    void generaTesti() {
        if (isListaComunicazioniSelezionateEmpty()) {
            return
        }
        boolean multiSelect = listaComunicazioniSelezionate.size() > 1
        List<IArchivioComunicazione> comunicazioniGenerate = []
        for (IArchivioComunicazione c : listaComunicazioniSelezionate) {
            if (c.isProtocollato() || c.isInviatoAlbo()){
                String msg = (c.protocollato?getEtichetta(Etichette.getEtichetta("Errore_esecuzione_comunicazioni_protocollate")):getEtichetta(Etichette.getEtichetta("Errore_esecuzione_comunicazioni_inviate_albo")))
                Messagebox.show(c.comunicazione.descrizione + ":\n" + msg, msgTitle, Messagebox.OK, Messagebox.ERROR)
            } else if (multiSelect) {
                // In multi-select si rigenera senza conferma per evitare conflitti
                generaTestoComunicazione(c, Boolean.FALSE)
                comunicazioniGenerate.add(c)
            } else {
                Boolean hasPrincipale = archivioComunicazioneService.checkAllegatoPrincipale(c.id)
                if (hasPrincipale){
                    showCustomMessagebox(c)
                } else {
                    generaTestoComunicazione(c, Boolean.TRUE)
                }
            }
        }
        if (!comunicazioniGenerate.isEmpty()) {
            scaricaAllegatiComeZip(comunicazioniGenerate)
        }
    }

    void protocolla() {
        if (isListaComunicazioniSelezionateEmpty()) {
            return
        }

        List<IArchivioComunicazione> comunicazioniDaElaborare = []
        for (IArchivioComunicazione c: listaComunicazioniSelezionate){
            if (c.numero.compareTo(new Integer(0)) < 0){
                Messagebox.show(c.comunicazione.descrizione + ":\n" + getEtichetta(Etichette.getEtichetta("Errore_protocollazione_comunicazioni_provvisorie")), msgTitle, Messagebox.OK, Messagebox.ERROR)
                continue
            }
            if (c.protocollato){
                Messagebox.show(c.comunicazione.descrizione + ":\n" + getEtichetta(Etichette.getEtichetta("Errore_esecuzione_comunicazioni_protocollate")), msgTitle, Messagebox.OK, Messagebox.ERROR)
            } else {
                if (c.isDaProtocollare()){
                    comunicazioniDaElaborare.add(c)
                }
            }
            // Se non è protocollata o da protocollare salto anche se selezionata
        }
        checkFirmaComunicazioni(comunicazioniDaElaborare, ETipoElaborazioneComunicazione.PROTOCOLLAZIONE)
        setDettaglio(_dettaglio)
        refreshUi()
    }
    
    void inviaAlbo() {
        if (isListaComunicazioniSelezionateEmpty()) {
            return
        }

        List<IArchivioComunicazione> comunicazioniDaElaborare = []
        for (IArchivioComunicazione c: listaComunicazioniSelezionate){
            if (c.numero.compareTo(new Integer(0)) < 0){
                Messagebox.show(c.comunicazione.descrizione + ":\n" + getEtichetta(Etichette.getEtichetta("Errore_protocollazione_comunicazioni_provvisorie")), msgTitle, Messagebox.OK, Messagebox.ERROR)
                continue
            }
            if (c.inviatoAlbo){
                Messagebox.show(c.comunicazione.descrizione + ":\n" + getEtichetta(Etichette.getEtichetta("Errore_esecuzione_comunicazioni_inviate_albo")), msgTitle, Messagebox.OK, Messagebox.ERROR)
            } else {
                if (c.isDaInviareAlbo()){
                    comunicazioniDaElaborare.add(c)
                }
            }
            // Se non è da inviare all'albo o già inviata salto anche se selezionata
        }
        checkFirmaComunicazioni(comunicazioniDaElaborare, ETipoElaborazioneComunicazione.INVIO_ALBO)
        setDettaglio(_dettaglio)
        refreshUi()
    }

    void checkFirmaComunicazioni(List<IArchivioComunicazione> listaComunicazioniDaElaborare, ETipoElaborazioneComunicazione tipoElaborazione){
        if (isListaComunicazioniDaElaborareEmpty(listaComunicazioniDaElaborare, tipoElaborazione)) {
            return
        }
        //Verifico se devo firmare
        Boolean daFirmare = comunicazioneAllegatoService.checkAllegatiDaFirmare(listaComunicazioniDaElaborare*.id)
        if (daFirmare){
            if (firmaRemotaAutomatica){
                firma(listaComunicazioniDaElaborare, null, null, tipoElaborazione)
            } else {
                Window w = (Window) Executions.createComponents("/restrict/statocivile/otp.zul", self, [:])
                w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                    if (event.data.codUtentefirmatario && event.data.otp){
                        firma(listaComunicazioniDaElaborare, event.data.codUtentefirmatario, event.data.otp, tipoElaborazione)
                    }
                })
                w.doModal()
            }
        } else {
            protocollaOInvia(listaComunicazioniDaElaborare, tipoElaborazione)
        }
    }

    void firma(List<IArchivioComunicazione> listaComunicazioniDaFirmare, String utente, String otp, ETipoElaborazioneComunicazione tipoElaborazione){
        StringBuilder ids = new StringBuilder("")
        List<IArchivioComunicazione> listaComunicazioniDaElaborare = []

        for (IArchivioComunicazione c: listaComunicazioniDaFirmare){
            if (c.isDaProtocollare() || c.isDaInviareAlbo()){
                Boolean hasPrincipale = archivioComunicazioneService.checkAllegatoPrincipale(c.id)
                if (hasPrincipale){
                    ids.append(c.id.toString())
                    ids.append(TestoUtils.cancelletto)
                    listaComunicazioniDaElaborare.add(c)
                } else {
                    Messagebox.show(c.comunicazione.descrizione + ":\n" +  getEtichetta(Etichette.getEtichetta("Errore_testo_principale_comunicazione")), msgTitle, Messagebox.OK, Messagebox.ERROR)
                }
            }
        }

        if (ids.toString() != ""){
            String retVal = archivioComunicazioneService.firmaComunicazione(listaComunicazioniDaElaborare, ids.toString(), null, utente, otp)
            if ( (retVal?:"") == ""){
                protocollaOInvia(listaComunicazioniDaElaborare, tipoElaborazione)
            } else {
                Messagebox.show(retVal, getEtichetta(Etichette.getEtichetta("Comunicazioni")), Messagebox.OK, Messagebox.ERROR)
                for (IArchivioComunicazione c: listaComunicazioniDaFirmare){
                    if (c.isDaProtocollare() || c.isDaInviareAlbo()){
                        caricaAllegati(c)
                    }
                }
            }
        }
    }

    void protocollaOInvia(List<IArchivioComunicazione> listaComunicazioniDaElaborare, ETipoElaborazioneComunicazione tipoElaborazione){
        if (isListaComunicazioniDaElaborareEmpty(listaComunicazioniDaElaborare, tipoElaborazione)) {
            return
        }
        Boolean almenoUnaElaborata = Boolean.FALSE
        String recapMsg = ""
        for (IArchivioComunicazione c: listaComunicazioniDaElaborare){
            if (c.isDaProtocollare() || c.isDaInviareAlbo()){
                try {
                    String retVal
                    if ((tipoElaborazione == ETipoElaborazioneComunicazione.PROTOCOLLAZIONE) && c.isDaProtocollare()){
                        retVal = archivioComunicazioneService.protocolla(c)
                    } else
                    if ((tipoElaborazione == ETipoElaborazioneComunicazione.INVIO_ALBO) && c.isDaInviareAlbo()){
                        retVal = archivioComunicazioneService.inviaAlbo(c)
                    } else {
                        continue
                    }
                    if ((retVal ?: "") == "") {
                        almenoUnaElaborata = Boolean.TRUE
                        recapMsg = addToRecapMsg(recapMsg, tipoElaborazione, c)
                        // Per quanto riguarda le comunicazioni da inviare all'albo, adottiamo lo stesso comportamento e quindi fascicoliamo dopo l'invio
                        // o mediante click su apposito pulsante, anche se in teoria nel fascicolo andrebbero dopo la pubblicazione
                        fascicolaComunicazioneEAllegati(c, Boolean.FALSE)
                    } else {
                        String preErrMsg = getDettaglioComunicazioneRecapMsg(c)
                        Messagebox.show(preErrMsg + retVal, msgTitle, Messagebox.OK, Messagebox.ERROR)
                    }
                } catch (FileNonValidoRuntimeException fnv){
                    String preErrMsg = getDettaglioComunicazioneRecapMsg(c)
                    Messagebox.show(preErrMsg + (getEtichetta(fnv.getEtichetta())?:fnv.getMessage()), msgTitle, Messagebox.OK, Messagebox.ERROR)
                }
            }
        }
        if (almenoUnaElaborata){
            caricaLista()
            if (showRecapMessage){
                Messagebox.show(getEtichetta(Etichette.getEtichetta("RIEPILOGO_ELABORAZIONE")) + "\n\n" + recapMsg, msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            }
        }
    }



    ////////////////////////////////////////////////////////////////////////
    //////////////////////////////// PROTOCOLLO ////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    void caricaComunicazioneProtocollo(Long id) {
        IComunicazioneProtocollo protocollo = (id ? comunicazioneProtocolloService.get(id) : null)
        setComunicazioneProtocollo(protocollo)
        BindUtils.postNotifyChange(null, null, this, "comunicazioneProtocollo")
    }

    void salvaComunicazioneProtocollo(IArchivioComunicazione arcCom) {
        if (comunicazioneProtocollo) {
            IComunicazioneProtocollo cp = comunicazioneProtocolloService.save(comunicazioneProtocollo, arcCom)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaComunicazioneProtocollo(cp.id)
        }
    }


    ////////////////////////////////////////////////////////////////////////
    //////////////////////////////// DESTINATARI ////////////////////////////
    ////////////////////////////////////////////////////////////////////////


    void caricaDestinatari(IArchivioComunicazione arcCom) {
        listaDestinatari = []
        if (arcCom?.id) {
            listaDestinatari = comunicazioneDestinatarioService.listAllByArchivioComunicazione(arcCom.id)
            for (IComunicazioneDestinatario d : listaDestinatari) {
                d.pec = gsdService.get_prot_indirizzo_pec(ConfigurazioneUtils.ARCHIVIO_RIFERIMENTO_ANAGRAFE, d.ente?.id, d.codiceProvinciaDestinatario, d.codiceComuneDestinatario)
            }
        }
        BindUtils.postNotifyChange(null, null, this, "listaDestinatari")
    }

    void salvaERicaricaDestinatari(IComunicazioneDestinatario destinatario, IArchivioComunicazione arcCom) {
        comunicazioneDestinatarioService.save(destinatario)
        caricaDestinatari(arcCom)
    }

    void eliminaERicaricaDestinatari(Long idDestinatario, IArchivioComunicazione arcCom) {
        IComunicazioneDestinatario dest = comunicazioneDestinatarioService.get(idDestinatario)
        comunicazioneDestinatarioService.delete(dest)
        caricaDestinatari(arcCom)
    }

    void inviaPec(IComunicazioneDestinatario destinatario) {
        String msg = comunicazioneDestinatarioService.inviaPec(destinatario)
        if ((msg ?: "") != "") {
            Messagebox.show(msg, getEtichetta(Etichette.getEtichetta("Comunicazioni")), Messagebox.OK, Messagebox.ERROR)
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Mail_Inviata")), getEtichetta(Etichette.getEtichetta("Comunicazioni")), Messagebox.OK, Messagebox.INFORMATION)
        }
        caricaDestinatari(destinatario.archivioComunicazione)
    }

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////////// ALLEGATI /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    void caricaAllegati(IArchivioComunicazione arcCom) {
        listaAllegati = []
        if (arcCom?.id) {
            listaAllegati = comunicazioneAllegatoService.listAllMetadatiByArchivioComunicazione(arcCom.id)
        }
        BindUtils.postNotifyChange(null, null, this, "listaAllegati")
    }

    void eliminaERicaricaAllegati(Long idAllegato, IArchivioComunicazione arcCom){
        IComunicazioneAllegato alle = comunicazioneAllegatoService.get(idAllegato)
        comunicazioneAllegatoService.deleteAllegato(alle)
        caricaAllegati(arcCom)
    }

    void scaricaAllegato(Long id, boolean sbusta = false, boolean segnalaSbustamento = true){
        IComunicazioneAllegato alleCom = comunicazioneAllegatoService.get(id)
        try{
            gsdFirmaService.scaricaAllegato(alleCom.archivioComunicazione as IDocumentoEsterno, alleCom as IFileDocumentoEsterno, sbusta, segnalaSbustamento)
        } catch (FileNonValidoRuntimeException fre){
            fileNonValido(alleCom, id)
        }
    }


}