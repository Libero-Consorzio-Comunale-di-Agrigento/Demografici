package it.finmatica.de4gsdzk.anagrafe


import jdk.nashorn.internal.ir.annotations.Immutable

import javax.persistence.*

@Entity
@Immutable
@Table(name = "ANAFAM_STORICO_X_MATRICOLA")
class AnaStoricoFamiglia {

    @Id
    @Column(name = "ID")
    String id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_FAM_UNIQUE", nullable = true)
    AnaFamiglia famiglia

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA", nullable = true)
    AnaAnagrafe anagrafe

}
