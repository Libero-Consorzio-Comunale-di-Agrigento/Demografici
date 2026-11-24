package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "WS_MININT_ELEDTE_V")
class EleTipoElezioneWs extends GsdBaseDomain {

    @Id
    @Column(name = "ID", updatable = false, insertable = false)
    Long id

    @Column(name = "COD_TE")
    Long codice

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Column(name = "COD_TE_ADS")
    Long codTeAds

    @Column(name = "DESCRIZIONE_ADS", updatable = false, insertable = false)
    String descrizioneAds

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Tipo_Elezione"), Etichette.getEtichetta("Descrizione"),
                                              Etichette.getEtichetta("Tipo_Elezione_Ads"), Etichette.getEtichetta("Descrizione_Ads")]


}