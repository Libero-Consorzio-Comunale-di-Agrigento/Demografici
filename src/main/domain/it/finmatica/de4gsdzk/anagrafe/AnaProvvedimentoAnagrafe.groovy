package it.finmatica.de4gsdzk.anagrafe

import jdk.nashorn.internal.ir.annotations.Immutable

import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.Table

@Entity
@Immutable
@Table(name = "ANAMOV_X_ANASEN")
class AnaProvvedimentoAnagrafe extends AnaMovimentoBaseDomain {

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="ID_ANASEN", nullable = true)
    AnaDettaglioProvvedimento dettaglioProvvedimento
}
