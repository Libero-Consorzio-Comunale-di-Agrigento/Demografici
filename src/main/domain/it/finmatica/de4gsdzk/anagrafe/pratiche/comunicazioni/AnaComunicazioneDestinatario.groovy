package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.IComunicazioneDestinatario
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANACOM_DEST")
class AnaComunicazioneDestinatario extends GsdBaseDomain implements IComunicazioneDestinatario {

    @Id
    @Column(name = "ID")
    Long id

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_COM", nullable = false)
    AnaArchivioComunicazione archivioComunicazione

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="COD_ENTE_DEST", nullable = true)
    AnaEnte ente

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

    //TODO COD_CONSOLATO_DEST                                 NUMBER(5)
    //TODO TIPO_CONSOLATO_DEST                                NUMBER(2)

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Destinatari"), Etichette.getEtichetta("Ente"), Etichette.getEtichetta("PEC")]

}
