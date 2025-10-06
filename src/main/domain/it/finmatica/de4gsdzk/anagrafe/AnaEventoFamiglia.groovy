package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.Etichette
import jdk.nashorn.internal.ir.annotations.Immutable

import javax.persistence.*

@Entity
@Immutable
@Table(name = "ANAEVE_FAMIGLIA")
class AnaEventoFamiglia {

    @Id
    @Column(name = "ID")
    String id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_FAM_UNIQUE")
    AnaFamiglia famiglia

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EVE")
    Date dataEvento

    @Column(name = "DES_COD_EVE_PR")
    String descrizione

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Data_Evento, Etichette.Descrizione]
}
