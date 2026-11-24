package restrict

import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.IComunicazioneDestinatario
import it.finmatica.de4gsdzk.IEnte
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.ETipoComuneAtto
import it.finmatica.de4gsdzk.utils.ETipoEnteDestinatario
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.event.Events
import org.zkoss.zul.Messagebox

abstract class AbstractDestinatariSelectViewModel extends AbstractSelectViewModel implements TraitComune {

    List<ETipoEnteDestinatario> listaTipiEnte
    ETipoEnteDestinatario tipoEnteDestinatario

    List<Integer> idEntiDaEscludere
    List<String> idComuniDaEscludere

    List<IEnte> listaEnti
    IEnte ente
    ArcComune comune

    void doInit(Long idArcCom) {
        List<Map<String, String>> eList = [Etichette.getEtichetta("Destinatari"), Etichette.getEtichetta("Comune"), Etichette.getEtichetta("Ente")]

        // Aggiungo etichette tipo ente destinatario
        // per lo stato civile elaboro solo enti e comuni;  rimando la gestione di consolati e individui; l'opzione ENTE deve essere l'ultima
        listaTipiEnte = [ETipoEnteDestinatario.COMUNE, ETipoEnteDestinatario.ENTE]
        eList.addAll(listaTipiEnte*.getEtichettaDesc())

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Destinatari"))

        totalSizeLabel = ""

        List<IComunicazioneDestinatario> listaDestinatariDaEscludere = popolaListaDestinatariDaEscludere(idArcCom)


        idEntiDaEscludere = []
        idComuniDaEscludere = []
        for (IComunicazioneDestinatario d : listaDestinatariDaEscludere) {
            if (d.comuneDomain?.id) {
                idComuniDaEscludere.add(d.comuneDomain.id)
            }
            if (d.ente != null) {
                idEntiDaEscludere.add(d.ente.id)
            }
        }
    }

    void caricaLista() {
        eseguiQuery(Boolean.TRUE)

        refreshUi()
    }


    void resetDettaglio() {
        comune = null
        ente = null
        refreshUi()
    }

    void selezionaComune(ETipoComuneAtto tca, ArcComuneBaseDomain c) {
        if (tca == ETipoComuneAtto.CC_DEST) {
            comune = c as ArcComune
        }
        refreshUi()
    }

    @Command
    void onSeleziona() {
        Map params = [:]
        switch (tipoEnteDestinatario) {
            case ETipoEnteDestinatario.ENTE:
                params = [ente: ente, dettaglio: ente]
                break
            case ETipoEnteDestinatario.COMUNE:
                params = [ente: ente, dettaglio: comune]
                break
        }
        if (params.dettaglio == null) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, params)
            onChiudi()
        }
    }

    abstract List<IComunicazioneDestinatario> popolaListaDestinatariDaEscludere(Long idArcCom)
}
