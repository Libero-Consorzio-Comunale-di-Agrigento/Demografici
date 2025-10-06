package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.utils.ESiglaEnte
import it.finmatica.de4gsdzk.utils.ETipoEnteDestinatario
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula

import javax.persistence.*

@Entity
@Table(name = "CIVDEN_V")
class CivEnte {

    @Id
    @Column(name = "CODICE_EN", nullable = false)
    Integer id

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    ESiglaEnte sigla

    @Column(name = "INDIRIZZO_PEC")
    String pec

    @Column(name = "COD_AMM")
    String codiceAMM

    @Column(name = "COD_AOO")
    String codiceAOO

    @Column(name = "COD_UO")
    String codiceUO

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_ENTE", nullable = true, updatable = false, insertable = false)
    ETipoEnteDestinatario tipoEnteDestinatario

    @Formula("CONCAT(CODICE_EN, CONCAT(' - ', DESCRIZIONE))")
    String descrizioneEstesa

    /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI /////////////////////////////
    /////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Codice, Etichette.Descrizione, Etichette.Sigla, Etichette.PEC,
                                              Etichette.Codice_AMM, Etichette.Codice_AOO, Etichette.Codice_UO]

}
