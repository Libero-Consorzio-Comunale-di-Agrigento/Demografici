package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula
import org.hibernate.annotations.Type

import javax.persistence.*

@Entity
@Table(name = "ANSCIU_V")
class AnscComunicazione extends GsdBaseDomain{

    @Id
    @Column(name = "ID_OPERAZIONE")
    Long id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SERVIZIO", nullable = true)
    AnscEndPointServizio servizio

    @Enumerated(EnumType.STRING)
    @Column(name = "ARCHIVIO_RIF", nullable = false)
    ETipoArchivioAnsc archivioRif

    @Column(name = "ID_RIF")
    Long idRif

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "D_DATA_REG", nullable = false)
    Date dataRegistrazione

    @Column(name = "ID_OPERAZIONE_ANSC")
    Long idANSC

    @Column(name = "ESITO_ANSC", nullable = false)
    String esito

    @Column(name = "DES_ESITO_ANSC", nullable = false, updatable = false, insertable = false)
    String esitoDescrizione

    /*
    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_INVIO_WS", nullable = true)
    Boolean flagInviato
    */

    @Formula("CASE WHEN COALESCE(FLAG_INVIO_WS, 'N') = 'N' THEN 0 ELSE 1 END")
    @Type(type="numeric_boolean")
    Boolean inviato

    @Formula("CASE WHEN COALESCE(FLAG_HTTP_ERROR, 'N') = 'N' THEN 0 ELSE 1 END")
    @Type(type = "numeric_boolean")
    Boolean httpError

    @Column(name = "NOTE_WS_VIS", nullable = true, updatable = false, insertable = false)
    String noteWSAnsc

    @Column(name = "INFO_WS_VIS", nullable = true, updatable = false, insertable = false)
    String infoWSAnsc

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "D_DATA_INVIO_WS", nullable = false)
    Date dataInvio

    @Column(name = "ID_ATTO", nullable = true)
    String idAtto

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Id"), Etichette.getEtichetta("Servizio"), Etichette.getEtichetta("Data_Invio"), Etichette.getEtichetta("Data_Registrazione"), Etichette.getEtichetta("Esito"), Etichette.getEtichetta("Note")]
}

