package it.finmatica.de4gsdzk.pagamento

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Slf4j
@Entity
@Table(name = "WS_PAGAMENTI_TES_V_INVIATI")
class WspaPagamentoInviato extends GsdBaseDomain {
    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ANNO_PAGAMENTO")
    Integer anno

    @Column(name = "PROGR_PAGAMENTO")
    Integer progressivo

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_INVIO_WS", nullable = false)
    Date dataInvio

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_INVIO_WS")
    Boolean flagInvio

    @Column(name = "NOTE_WS")
    String note

    @Column(name = "CHIAVE_PROVIDER")
    String chiaveServizioEsterno

    @Column(name = "URL_PROVIDER")
    String urlServizioEsterno

    @Column(name = "COD_FISCALE_PAGATORE")
    String codiceFiscalePagatore

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "pagamentoInviato")
    List<WspaPagamentoInviatoDettaglio> documenti

    Long getNumeroDocumenti() {
        return documenti.size()
    }

    BigDecimal getImportoTotale() {
        BigDecimal totale = 0
        documenti.each { WspaPagamentoInviatoDettaglio dettaglio ->
            totale += dettaglio.importo
        }
        return totale
    }

    Boolean isInviatoConSuccesso(){
        return flagInvio && (chiaveServizioEsterno != null)
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Progressivo"), Etichette.getEtichetta("Data"), Etichette.getEtichetta("Numero"), Etichette.getEtichetta("Totale_Diritti"),
                                             Etichette.getEtichetta("Codice_Fiscale"), Etichette.getEtichetta("Inviato"), Etichette.getEtichetta("Chiave"), Etichette.getEtichetta("Note"), Etichette.getEtichetta("Data_Invio"), Etichette.getEtichetta("Stato_pagamento")]

}
