package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.errors.ValidazioneEstremiAttoEmptyRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivTipoAtto
import spock.lang.Specification
import spock.lang.Unroll

class ValidationUtilsSpec extends Specification {
    @Unroll
    def "Gli estremi atto solo analogici o solo digitali devono essere validi"() {
        given:
        EstremiAtto estremiAtto = new EstremiAtto(ufficio: null, anno: annoAtto, atto: numeroAtto, parte: parteAtto, serie: serieAtto, idAttoAnsc: idAttoAnsc)
        DatiValidazioneEstremi eac = new DatiValidazioneEstremi(tipoAtto,
                estremiAtto,
                false,
                false)

        when:
        ValidationUtils.validaEstremiAtto(eac, "Sezione")

        then:
        noExceptionThrown()

        where:
        tipoAtto      | numeroAtto | annoAtto | parteAtto | serieAtto | idAttoAnsc
        ETipoAtto.NAS | 1          | 2000     | 1         | "A"       | null
        ETipoAtto.NAS | null       | null     | null      | null      | "123456789"
        ETipoAtto.NAS | null | null | null | null | null
    }

    @Unroll
    def "Gli estremi atto assenti, per obbligatorietà #mandatory, devono generare eccezione #expectedException"() {
        given:
        EstremiAtto estremiAtto = new EstremiAtto(ufficio: null, anno: annoAtto, atto: numeroAtto, parte: parteAtto, serie: serieAtto, idAttoAnsc: idAttoAnsc)
        DatiValidazioneEstremi eac = new DatiValidazioneEstremi(tipoAtto,
                estremiAtto,
                mandatory,
                false)

        when:
        ValidationUtils.validaEstremiAtto(eac, "Sezione")

        then:
        thrown(expectedException)

        where:
        mandatory | tipoAtto      | numeroAtto | annoAtto | parteAtto | serieAtto | idAttoAnsc | expectedException
        true      | ETipoAtto.NAS | null       | null     | null      | null      | null       | CampoMandatoryRuntimeException

    }

    @Unroll
    def "Gli estremi atto analogici con ufficio, quando ufficio obbligatorio, devono essere validi"() {
        given:
        EstremiAtto estremiAtto = new EstremiAtto(ufficio: ufficioAtto, anno: annoAtto, atto: numeroAtto, parte: parteAtto, serie: serieAtto, idAttoAnsc: null)
        DatiValidazioneEstremi eac = new DatiValidazioneEstremi(tipoAtto,
                estremiAtto,
                false,
                true)

        when:
        ValidationUtils.validaEstremiAtto(eac, "Sezione")

        then:
        noExceptionThrown()

        where:
        tipoAtto      | numeroAtto | annoAtto | parteAtto | serieAtto           | ufficioAtto
        ETipoAtto.NAS | 1          | 2000     | 1         | CivTipoAtto.SERIE_A | 1
    }

    @Unroll
    def "Gli estremi atto analogici senza ufficio, quando ufficio obbligatorio, devono essere non validi"() {
        given:
        EstremiAtto estremiAtto = new EstremiAtto(ufficio: ufficioAtto, anno: annoAtto, atto: numeroAtto, parte: parteAtto, serie: serieAtto, idAttoAnsc: null)
        DatiValidazioneEstremi eac = new DatiValidazioneEstremi(tipoAtto,
                estremiAtto,
                false,
                true)

        when:
        ValidationUtils.validaEstremiAtto(eac, "Sezione")

        then:
        thrown(CampoMandatoryRuntimeException)

        where:
        tipoAtto      | numeroAtto | annoAtto | parteAtto | serieAtto           | ufficioAtto
        ETipoAtto.NAS | 1          | 2000     | 1         | CivTipoAtto.SERIE_A | null
    }

    @Unroll
    def "Gli estremi atto sia analogici che digitali devono essere non validi"() {
        given:
        EstremiAtto estremiAtto = new EstremiAtto(ufficio: null, anno: annoAtto, atto: numeroAtto, parte: parteAtto, serie: serieAtto, idAttoAnsc: idAttoAnsc)
        DatiValidazioneEstremi eac = new DatiValidazioneEstremi(tipoAtto,
                estremiAtto,
                false,
                false)

        when:
        ValidationUtils.validaEstremiAtto(eac, "Sezione")

        then:
        thrown(De4gsdzkRuntimeException)

        where:
        tipoAtto      | numeroAtto | annoAtto | parteAtto | serieAtto | idAttoAnsc
        ETipoAtto.NAS | 1          | 2000     | 1         | "A"       | "123456789"
    }

