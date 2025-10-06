package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.IntegrationSpec
import it.finmatica.de4gsdzk.statocivile.CivDatiProvenienzaAtto
import it.finmatica.de4gsdzk.statocivile.CivMatrimonio
import it.finmatica.de4gsdzk.statocivile.CivNascita
import it.finmatica.de4gsdzk.statocivile.CivTipoAttoService
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import org.springframework.beans.factory.annotation.Autowired
import spock.lang.Unroll

class AnscCasoUsoServiceMatrimonioTest extends IntegrationSpec {

    public static final int TIPO_ATTO_DIVORZIO_2_C_DIVORZIO_TRIBUNALE_ESTERO = 549
    public static final int TIPO_ATTO_2_B_TRASCRIZIONE_ESTERO_DA_AUTORITA = 565

    @Autowired
    private CivTipoAttoService civTipoAttoService

    @Autowired
    private AnscCasoUsoService anscCasoUsoService

    @Unroll
    def "CU per Divorzio Estero"() {
        given: "Un atto di matrimonio con categoria Divorzio Estero"
        CivMatrimonio matrimonio = new CivMatrimonio()
        matrimonio.parte = 2
        matrimonio.serie = 'C'
        matrimonio.tipoAttoDomain = civTipoAttoService.get(TIPO_ATTO_DIVORZIO_2_C_DIVORZIO_TRIBUNALE_ESTERO)
        matrimonio.divorzio = true

        CivDatiProvenienzaAtto datiProvenienza = new CivDatiProvenienzaAtto()

        expect: "Il caso uso restituito dovrebbe essere 347000"
        def result = anscCasoUsoService.findByAtto(matrimonio, datiProvenienza)
        result != null
        result.id == 347000
        result instanceof AnscCasoUsoMatrimonio
    }


    @Unroll
    def "CU per Trascrizione Estero da Autorita -  flagInViaggio #flagInViaggio - expected #expected"() {
        given: "Un atto di nascita con categoria TEA - Trascrizione Estero da Autorita"
        CivMatrimonio matrimonio = new CivMatrimonio()
        matrimonio.parte = 2
        matrimonio.serie = 'C'
        matrimonio.tipoAttoDomain = civTipoAttoService.get(TIPO_ATTO_2_B_TRASCRIZIONE_ESTERO_DA_AUTORITA)

        CivDatiProvenienzaAtto datiProvenienza = new CivDatiProvenienzaAtto()
        datiProvenienza.flagInViaggio = flagInViaggio

        expect: "Il caso uso restituito dovrebbe essere #expected"
        def result = anscCasoUsoService.findByAtto(matrimonio, datiProvenienza)
        result != null
        result.id == expected
        result instanceof AnscCasoUsoMatrimonio

        where:
        flagInViaggio | expected
        false         | 332000
        null          | 332000
        true          | 335003

    }
}
