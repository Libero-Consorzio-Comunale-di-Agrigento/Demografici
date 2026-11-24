package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.IEnte
import it.finmatica.de4gsdzk.utils.ESiglaEnteStatoCivile
import it.finmatica.de4gsdzk.utils.ETipoEnteDestinatario
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula

import javax.persistence.*

@Entity
@Table(name = "CIVDEN_V")
class CivEnte extends GsdBaseDomain implements IEnte {

    @Id
    @Column(name = "CODICE_EN", nullable = false)
    Integer id

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Column(name = "SIGLA", nullable = false)
    @Enumerated(EnumType.STRING)
    ESiglaEnteStatoCivile sigla

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

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Sigla"), Etichette.getEtichetta("PEC"),
                                              Etichette.getEtichetta("Codice_AMM"), Etichette.getEtichetta("Codice_AOO"), Etichette.getEtichetta("Codice_UO")]

}
