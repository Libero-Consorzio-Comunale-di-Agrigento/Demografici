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
@Table(name = "WS_MININT_ELEVTS_V")
class EleSezioneVotantiWs extends GsdBaseDomain {

    @Id
    @Column(name = "ID", updatable = false, insertable = false)
    Long id

    @Column(name = "CODICE_PROVINCIA")
    Long codiceProvincia

    @Column(name = "DESCRIZIONE_PROVINCIA")
    String descrizioneProvincia

    @Column(name = "CODICE_COMUNE")
    Long codiceComune

    @Column(name = "DESCRIZIONE_COMUNE")
    String descrizioneComune

    @Column(name = "LIVELLO_ACQUISIZIONE")
    String livelloAcquisizione

    @Column(name = "CODICE_SEZIONE")
    Long codiceSezione

    @Column(name = "DESCRIZIONE_SEZIONE")
    String descrizioneSezione

    @Column(name = "NUMERO_PROGRESSIVO_AREA")
    Long numeroProgressivoArea

    @Column(name = "NUMERO_POSIZIONE")
    Long numeroPosizione

    @Column(name = "CODICE_TIPO_SEZIONE")
    Long codiceTipoSezione

    @Column(name = "DESCRIZIONE_TIPO_SEZIONE")
    String descrizioneTipoSezione

    @OneToOne
    @JoinColumn(name = "ELEZIONE_ADS", nullable = false)
    De4Elezione elezioneAds

    @Column(name = "SEZIONE_ADS")
    Long sezioneAds

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_INVIO_ADS")
    Boolean flagInvioAds

    @Column(name = "COD_ESITO_WS")
    String codEsitoWs

    @Column(name = "DES_ESITO_WS")
    String desEsitoWs

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "DATA_ORA_WS")
    Date dataOraWs

    @OneToOne
    @JoinColumn(name = "ID_ELEDCE_ADS", nullable = false, updatable = false, insertable = false)
    EleElezione elezione

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Descrizione"),
                                              Etichette.getEtichetta("Numero_Progressivo_Area"), Etichette.getEtichetta("Numero_Posizione"),
                                              Etichette.getEtichetta("Codice_Tipo"), Etichette.getEtichetta("Descrizione_Tipo"),
                                              Etichette.getEtichetta("Sezione_Ads"), Etichette.getEtichetta("Elezione_Ads"), Etichette.getEtichetta("Flag_Invio_Ads"),
                                              Etichette.getEtichetta("Cod_Esito_Ws"), Etichette.getEtichetta("Des_Esito_Ws"),
                                              Etichette.getEtichetta("Data_Ora_Ws")]

}