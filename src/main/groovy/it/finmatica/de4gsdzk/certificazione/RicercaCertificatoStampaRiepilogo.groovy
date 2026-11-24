package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.certificazione.error.DataRiepilogoNonValidaException
import it.finmatica.de4gsdzk.utils.DataUtils
import it.finmatica.de4gsdzk.utils.Etichette

class RicercaCertificatoStampaRiepilogo {

    boolean stampaRiepilogo
    Date dataFineRiepilogo

    private Date dataRiepilogoDal
    private Date dataRiepilogoAl

    RicercaCertificatoStampaRiepilogo() {
        this.stampaRiepilogo = false
    }

    Date getDataRiepilogoDal() {
        return dataRiepilogoDal
    }

    Date getDataRiepilogoAl() {
        return dataRiepilogoAl
    }

    void calculateDateRiepilogo() {
        if (!stampaRiepilogo) {
            reset()
            return
        }

        if (dataFineRiepilogo == null) {
            reset()
            return
        }

        Date firstDayOfYear = DataUtils.firstDayOfYear(dataFineRiepilogo)
        if (dataFineRiepilogo == firstDayOfYear) {
            reset()
            throw new DataRiepilogoNonValidaException()
        }
        this.dataRiepilogoDal = firstDayOfYear

        Date dataRiepilogoAl = DataUtils.subtractDays(dataFineRiepilogo, 1)
        this.dataRiepilogoAl = dataRiepilogoAl
    }

    private void reset() {
        this.stampaRiepilogo = false
        this.dataRiepilogoDal = null
        this.dataRiepilogoAl = null
    }

    static final List<Map> etichetteRicercaCerStampaRiepilogoDesc = [Etichette.getEtichetta("Stampa_Riepilogo")]
}
