package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.DomainUtils

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "CERINC_V")
class CerIndividuoCertificato extends GsdBaseDomain {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ANNO_EMISSIONE", nullable = true)
    Integer annoEmissione

    @Column(name = "PROGR_EMISSIONE", nullable = false)
    Integer progressivoEmissione

    @Column(name = "MATRICOLA")
    Integer matricola

    @Column(name = "UFFICIO", nullable = true)
    Integer ufficio

    @Column(name = "ANNO", nullable = true)
    Integer anno

    @Column(name = "ATTO", nullable = true)
    Integer atto

    @Column(name = "PARTE", nullable = true)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    private String serie

    String getSerie() {
        return serie
    }

    void setSerie(String serie) {
        this.serie = serie?.toUpperCase()
    }

    @Column(name = "TIPO_ATTO", nullable = true, updatable = false, insertable = false)
    Integer tipoAtto

    String getIdEmissione(){
        DomainUtils.calculateIdEmissione(annoEmissione, progressivoEmissione)
    }
}
