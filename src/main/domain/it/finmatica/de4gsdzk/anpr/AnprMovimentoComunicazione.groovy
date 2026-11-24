package it.finmatica.de4gsdzk.anpr

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizio
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula
import org.hibernate.annotations.Type

import javax.persistence.*

@Entity
@Table(name = "ANPMCU_V_ZK")
class AnprMovimentoComunicazione extends GsdBaseDomain{

    @Id
    @Column(name = "ID_OPERAZIONE")
    Long id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SERVIZIO", nullable = true)
    AnprEndPointServizio servizio

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "D_DATA_REG", nullable = false)
    Date dataRegistrazione

    @Column(name = "ID_OPERAZIONE_ANPR")
    Long idANPR

    @Column(name = "ESITO_ANPR", nullable = false)
    String esito

    @Column(name = "DES_ESITO_ANPR", nullable = false, updatable = false, insertable = false)
    String esitoDescrizione

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_INVIO_WS", nullable = true)
    Boolean flagInviato

    @Column(name = "NOTE_WS_VIS", nullable = true, updatable = false, insertable = false)
    String noteWSAnpr

    @Column(name = "INFO_WS_VIS", nullable = true, updatable = false, insertable = false)
    String infoWSAnpr

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "D_DATA_INVIO_WS", nullable = false)
    Date dataInvio

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Id"), Etichette.getEtichetta("Servizio"), Etichette.getEtichetta("Data_Invio"), Etichette.getEtichetta("Data_Registrazione"), Etichette.getEtichetta("Esito"), Etichette.getEtichetta("Note")]
}

