package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CERDTP")
class CerTipoPagamento extends GsdBaseDomain {

    @Id
    @Column(name = "COD_TP")
    Integer id

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_WSPA", nullable = true)
    Boolean flagPagamentoPagoPA

    Boolean isContanti() {
        return (id == 1)
    }

    Boolean isPagamentoPagoPA() {
        return flagPagamentoPagoPA ?: Boolean.FALSE
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Codice, Etichette.Descrizione]
}
