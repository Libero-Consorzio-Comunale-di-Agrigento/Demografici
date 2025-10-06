package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.IstMd3BaseDomain
import it.finmatica.de4gsdzk.utils.ETipoAtto

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Table
import javax.persistence.Temporal
import javax.persistence.TemporalType

@Entity
@Table(name = "ISTMD3_V_PUB")
class IstMd3Pubblicazione extends IstMd3BaseDomain{

    @Column(name = "ID_ATTO_PUB", nullable = false)
    String idAtto

    @Column(name = "UFFICIO_PUB", nullable = true)
    Integer ufficio

    @Column(name = "ANNO_PUB", nullable = true)
    Integer anno

    @Column(name = "ATTO_PUB", nullable = false)
    Integer atto

    @Column(name = "PARTE_PUB", nullable = true)
    Integer parte

    @Column(name = "SERIE_PUB", nullable = true)
    private String serie

    String getSerie() {
        return serie
    }

    void setSerie(String serie) {
        this.serie = serie?.toUpperCase()
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_FINE_MAT_M", nullable = true)
    Date dataFineMatrimonio1

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_FINE_MAT_F", nullable = true)
    Date dataFineMatrimonio2

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////  MATRIMONIO  //////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "UFFICIO_MAT", nullable = true)
    Integer ufficioMatrimonio

    @Column(name = "ANNO_MAT", nullable = true)
    Integer annoMatrimonio

    @Column(name = "ATTO_MAT", nullable = false)
    Integer attoMatrimonio

    @Column(name = "PARTE_MAT", nullable = true)
    Integer parteMatrimonio

    @Column(name = "SERIE_MAT", nullable = true)
    private String serieMatrimonio

    String getSerieMatrimonio() {
        return serieMatrimonio
    }

    void setSerieMatrimonio(String s) {
        this.serieMatrimonio = s?.toUpperCase()
    }

    ETipoAtto getTipoAttoEnum(){
        return ETipoAtto.PUB
    }

}
