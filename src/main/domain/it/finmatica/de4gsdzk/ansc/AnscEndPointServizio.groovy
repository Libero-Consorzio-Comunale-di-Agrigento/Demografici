package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETabComunicazioniAnsc
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula

import javax.persistence.*

@Entity
@Table(name = "ANSTWS")
class AnscEndPointServizio extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    private String id

    String getId() {
        return id
    }

    void setId(String val) {
        this.id = (val?.toUpperCase())
    }

    @Column(name = "SERVIZIO", nullable = false)
    private String servizio

    String getServizio() {
        return servizio
    }

    void setServizio(String val) {
        this.servizio = (val?.toUpperCase())
    }

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Column(name = "URL", nullable = false)
    String indirizzoURL

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ALLEGATI", nullable = true)
    Boolean flagAllegati

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_RIPETIZIONE", nullable = true)
    Boolean flagRipetizione

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_VERIFICA", nullable = true)
    Boolean flagVerifica

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_DOWNLOAD_ALLEGATO", nullable = true)
    Boolean flagDownloadAllegato

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_OBBLIGATORIO", nullable = true)
    Boolean flagObbligatorio

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_ATTRIBUTO_JWS", nullable = true)
    Boolean flagJwsEnabled

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_OTP_FIRMA", nullable = true)
    Boolean flagOtpFirma

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_INVIO_MAIL_FIRMA", nullable = true)
    Boolean flagInvioMailFirma

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_ANNULLA_LINK_FIRMA", nullable = true)
    Boolean flagAnnullaLinkFirma

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_CONSULTAZIONE_SOG", nullable = true)
    Boolean flagConsultazioneSoggetto

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_CONSULTAZIONE_SOG_PRE", nullable = true)
    Boolean flagAfterConsultazioneSoggetto

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_CONSULTAZIONE_EVE", nullable = true)
    Boolean flagConsultazioneEvento

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_CONSULTAZIONE_EVE_POST", nullable = true)
    Boolean flagBeforeConsultazioneEvento

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_NOTIFICA_RICERCA", nullable = true)
    Boolean flagNotificaRicerca

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_NOTIFICA_CONFERMA", nullable = true)
    Boolean flagNotificaConferma

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_NOTIFICA_RIFIUTO", nullable = true)
    Boolean flagNotificaRifiuto

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ANNOTAZIONI", nullable = true)
    Boolean flagAnnotazioni

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_VALIDAZIONE", nullable = true)
    Boolean flagValidazione

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_FIRMA_CARTACEA", nullable = true)
    Boolean flagFirmaCartacea

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_POOLING_PRESA_VISIONE", nullable = true)
    Boolean flagPoolingPresaVisione

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_CONSULTAZIONE_PV_POST", nullable = true)
    Boolean flagBeforeConsultazionePresaVisione

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_CERTIFICATO_SEMPLICE", nullable = true)
    Boolean flagCertificatoSemplice

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ESTRATTO_RIASSUNTO", nullable = true)
    Boolean flagEstrattoXRiassunto

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ESTRATTO_INTEGRALE", nullable = true)
    Boolean flagEstrattoIntegrale

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ATTESTAZIONE", nullable = true)
    Boolean flagAttestazione

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_DEFAULT", nullable = true)
    Boolean flagDefault

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_VISIBILE", nullable = true)
    Boolean flagVisibile

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_CONSULTAZIONE_SOG_PAR", nullable = true)
    Boolean flagConsultazioneSoggPar

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ALERT_ATTO_RETTIFICATO", nullable = true)
    Boolean flagAlertAttoRettificato

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_CERTIFICAZIONE", nullable = true)
    Boolean flagCertificazione

    @Column(name = "FLAG_ENTE_RICHIEDENTE", nullable = true)
    String flagEnteRichiedente

    @Formula("CONCAT(SERVIZIO, CONCAT(CASE WHEN SERVIZIO IS NULL THEN '' ELSE ' - ' END, COALESCE(DESCRIZIONE, '')))")
    String descrizioneEstesa

    @Enumerated(EnumType.STRING)
    @Column(name = "TAB_COMUNICAZIONE", nullable = true)
    ETabComunicazioniAnsc tabComunicazione

    @Version
    Long version

    Boolean isCertificazione() {
        return flagCertificazione ?: Boolean.FALSE
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Servizio"), Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Flag_Allegati"), Etichette.getEtichetta("Flag_Ripetizione"),
                                              Etichette.getEtichetta("Flag_Verifica"), Etichette.getEtichetta("Flag_Download_Allegato"), Etichette.getEtichetta("Flag_Obbligatorio"), Etichette.getEtichetta("Flag_Visibile"), Etichette.getEtichetta("Url")]

}
