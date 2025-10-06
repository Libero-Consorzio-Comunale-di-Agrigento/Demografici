package it.finmatica.de4gsdzk.statocivile

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVCOM_DEST")
class CivComunicazioneDestinatario {

    @Id
    @Column(name = "ID")
    Long id

    // Nel versione fors11 la fk era verso CIVCOM_PROT, ma poiché la PK di CIVCOM e quella di CIVCOM_PROT
    // COINCIDONO (e sono alimentate dalla stessa SEQUENCE), alla luce della nuova modalità di gestione
    // delle comunicazioni introdotta dall'analisi per la versione zk software, abbiamo convenuto di girare la
    // FK verso CIVCOM
    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_COM", nullable = false)
    CivArchivioComunicazione archivioComunicazione

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="COD_ENTE_DEST", nullable = true)
    CivEnte ente

    @Column(name = "COD_COM_DEST", nullable = true)
    Integer codiceComuneDestinatario

    @Column(name = "COD_PRO_DEST", nullable = true)
    Integer codiceProvinciaDestinatario

    @Column(name = "NOTE_WS_MAIL")
    String noteWSMail

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    Ad4Utente utenteUpd

    @Transient
    ArcComune getComuneDomain() {
        if ((codiceComuneDestinatario != null) && (codiceProvinciaDestinatario != null)){
            return Holders.getApplicationContext().getBean(ArcComuneBaseService.class).getByCodiceComuneAndCodiceProvincia(codiceComuneDestinatario, codiceProvinciaDestinatario)

        }
        return null
    }

    @Transient
    String pec

    @Transient
    String getDenominazione(){
        return (comuneDomain?.descrizioneComune?:(ente?.descrizione))
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Ente, Etichette.PEC]

}
