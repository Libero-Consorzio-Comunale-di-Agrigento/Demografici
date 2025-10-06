package it.finmatica.de4gsdzk.anagrafe


import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.anagrafe.IndirizzoNonResidenteAnagrafe
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.anagrafe.IndirizzoResidenteAnagrafe
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.anagrafe.IndirizzoResidenteEsteroAnagrafe
import it.finmatica.de4gsdzk.utils.IIndirizzoAnagrafe
import spock.lang.Specification
import spock.lang.Unroll

import java.lang.reflect.Field

class AnaAnagrafeSpec extends Specification {

    @Unroll
    void "AnaAnagrafe restituisce un indirizzo coerente alla fascia"() {
        given:
        AnaAnagrafe anagrafe = new AnaAnagrafe(fascia: fascia)

        setPrivateField(anagrafe, "indirizzoResidente", new IndirizzoResidenteAnagrafe())
        setPrivateField(anagrafe, "indirizzoResidenteEstero", new IndirizzoResidenteEsteroAnagrafe())
        setPrivateField(anagrafe, "indirizzoNonResidente", new IndirizzoNonResidenteAnagrafe())

        expect:
        anagrafe.indirizzo instanceof IIndirizzoAnagrafe
        indirizzo.name == anagrafe.indirizzo?.class?.name

        where:
        fascia                                | indirizzo
        EFascia.ISCRITTO_APR                  | IndirizzoResidenteAnagrafe.class
        EFascia.CANCELLATO_APR                | IndirizzoResidenteAnagrafe.class
        EFascia.ISCRITTO_AIRE                 | IndirizzoResidenteEsteroAnagrafe.class
        EFascia.CANCELLATO_AIRE               | IndirizzoResidenteEsteroAnagrafe.class
        EFascia.ISCRIZIONE_ATTESA_O_ANNULLATA | IndirizzoNonResidenteAnagrafe.class
        EFascia.NON_RESIDENTE                 | IndirizzoNonResidenteAnagrafe.class
    }

    /**
     * Utility method to set private fields using reflection
     */
    private void setPrivateField(Object target, String fieldName, Object value) {
    Class<?> clazz = target.getClass()
    while (clazz != null) { // Traverse class hierarchy
        try {
            Field field = clazz.getDeclaredField(fieldName)
            field.setAccessible(true)
            field.set(target, value)
            return
        } catch (NoSuchFieldException e) {
            clazz = clazz.getSuperclass() // Move to superclass
        }
    }
    throw new NoSuchFieldException("Field '${fieldName}' not found in class hierarchy")
    }

    void "AnaAnagrafe è scaricabile in base allo stato dei suoi allegati"() {
        given:
        AnaAnagrafe anagrafe = new AnaAnagrafe()
        anagrafe.allegati = allegati

        expect:
        anagrafe.canDownload() == expected

        where:
        allegati                                                                                         | expected
        [new AnaAnagrafeAllegato(idFileEsterno: 1L), new AnaAnagrafeAllegato(blobAllegato: new byte[0])] | true
        [new AnaAnagrafeAllegato(idFileEsterno: 1L), new AnaAnagrafeAllegato()]                          | true
        [new AnaAnagrafeAllegato(), new AnaAnagrafeAllegato()]                                           | false
        []                                                                                               | false

    }
}