    @Unroll
    def "Gli estremi atto analogici composti da (tipoAtto #tipoAtto, numeroAtto #numeroAtto, annoAtto #annoAtto, parteAtto #parteAtto, serieAtto #serieAtto) devono essere validi"() {
        given:
        EstremiAtto estremiAtto = new EstremiAtto(ufficio: null, anno: annoAtto, atto: numeroAtto, parte: parteAtto, serie: serieAtto, idAttoAnsc: null)
        DatiValidazioneEstremi eac = new DatiValidazioneEstremi(tipoAtto,
                estremiAtto,
                false,
                false)

        when:
        ValidationUtils.validaEstremiAtto(eac, "Sezione")

        then:
        noExceptionThrown()

        where:
        tipoAtto      | numeroAtto | annoAtto | parteAtto | serieAtto
        ETipoAtto.NAS | 1          | 2000     | 1         | CivTipoAtto.SERIE_A
//        Esistono Nascite senza serie (molto vecchie)
        ETipoAtto.NAS | 1          | 2000     | 1         | null

        ETipoAtto.MAT | 1          | 2000     | 1         | CivTipoAtto.SERIE_A
//        Esistono Matrimoni senza serie (molto vecchi)
        ETipoAtto.MAT | 1          | 2000     | 1         | null

        ETipoAtto.MOR | 1          | 2000     | 1         | CivTipoAtto.SERIE_A
//        Esistono Morti senza serie (molto vecchi)
        ETipoAtto.MOR | 1          | 2000     | 1         | null

        ETipoAtto.UCI | 1          | 2000     | null      | null

        ETipoAtto.CIT | 1          | 2000     | null      | null
    }

    @Unroll
    def "Gli estremi atto analogici composti da (tipoAtto #tipoAtto, numeroAtto #numeroAtto, annoAtto #annoAtto, parteAtto #parteAtto, serieAtto #serieAtto) devono essere invalidi"() {
        given:
        EstremiAtto estremiAtto = new EstremiAtto(ufficio: null, anno: annoAtto, atto: numeroAtto, parte: parteAtto, serie: serieAtto, idAttoAnsc: null)
        DatiValidazioneEstremi eac = new DatiValidazioneEstremi(tipoAtto,
                estremiAtto,
                false,
                false)

        when:
        ValidationUtils.validaEstremiAtto(eac, "Sezione")

        then:
        thrown(expectedException)

        where:
        tipoAtto      | numeroAtto | annoAtto | parteAtto | serieAtto           | expectedException
        ETipoAtto.NAS | null       | 2000     | 1         | CivTipoAtto.SERIE_A | CampoMandatoryRuntimeException
        ETipoAtto.NAS | 1          | null     | 1         | CivTipoAtto.SERIE_A | CampoMandatoryRuntimeException
        ETipoAtto.NAS | 1          | 2000     | null      | CivTipoAtto.SERIE_A | CampoMandatoryRuntimeException
//        Esistono Nascite senza serie (molto vecchie)
//        ETipoAtto.NAS | 1          | 2000     | 1         | null | CampoMandatoryRuntimeException

        ETipoAtto.MAT | null       | 2000     | 1         | CivTipoAtto.SERIE_A | CampoMandatoryRuntimeException
        ETipoAtto.MAT | 1          | null     | 1         | CivTipoAtto.SERIE_A | CampoMandatoryRuntimeException
        ETipoAtto.MAT | 1          | 2000     | null      | CivTipoAtto.SERIE_A | CampoMandatoryRuntimeException
//        Esistono Matrimoni senza serie (molto vecchi)
//        ETipoAtto.MAT | 1          | 2000     | 1         | null | CampoMandatoryRuntimeException

        ETipoAtto.MOR | null       | 2000     | 1         | CivTipoAtto.SERIE_A | CampoMandatoryRuntimeException
        ETipoAtto.MOR | 1          | null     | 1         | CivTipoAtto.SERIE_A | CampoMandatoryRuntimeException
        ETipoAtto.MOR | 1          | 2000     | null      | CivTipoAtto.SERIE_A | CampoMandatoryRuntimeException
//        Esistono Morti senza serie (molto vecchi)
//        ETipoAtto.MOR | 1          | 2000     | 1         | null | CampoMandatoryRuntimeException

        ETipoAtto.UCI | null       | 2000     | null      | null                | CampoMandatoryRuntimeException
        ETipoAtto.UCI | 1          | null     | null      | null                | CampoMandatoryRuntimeException

        ETipoAtto.CIT | null       | 2000     | null      | null                | CampoMandatoryRuntimeException
        ETipoAtto.CIT | 1          | null     | null      | null                | CampoMandatoryRuntimeException
    }

    @Unroll
    def "I dati di validazione annotazione, per obbligatorietà #mandatory, devono generare eccezione #expectedException"() {
        given:
        EstremiAtto estremiAtto = new EstremiAtto(ufficio: null, anno: annoAtto, atto: numeroAtto, parte: parteAtto, serie: serieAtto, idAttoAnsc: idAttoAnsc)
        DatiValidazioneEstremi eac = new DatiValidazioneEstremi(tipoAtto,
                estremiAtto,
                mandatory,
                false)
        DatiValidazioneComune dvc = new DatiValidazioneComune(null, null, false)
        DatiValidazioneDataAtto dvat = new DatiValidazioneDataAtto(null, false)
        DatiValidazioneAnnotazione dva = new DatiValidazioneAnnotazione(eac,
                dvc,
                dvat,
                null,
                mandatory,
                false)

        when:
        ValidationUtils.validaDatiAnnotazione(dva, "Sezione")

        then:
        thrown(expectedException)

        where:
        mandatory | tipoAtto      | numeroAtto | annoAtto | parteAtto | serieAtto | idAttoAnsc | expectedException
        false     | ETipoAtto.NAS | null       | null     | null      | null      | null       | ValidazioneEstremiAttoEmptyRuntimeException

    }
}
