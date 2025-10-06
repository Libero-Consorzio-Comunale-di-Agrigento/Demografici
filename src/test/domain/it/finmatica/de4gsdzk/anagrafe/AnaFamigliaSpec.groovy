package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoNonResidenteFamiglia
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteEsteroFamiglia
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteFamiglia
import it.finmatica.de4gsdzk.utils.IIndirizzo
import spock.lang.Specification
import spock.lang.Unroll

class AnaFamigliaSpec extends Specification {

    @Unroll
    void "AnaFamiglia restituisce un indirizzo coerente alla fascia"() {
        given:
        AnaFamiglia famiglia = new AnaFamiglia(fascia: fascia,
                indirizzoResidente: new IndirizzoResidenteFamiglia(),
                indirizzoResidenteEstero: new IndirizzoResidenteEsteroFamiglia(),
                indirizzoNonResidente: new IndirizzoNonResidenteFamiglia())

        expect:
        famiglia instanceof IIndirizzo
        indirizzo.name == famiglia.indirizzo?.class?.name

        where:
        fascia                                | indirizzo
        EFascia.ISCRITTO_APR   | IndirizzoResidenteFamiglia.class
        EFascia.CANCELLATO_APR | IndirizzoResidenteFamiglia.class
        EFascia.ISCRITTO_AIRE                 | IndirizzoResidenteEsteroFamiglia.class
        EFascia.CANCELLATO_AIRE               | IndirizzoResidenteEsteroFamiglia.class
        EFascia.ISCRIZIONE_ATTESA_O_ANNULLATA | IndirizzoNonResidenteFamiglia.class
        EFascia.NON_RESIDENTE                 | IndirizzoNonResidenteFamiglia.class
    }

    void "AnaFamiglia è scaricabile in base allo stato dei suoi allegati"() {
        given:
        AnaFamiglia famiglia = new AnaFamiglia()
        famiglia.allegati = allegati

        expect:
        famiglia.canDownload() == expected

        where:
        allegati                                                                                         | expected
        [new AnaFamigliaAllegato(idFileEsterno: 1L), new AnaFamigliaAllegato(blobAllegato: new byte[0])] | true
        [new AnaFamigliaAllegato(idFileEsterno: 1L), new AnaFamigliaAllegato()]                          | true
        [new AnaFamigliaAllegato(), new AnaFamigliaAllegato()]                                           | false
        []                                                                                               | false

    }
}
