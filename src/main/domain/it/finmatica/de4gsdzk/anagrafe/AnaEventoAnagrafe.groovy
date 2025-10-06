package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette
import jdk.nashorn.internal.ir.annotations.Immutable

import javax.persistence.*

@Entity
@Immutable
@Table(name = "ANAEVE_VANA")
class AnaEventoAnagrafe {

    @Id
    @Column(name = "ID")
    String id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA")
    AnaAnagrafe anagrafe

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_FAM_UNIQUE_STORICO", nullable = true)
    AnaFamiglia famiglia

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_INIZIO")
    Date dataInizio

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EVE_STORICO")
    Date dataEvento

    @Column(name = "DES_EVENTO")
    String descrizione

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_DATA_CONVENZIONALE", nullable = true)
    Boolean flagDataConvenzionale

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Famiglia, Etichette.Data_Inizio, Etichette.Data_Evento, Etichette.Descrizione,
                                              Etichette.Dal, Etichette.Al, Etichette.Data_Convenzionale_tooltip]
}
