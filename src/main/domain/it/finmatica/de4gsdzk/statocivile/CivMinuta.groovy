package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.utils.ETipoRichiesta
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula

import javax.persistence.*

/**
 * Minuta di un atto
 */
@Entity
@Table(name = "CIVDMI", uniqueConstraints = @UniqueConstraint(columnNames=["TIPO_ATTO", "COD_MI"]))
class CivMinuta {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "COD_MI", nullable = false)
    Integer codice

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Column(name = "DESCRIZIONE_ESTESA")
    String descrizioneEstesa

    @Formula("CONCAT(COD_MI, CONCAT(CASE WHEN DESCRIZIONE IS NULL THEN '' ELSE ' - ' END, COALESCE(DESCRIZIONE, '')))")
    String codiceDescrizione

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_CIVCTA", nullable = true)
    CivCategoriaTipoAtto categoriaDomain

    @OneToOne(mappedBy = "minuta", cascade = CascadeType.ALL, fetch=FetchType.LAZY, optional = false)
    CivTestoMinuta testo

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_RICHIESTA", nullable = true)
    ETipoRichiesta tipoRichiesta

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Codice, Etichette.Descrizione, Etichette.Descrizione_Estesa,
                                              Etichette.Categoria, Etichette.Tipo_Atto]

}
