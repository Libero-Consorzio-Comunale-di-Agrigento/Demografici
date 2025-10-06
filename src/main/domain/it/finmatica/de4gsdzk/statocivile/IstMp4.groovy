package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.IstBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaNazionalita
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ISTMP4_V")
class IstMp4 extends IstBaseDomain {

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "UFFICIO", nullable = true)
    Integer ufficio

    @Column(name = "ANNO", nullable = true)
    Integer anno

    @Column(name = "ATTO", nullable = false)
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

    @ManyToOne(fetch=FetchType.EAGER)
    @JoinColumn(name="MATRICOLA", nullable = true)
    AnaAnagrafe anagrafe

    @Column(name = "NUM_COMPONENTI", nullable = true)
    Integer numeroComponenti

    @Column(name = "NUM_COMPONENTI_MINORI", nullable = true)
    Integer numeroComponentiMinori

    @Column(name = "COGNOME_INTESTATARIO", nullable = true, updatable = false, insertable = false)
    String cognomeIntestatario

    @Column(name = "NOME_INTESTATARIO", nullable = true, updatable = false, insertable = false)
    String nomeIntestatario

    @Column(name = "INDIRIZZO", nullable = true, updatable = false, insertable = false)
    String indirizzo

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_ISCRIZIONE", nullable = true, updatable = false, insertable = false)
    Date dataIscrizione

    @Column(name = "SEZIONE_CENS_DEFAULT", nullable = true, updatable = false, insertable = false)
    String sezioneCensimentoDefault

    @Column(name = "SEZIONE_CENS", nullable = true)
    Integer sezioneCensimento

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// PADRE ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_PAT", nullable = true)
    Date dataNascitaPadre

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="NAZIONALITA_PAT", nullable = true)
    AnaNazionalita nazionalitaPadre

    @Column(name = "STATO_CIVILE_PAT", nullable = true)
    String statoCivilePadre

    @Column(name = "COD_FISCALE_PAT", nullable = true)
    private String codiceFiscalePadre

    String getCodiceFiscalePadre() {
        return codiceFiscalePadre
    }

    void setCodiceFiscalePadre(String cf) {
        this.codiceFiscalePadre = cf?.toUpperCase()
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// MADRE ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_MAT", nullable = true)
    Date dataNascitaMadre

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="NAZIONALITA_MAT", nullable = true)
    AnaNazionalita nazionalitaMadre

    @Column(name = "STATO_CIVILE_MAT", nullable = true)
    String statoCivileMadre

    @Column(name = "COD_FISCALE_MAT", nullable = true)
    private String codiceFiscaleMadre

    String getCodiceFiscaleMadre() {
        return codiceFiscaleMadre
    }

    void setCodiceFiscaleMadre(String cf) {
        this.codiceFiscaleMadre = cf?.toUpperCase()
    }

    ETipoAtto getTipoAttoEnum(){
        return ETipoAtto.NAS
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Indirizzo, Etichette.Intestatario, Etichette.Data_Iscrizione,
                                              Etichette.Tot_Componenti, Etichette.Tot_Minori, Etichette.Sez_Censimento]
}
