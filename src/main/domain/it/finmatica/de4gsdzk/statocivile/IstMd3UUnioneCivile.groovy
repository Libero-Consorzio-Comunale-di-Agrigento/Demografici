package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.IstMd3BaseDomain
import it.finmatica.de4gsdzk.utils.ETipoAtto

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Table
import javax.persistence.Temporal
import javax.persistence.TemporalType

@Entity
@Table(name = "ISTMDU_V_UCI")
class IstMd3UUnioneCivile extends IstMd3BaseDomain{

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

    @Column(name = "REGIME_PATRIMONIALE", nullable = true, updatable = false, insertable = false)
    Integer regimePatrimoniale

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_FINE_MAT_M", nullable = true)
    Date dataFineMatrimonio1

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_FINE_MAT_F", nullable = true)
    Date dataFineMatrimonio2

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////  PROCESSO VERBALE  ////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "UFFICIO_PUB", nullable = true)
    Integer ufficioPubblicazione

    @Column(name = "ANNO_PUB", nullable = true)
    Integer annoPubblicazione

    @Column(name = "ATTO_PUB", nullable = false)
    Integer attoPubblicazione

    @Column(name = "PARTE_PUB", nullable = true)
    Integer partePubblicazione

    @Column(name = "SERIE_PUB", nullable = true)
    private String seriePubblicazione

    String getSeriePubblicazione() {
        return seriePubblicazione
    }

    void setSeriePubblicazione(String s) {
        this.seriePubblicazione = s?.toUpperCase()
    }

    ETipoAtto getTipoAttoEnum(){
        return ETipoAtto.UCI
    }

}
