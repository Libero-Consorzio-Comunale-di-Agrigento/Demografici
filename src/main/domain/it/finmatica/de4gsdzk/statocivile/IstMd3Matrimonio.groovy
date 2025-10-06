package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.IstMd3BaseDomain
import it.finmatica.de4gsdzk.utils.ETipoAtto

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Table
import javax.persistence.Temporal
import javax.persistence.TemporalType

@Entity
@Table(name = "ISTMD3_V_MAT")
class IstMd3Matrimonio extends IstMd3BaseDomain{

    @Column(name = "ID_ATTO_MAT", nullable = false)
    String idAtto

    @Column(name = "UFFICIO_MAT", nullable = true)
    Integer ufficio

    @Column(name = "ANNO_MAT", nullable = true)
    Integer anno

    @Column(name = "ATTO_MAT", nullable = false)
    Integer atto

    @Column(name = "PARTE_MAT", nullable = true)
    Integer parte

    @Column(name = "SERIE_MAT", nullable = true)
    private String serie

    String getSerie() {
        return serie
    }

    void setSerie(String serie) {
        this.serie = serie?.toUpperCase()
    }

    @Column(name = "RITO", nullable = true, updatable = false, insertable = false)
    Integer rito

    @Column(name = "REGIME_PATRIMONIALE", nullable = true, updatable = false, insertable = false)
    Integer regimePatrimoniale

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_FINE_MAT_M", nullable = true)
    Date dataFineMatrimonio1

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_FINE_MAT_F", nullable = true)
    Date dataFineMatrimonio2

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////  PUBBLICAZIONE  ////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "UFFICIO_PUB", nullable = true)
    Integer ufficioVerbalePubblicazione

    @Column(name = "ANNO_PUB", nullable = true)
    Integer annoVerbalePubblicazione

    @Column(name = "ATTO_PUB", nullable = false)
    Integer attoVerbalePubblicazione

    @Column(name = "PARTE_PUB", nullable = true)
    Integer parteVerbalePubblicazione

    @Column(name = "SERIE_PUB", nullable = true)
    private String serieVerbalePubblicazione

    String getSerieVerbalePubblicazione() {
        return serieVerbalePubblicazione
    }

    void setSerieVerbalePubblicazione(String s) {
        this.serieVerbalePubblicazione = s?.toUpperCase()
    }

    ETipoAtto getTipoAttoEnum(){
        return ETipoAtto.MAT
    }

}
