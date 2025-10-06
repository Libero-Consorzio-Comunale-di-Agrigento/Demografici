package it.finmatica.de4gsdzk.certificazione

import org.zkoss.xel.fn.CommonFns

class DirittiReport {
    protected BigDecimal segreteria
    protected BigDecimal statoCivile
    protected BigDecimal cartaIdentita
    protected BigDecimal rimborsoStampati
    protected BigDecimal bollo
    protected BigDecimal totale

    DirittiReport(){
        segreteria = BigDecimal.ZERO
        statoCivile = BigDecimal.ZERO
        cartaIdentita = BigDecimal.ZERO
        rimborsoStampati = BigDecimal.ZERO
        bollo = BigDecimal.ZERO
        totale = BigDecimal.ZERO
    }

    DirittiReport(BigDecimal segreteria, BigDecimal statoCivile, BigDecimal cartaIdentita, BigDecimal rimborsoStampati, BigDecimal bollo) {
        this.segreteria = segreteria ?: BigDecimal.ZERO
        this.statoCivile = statoCivile ?: BigDecimal.ZERO
        this.cartaIdentita = cartaIdentita ?: BigDecimal.ZERO
        this.rimborsoStampati = rimborsoStampati ?: BigDecimal.ZERO
        this.bollo = bollo ?: BigDecimal.ZERO
        this.totale = this.segreteria + this.statoCivile + this.cartaIdentita + this.rimborsoStampati + this.bollo
    }

    BigDecimal getTotale() { return totale }

    String getFormattedSegreteria() { CommonFns.formatNumber(segreteria, '#,##0.00') }

    String getFormattedStatoCivile() { CommonFns.formatNumber(statoCivile, '#,##0.00') }

    String getFormattedCartaIdentita() { CommonFns.formatNumber(cartaIdentita, '#,##0.00') }

    String getFormattedRimborsoStampati() { CommonFns.formatNumber(rimborsoStampati, '#,##0.00') }

    String getFormattedBollo() { CommonFns.formatNumber(bollo, '#,##0.00') }

    String getFormattedTotale() { CommonFns.formatNumber(totale, '#,##0.00') }

    static DirittiReport sum(DirittiReport d1, DirittiReport d2) {
        return new DirittiReport(d1.segreteria + d2.segreteria,
                d1.statoCivile + d2.statoCivile,
                d1.cartaIdentita + d2.cartaIdentita,
                d1.rimborsoStampati + d2.rimborsoStampati,
                d1.bollo + d2.bollo)
    }
}
