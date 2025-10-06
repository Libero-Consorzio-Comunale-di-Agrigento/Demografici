package it.finmatica.de4gsdzk.certificazione

import org.zkoss.xel.fn.CommonFns

class FondoCassaReport {
    BigDecimal fondoCassaIniziale
    BigDecimal fondoCassaFinale

    FondoCassaReport(BigDecimal fondoCassaIniziale, BigDecimal fondoCassaFinale) {
        this.fondoCassaIniziale = fondoCassaIniziale
        this.fondoCassaFinale = fondoCassaFinale
    }

    String getFormattedFondoCassaIniziale() { CommonFns.formatNumber(fondoCassaIniziale, '#,##0.00') }

    String getFormattedFondoCassaFinale() { CommonFns.formatNumber(fondoCassaFinale, '#,##0.00') }
}
