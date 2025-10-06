package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.statocivile.embed.Comune

import javax.persistence.*

@MappedSuperclass
abstract class IstMd3BaseDomain extends IstBaseDomain {

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////// SOGGETTO 1 ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "STATO_CIVILE_M", nullable = true)
    String statoCivile1

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_RES_POST_M")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_RES_POST_M", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_RES_POST_M")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_RES_POST_M", updatable = false, insertable = false))
    ])
    private Comune comuneResidenza1
    Comune getComuneResidenza1() {
        if (comuneResidenza1 == null){
            comuneResidenza1 = new Comune()
        }
        return comuneResidenza1
    }
    void setComuneResidenza1(Comune c) {
        this.comuneResidenza1 = c
    }

    @Column(name = "GRADO_ISTRUZIONE_M", nullable = true)
    Integer gradoIstruzione1

    @Column(name = "POSIZIONE_PROF_M", nullable = true)
    Integer posizioneProfessionale1

    @Column(name = "CONDIZIONE_PROF_M", nullable = true)
    Integer condizioneProfessionale1

    @Column(name = "ATTIVITA_PROF_M", nullable = true)
    Integer attivitaProfessionale1

    @Column(name = "NAZIONALITA_ITA_M", nullable = false)
    Integer nazionalitaItaliana1

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////// SOGGETTO 2 ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "STATO_CIVILE_F", nullable = true)
    String statoCivile2

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_RES_POST_F")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_RES_POST_F", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_RES_POST_F")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_RES_POST_F", updatable = false, insertable = false))
    ])
    private Comune comuneResidenza2
    Comune getComuneResidenza2() {
        if (comuneResidenza2 == null){
            comuneResidenza2 = new Comune()
        }
        return comuneResidenza2
    }
    void setComuneResidenza2(Comune c) {
        this.comuneResidenza2 = c
    }

    @Column(name = "GRADO_ISTRUZIONE_F", nullable = true)
    Integer gradoIstruzione2

    @Column(name = "POSIZIONE_PROF_F", nullable = true)
    Integer posizioneProfessionale2

    @Column(name = "CONDIZIONE_PROF_F", nullable = true)
    Integer condizioneProfessionale2

    @Column(name = "ATTIVITA_PROF_F", nullable = true)
    Integer attivitaProfessionale2

    @Column(name = "NAZIONALITA_ITA_F", nullable = false)
    Integer nazionalitaItaliana2

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

}
