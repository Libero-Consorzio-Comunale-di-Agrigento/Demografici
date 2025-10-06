package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.utils.ETipoFormulaAnnotazioneDaAtto
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVTLI_ANNOTAZIONI", uniqueConstraints = @UniqueConstraint(columnNames=["TIPO_ATTO", "UFFICIO", "ANNO", "PARTE", "SERIE", "ATTO", "FORMULA"]))
class CivAnnotazioneTestoLibero {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Column(name = "UFFICIO", nullable = false)
    Integer ufficio

    @Column(name = "ANNO", nullable = false)
    Integer anno

    @Column(name = "ATTO", nullable = false)
    Integer atto

    @Column(name = "PARTE", nullable = true)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    String serie

    @Column(name = "FORMULA", nullable = false)
    String formula

    @Column(name = "NUM_RIGHE", nullable = true)
    Integer numeroRighe

    @Column(name = "NUM_COLONNE", nullable = true)
    Integer numeroColonne

    @Lob
    @Column(name = "TESTO_CLOB", nullable = true)
    String testo

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_FORMULA", nullable = true)
    ETipoFormulaAnnotazioneDaAtto tipoFormula

    @Column(name = "SEQUENZA")
    Integer sequenza

    @Version
    @Column(nullable = false)
    Long version

    /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI /////////////////////////////
    /////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [ Etichette.Ufficio, Etichette.Anno, Etichette.Parte, Etichette.Serie, Etichette.Numero_Atto]


}
