package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Convert
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.OneToOne
import javax.persistence.Table
import javax.persistence.Temporal
import javax.persistence.TemporalType

@Entity
@Table(name = "WS_MININT_ELEERI_V")
class EleRilevamentoWs extends GsdBaseDomain {

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

    @OneToOne
    @JoinColumn(name = "ELEZIONE_ADS", nullable = false)
    De4Elezione elezioneAds

    @Column(name = "RILEVAMENTO_ADS")
    Long rilevamentoAds

    @Column(name = "DES_RILEVAMENTO_ADS", updatable = false, insertable = false)
    String descrizioneRilevamentoAds

    @Column(name = "SEQUENZA_ADS")
    Long sequenzaAds

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "ULTIMO_ADS")
    Boolean ultimoAds

    @OneToOne
    @JoinColumn(name = "ID_ELEDCE_ADS", nullable = false, updatable = false, insertable = false)
    EleElezione elezione

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Descrizione"),
                                              Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Elezione_Ads"),
                                              Etichette.getEtichetta("Rilevamento_Ads"), Etichette.getEtichetta("Sequenza_Ads"),
                                              Etichette.getEtichetta("Ultimo_Ads")]

}