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

@Entity
@Table(name = "WS_MININT_ELEELI_V")
class EleListaWs extends GsdBaseDomain {

    @Id
    @Column(name = "ID", updatable = false, insertable = false)
    Long id

    @Column(name = "NUMERO_PROGRESSIVO_AREA_LISTE")
    Long numeroProgressivoAreaListe

    @Column(name = "CODICE_PROVINCIA")
    Long codiceProvincia

    @Column(name = "DESCRIZIONE_PROVINCIA")
    String descrizioneProvincia

    @Column(name = "CODICE_LISTA")
    Long codiceLista

    @Column(name = "DESCRIZIONE_LISTA")
    String descrizioneLista

    @OneToOne
    @JoinColumn(name = "ELEZIONE_ADS", nullable = false)
    De4Elezione elezioneAds

    @Column(name = "LISTA_ADS")
    Long listaAds

    @Column(name = "NUMERO_ORDINE_ADS")
    Long numeroOrdineAds

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_INVIO_ADS")
    Boolean flagInvioAds

    @OneToOne
    @JoinColumn(name = "ID_ELEDCE_ADS", nullable = false, updatable = false, insertable = false)
    EleElezione elezione

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Numero_Progressivo_Area_Liste"), Etichette.getEtichetta("Codice_Lista"),
                                              Etichette.getEtichetta("Descrizione_Lista"), Etichette.getEtichetta("Elezione_Ads"),
                                              Etichette.getEtichetta("Lista_Ads"), Etichette.getEtichetta("Numero_Ordine_Ads"),
                                              Etichette.getEtichetta("Flag_Invio_Ads")]

}