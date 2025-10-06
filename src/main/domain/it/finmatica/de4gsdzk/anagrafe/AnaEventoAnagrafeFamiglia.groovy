package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.Etichette
import jdk.nashorn.internal.ir.annotations.Immutable

import javax.persistence.*

@Entity
@Immutable
@Table(name = "ANAANA_STORICO_X_COD_FAM")
class AnaEventoAnagrafeFamiglia {

    @Id
    @Column(name = "ID")
    String id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_FAM_UNIQUE", nullable = true)
    AnaFamiglia famiglia

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA", nullable = true)
    AnaAnagrafe anagrafe

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EVE", nullable = false)
    Date dataEvento

    @Column(name = "DES_RAPPORTO_PAR", updatable = false, insertable = false)
    String rapportoParentela

    @Column(name = "SEQUENZA_PAR")
    Integer sequenzaParentela

    @Column(name = "DES_STATO", updatable = false, insertable = false)
    String descrizione

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Data_Evento, Etichette.Rapporto_Parentela, Etichette.Descrizione]

}
