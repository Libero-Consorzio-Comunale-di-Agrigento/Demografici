package it.finmatica.de4gsdzk.anagrafe


import it.finmatica.de4gsdzk.utils.IIndirizzoNonResidente
import it.finmatica.de4gsdzk.utils.IIndirizzoResidente
import it.finmatica.de4gsdzk.utils.IIndirizzoResidenteEstero
import spock.lang.Shared
import spock.lang.Specification
import spock.lang.Unroll

class AnagrafeUtilsSpec extends Specification {

    @Shared
    IIndirizzoResidente ir = Mock(IIndirizzoResidente)
    @Shared
    IIndirizzoResidenteEstero ire = Mock(IIndirizzoResidenteEstero)
    @Shared
    IIndirizzoNonResidente inr = Mock(IIndirizzoNonResidente)

    @Unroll
    void 'Scelta dell\'indirizzo corretto in base alla fascia'() {
        expect:
        AnagrafeUtils.getIndirizzo(fascia, ir, ire, inr).is(expected)

        where:
        fascia                                | expected
        EFascia.ISCRITTO_APR                  | ir
        EFascia.CANCELLATO_APR                | ir
        EFascia.ISCRITTO_AIRE                 | ire
        EFascia.CANCELLATO_AIRE               | ire
        EFascia.ISCRIZIONE_ATTESA_O_ANNULLATA | inr
        EFascia.NON_RESIDENTE                 | inr
    }
}
