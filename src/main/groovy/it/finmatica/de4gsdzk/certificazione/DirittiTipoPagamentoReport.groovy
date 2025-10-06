package it.finmatica.de4gsdzk.certificazione

class DirittiTipoPagamentoReport extends DirittiReport {
    private CerTipoPagamento tipoPagamento

    @Deprecated
    DirittiTipoPagamentoReport(CerTipoPagamento tipoPagamento) {
        super()
        this.tipoPagamento = tipoPagamento
    }

    DirittiTipoPagamentoReport(BigDecimal segreteria, BigDecimal statoCivile, BigDecimal cartaIdentita, BigDecimal rimborsoStampati, BigDecimal bollo, CerTipoPagamento tipoPagamento) {
        super(segreteria, statoCivile, cartaIdentita, rimborsoStampati, bollo)
        this.tipoPagamento = tipoPagamento
    }

    String getFormattedTipoPagamento() { tipoPagamento?.descrizione }
}