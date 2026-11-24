package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.OneToOne
import javax.persistence.Table
import javax.persistence.Temporal
import javax.persistence.TemporalType

@Entity
@Table(name = "WS_MININT_ELECOM_V")
class EleComunicazioneWs extends GsdBaseDomain {

    @Id
    @Column(name = "ID", updatable = false, insertable = false)
    Long id

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "DATA_ORA_INIZIO")
    Date dataOraInizio

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Column(name = "TIPO_DATI")
    String tipoDati

    @Column(name = "CODICE_TIPO_ELETTORE")
    Long codiceTipoElettore

    @Column(name = "DESCRIZIONE_TIPO_ELETTORE")
    String descrizioneTipoElettore

    @OneToOne
    @JoinColumn(name = "ELEZIONE_ADS", nullable = false)
    De4Elezione elezioneAds

    @OneToOne
    @JoinColumn(name = "ID_ELEDCE_ADS", nullable = false, updatable = false, insertable = false)
    EleElezione elezione

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Codice"),
                                              Etichette.getEtichetta("Elezione_Ads")]

}