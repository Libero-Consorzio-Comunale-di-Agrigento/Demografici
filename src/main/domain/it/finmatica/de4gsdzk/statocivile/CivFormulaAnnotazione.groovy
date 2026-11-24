package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.*
import org.hibernate.annotations.Formula
import org.hibernate.annotations.Type

import javax.persistence.*

@Entity
@Table(name = "CIVDFA", uniqueConstraints = @UniqueConstraint(columnNames=["TIPO_ATTO", "TIPO_ANNOTAZIONE", "FORMULA"]))
class CivFormulaAnnotazione extends GsdBaseDomain {

    @Id
    @Column(name = "FORMULA", nullable=false)
    private String id
    String getId() { id }
    void setId(String id) { this.id = id?.toUpperCase() }

    @Column(name = "DESCRIZIONE", nullable = false)
    private String descrizione
    String getDescrizione() { return descrizione }
    void setDescrizione(String descrizione) { this.descrizione = descrizione?.toUpperCase() }

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_ANNOTAZIONE", nullable = false)
    ETipoAnnotazione tipoAnnotazione

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_NUOVO_ORDINAMENTO", nullable = true)
    ETipoSN nuovoOrdinamentoDb

    @Formula("CASE WHEN COALESCE(FLAG_NUOVO_ORDINAMENTO, 'N') = 'N' THEN 0 ELSE 1 END")
    @Type(type="numeric_boolean")
    private Boolean nuovoOrdinamento
    Boolean getNuovoOrdinamento() { return nuovoOrdinamento }
    void setNuovoOrdinamento(Boolean val) {
        this.nuovoOrdinamento = val
        this.nuovoOrdinamentoDb = (val?ETipoSN.S:null)
    }

    /*
    // campo dismesso nell modulo zk
    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_PROVENIENZA", nullable = true)
    ETipoProvenienza tipoProvenienza
    */

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ISTAT", nullable = true)
    Boolean flagIstat

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_SECRETATO", nullable = true)
    Boolean flagSecretato

    @Enumerated(EnumType.STRING)
    @Column(name = "GENERE", nullable = true)
    EGenereAnnotazione genere

    @Formula("CONCAT(FORMULA, CONCAT(' - ', DESCRIZIONE))")
    String descrizioneEstesa

    @OneToOne(mappedBy = "formula", cascade = CascadeType.ALL, fetch = FetchType.LAZY, optional=false)
    CivTestoFormula testo

    ETipoAtto getTipoAttoEnum() { TipoAttoUtils.fromValoreDefault(tipoAtto) }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Formula"), Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Genere"), Etichette.getEtichetta("Istat"),
                                              Etichette.getEtichetta("Secretato"), Etichette.getEtichetta("Tipo"), Etichette.getEtichetta("Nuovo_Ordinamento"), Etichette.getEtichetta("Provenienza"),
                                              Etichette.getEtichetta("Tipo_Atto"), Etichette.getEtichetta("Testo")]
}
