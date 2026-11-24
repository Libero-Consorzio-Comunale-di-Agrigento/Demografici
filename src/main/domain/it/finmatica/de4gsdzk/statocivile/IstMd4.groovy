package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.IstBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanza
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ISTMD4_V")
class IstMd4 extends IstBaseDomain {

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

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="NAZIONALITA", nullable = true)
    AnaCittadinanza nazionalita

    @Column(name = "NAZIONALITA_ITA", nullable = false)
    Integer nazionalitaItaliana1

    @Column(name = "NUMERO_SCHEDA", nullable = true)
    Integer numeroScheda

    @Column(name = "GRADO_ISTRUZIONE", nullable = true)
    Integer gradoIstruzione1

    @Column(name = "POSIZIONE_PROF", nullable = true)
    Integer posizioneProfessionale1

    @Column(name = "CONDIZIONE_PROF", nullable = true)
    Integer condizioneProfessionale1

    @Column(name = "ATTIVITA_PROF", nullable = true)
    Integer attivitaProfessionale1

    @Column(name = "ANNO_MAT", nullable = true)
    Integer annoMatrimonio

    @Column(name = "ANNO_NAS_CN", nullable = true)
    Integer annoNascitaConiuge

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_SEPARATO", nullable = true)
    Boolean separato

    ETipoAtto getTipoAttoEnum(){
        return ETipoAtto.MOR
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Data_morte"),
                                              Etichette.getEtichetta("Numero_ordine_scheda"), Etichette.getEtichetta("Separato_legalmente"),
                                              Etichette.getEtichetta("Anno_nascita_coniuge"), Etichette.getEtichetta("Anno_matrimonio")]
}
