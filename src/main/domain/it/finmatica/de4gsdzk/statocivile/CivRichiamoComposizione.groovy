package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.CivRichiamoBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Table

@Entity
@Table(name = "CIVDRC")
class CivRichiamoComposizione extends CivRichiamoBaseDomain {


    @Column(name = "DESCRIZIONE")
    String descrizione

    @Column(name = "NUM_RIGHE", nullable = true)
    Integer numeroRighe

    /*
    @Column(name = "NUM_COLONNE", nullable = true)
    Integer numeroColonne
    */

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////////// GENERALI /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Descrizione, Etichette.Numero_righe]
}
