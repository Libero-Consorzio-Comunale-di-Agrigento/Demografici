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
@Table(name = "WS_MININT_ELEELE_V")
class EleElezioneWs extends GsdBaseDomain {

    @Id
    @Column(name = "ID", updatable = false, insertable = false)
    Long id

    @Column(name = "TIPO_ELEZIONE")
    Long tipoElezione

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "DATA_ELEZIONE")
    Date dataElezione

    @Column(name = "DESCRIZIONE_ELEZIONE")
    String descrizioneElezione

    @Column(name = "ANNO_ELEZIONI_ADS")
    Long annoElezioniAds

    @Column(name = "PROGR_ELEZIONI_ADS")
    Long progrElezioniAds

    @OneToOne
    @JoinColumn(name = "ELEZIONE_ADS", nullable = false)
    De4Elezione elezioneAds

    @Column(name = "NUMERO_QUESITO")
    Long numeroQuesito

    @Column(name = "DESCRIZIONE_QUESITO")
    String descrizioneQuesito

    @OneToOne
    @JoinColumn(name = "ID_ELEDCE_ADS", nullable = false, updatable = false, insertable = false)
    EleElezione elezione

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Tipo_Elezione"), Etichette.getEtichetta("Data_Elezione"),
                                              Etichette.getEtichetta("Descrizione_Elezione"), Etichette.getEtichetta("Anno_Elezioni"),
                                              Etichette.getEtichetta("Progr_Elezioni"), Etichette.getEtichetta("Elezione_Ads"),
                                              Etichette.getEtichetta("Numero_Quesito"), Etichette.getEtichetta("Descrizione_Quesito")]


}