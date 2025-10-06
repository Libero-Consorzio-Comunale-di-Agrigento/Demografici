package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.IRiferimentoAttoDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe

import javax.persistence.*

@Entity
@Table(name = "CIVANA")
class CivAnagrafe implements IRiferimentoAttoDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "TIPO_ATTO")
    Integer tipoAtto

    @Column(name = "UFFICIO")
    Integer ufficio

    @Column(name = "ANNO")
    Integer anno

    @Column(name = "ATTO")
    Integer atto

    @Column(name = "PARTE")
    Integer parte

    @Column(name = "SERIE")
    String serie

    /*@Column(name="MATRICOLA_1", nullable = true)
    Integer idAnagrafe1

    @Column(name="MATRICOLA_2", nullable = true)
    Integer idAnagrafe2 */

    @ManyToOne(fetch=FetchType.EAGER)
    @JoinColumn(name="MATRICOLA_1", nullable = true)
    AnaAnagrafe anagrafe1

    @ManyToOne(fetch=FetchType.EAGER)
    @JoinColumn(name="MATRICOLA_2", nullable = true)
    AnaAnagrafe anagrafe2

    @Column(name = "UFFICIO_ORIG", nullable = true)
    Integer ufficioAttoOriginale

    @Column(name = "ANNO_ORIG", nullable = true)
    Integer annoAttoOriginale

    @Column(name = "ATTO_ORIG", nullable = true)
    Integer attoAttoOriginale

    @Column(name = "PARTE_ORIG", nullable = true)
    Integer parteAttoOriginale

    @Column(name = "SERIE_ORIG", nullable = true)
    private String serieAttoOriginale

    String getSerieAttoOriginale() {
        return serieAttoOriginale
    }

    void setSerieAttoOriginale(String val) {
        this.serieAttoOriginale = val?.toUpperCase()
    }

    @Column(name = "COD_COM_ATTO_ORIG", nullable = true)
    Integer codiceComuneAttoOriginale

    @Column(name = "COD_PRO_ATTO_ORIG", nullable = true)
    Integer codiceProvinciaAttoOriginale

    @Column(name = "ID_ATTO_ANSC_ORIG", nullable = true)
    String idAttoAnscAttoOriginale

    /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI /////////////////////////////
    /////////////////////////////////////////////////////////////////////////

}
