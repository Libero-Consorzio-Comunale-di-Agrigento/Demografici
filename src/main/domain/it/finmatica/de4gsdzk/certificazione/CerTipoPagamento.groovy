package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CERDTP")
class CerTipoPagamento extends GsdBaseDomain {

    static final Integer ID_CONTANTI = 1
    static final Integer ID_POS = 2
    static final Integer ID_PAGOPA = 3
    static final Integer ID_MASTERCARD = 4
    static final Integer ID_TIPO_PAGAMENTO_5 = 5
    static final Integer ID_DIFFERITO = 8
    static final Integer ID_ALTRO = 9

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

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Descrizione")]
}
