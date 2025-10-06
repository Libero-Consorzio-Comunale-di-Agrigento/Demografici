package it.finmatica.de4gsdzk.certificazione

class DirittiRiepilogoReport extends DirittiReport {
    Date dataRiepilogo

    @Deprecated
    DirittiRiepilogoReport(Date dataRiepilogo) {
        super()
        this.dataRiepilogo = dataRiepilogo
    }

    DirittiRiepilogoReport(BigDecimal segreteria, BigDecimal statoCivile, BigDecimal cartaIdentita, BigDecimal rimborsoStampati, BigDecimal bollo, Date dataRiepilogo) {
        super(segreteria, statoCivile, cartaIdentita, rimborsoStampati, bollo)
        this.dataRiepilogo = dataRiepilogo
    }

    String getFormattedDataRiepilogo() { dataRiepilogo?.format('dd/MM/yyyy') }
}