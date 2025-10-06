package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.IntegrationSpec
import it.finmatica.de4gsdzk.statocivile.CivDatiProvenienzaAtto
import it.finmatica.de4gsdzk.statocivile.CivNascita
import it.finmatica.de4gsdzk.statocivile.CivTipoAttoService
import it.finmatica.de4gsdzk.utils.*
import org.springframework.beans.factory.annotation.Autowired
import spock.lang.Unroll

import java.text.SimpleDateFormat

class AnscCasoUsoServiceNascitaSpec extends IntegrationSpec {

    public static final int TIPO_ATTO_NASCITA_1_A_DENUNCIA_NASCITA_COMUNE = 566
    public static final int TIPO_ATTO_2_B_DENUNCIA_NASCITA_PRESSO_DIREZIONE_SANITARIA = 578
    public static final int TIPO_ATTO_2_B_TRASCRIZIONE_ESTERO_DA_AUTORITA = 563
    public static final int TIPO_ATTO_2_B_TRASCRIZIONE_ESTERO_DA_PRIVATO = 585
    public static final int TIPO_ATTO_2_B_RICONOSCIMENTO_PRE_NATALE = 574
    public static final int TIPO_ATTO_2_B_RICONOSCIMENTO_POST_NASCITA = 531

    public static final Date dataNascitaIQ = DataUtils.substractYears(DataUtils.getDataCorrente(), 1)
    public static final Date dataNascitaSQ = DataUtils.substractYears(DataUtils.getDataCorrente(), 15)
    public static final Date dataNascitaMG = DataUtils.substractYears(DataUtils.getDataCorrente(), 19)

    @Autowired
    private CivTipoAttoService civTipoAttoService

    @Autowired
    private AnscCasoUsoService anscCasoUsoService


    def "11216000 - Dic_Nasc_114"() {
        given: "Un atto di nascita con comparente padre madre e interprete"
        CivNascita nascita = new CivNascita()
        nascita.parte = 1
        nascita.serie = 'A'
        nascita.tipoAttoDomain = civTipoAttoService.get(TIPO_ATTO_NASCITA_1_A_DENUNCIA_NASCITA_COMUNE)
        nascita.tipoFiliazione = ETipoFiliazione.C
        nascita.natoMorto = EStatoNascita.Nato_vivo

        CivDatiProvenienzaAtto datiProvenienza = new CivDatiProvenienzaAtto()
        datiProvenienza.tipoDichiarante = ETipoDichiaranteNascita.MD.name()
        datiProvenienza.tipoComparente = ETipoDichiaranteNascita.PDMDIT.name()

        when: "Viene chiamato il metodo findByAtto"
        def result = anscCasoUsoService.findByAtto(nascita, datiProvenienza)

        then: "Il caso uso restituito dovrebbe essere 11216000"
        result != null
        result.id == 11216000

        and: "Il caso uso restituito dovrebbe essere di tipo AnscCasoUsoNascita"
        result instanceof AnscCasoUsoNascita
    }

    def "11216000 - Dic_Nasc_114"() {
        given: "Un atto di nascita con comparente padre madre"
        CivNascita nascita = new CivNascita()
        nascita.parte = 1
        nascita.serie = 'A'
        nascita.tipoAttoDomain = civTipoAttoService.get(TIPO_ATTO_NASCITA_1_A_DENUNCIA_NASCITA_COMUNE)
        nascita.tipoFiliazione = ETipoFiliazione.C
        nascita.natoMorto = EStatoNascita.Nato_vivo

        CivDatiProvenienzaAtto datiProvenienza = new CivDatiProvenienzaAtto()
        datiProvenienza.tipoDichiarante = ETipoDichiaranteNascita.MD.name()
        datiProvenienza.tipoComparente = ETipoDichiaranteNascita.PDMD.name()

        when: "Viene chiamato il metodo findByAtto"
        def result = anscCasoUsoService.findByAtto(nascita, datiProvenienza)

        then: "Il caso uso restituito dovrebbe essere 11216000"
        result != null
        result.id == 11216000

        and: "Il caso uso restituito dovrebbe essere di tipo AnscCasoUsoNascita"
        result instanceof AnscCasoUsoNascita
    }

    def "11216100 - Dic_Nasc_100"() {
        given: "Un atto di nascita con comparente padre madre e interprete"
        CivNascita nascita = new CivNascita()
        nascita.parte = 1
        nascita.serie = 'A'
        nascita.tipoAttoDomain = civTipoAttoService.get(TIPO_ATTO_NASCITA_1_A_DENUNCIA_NASCITA_COMUNE)
        nascita.tipoFiliazione = ETipoFiliazione.C
        nascita.natoMorto = EStatoNascita.Nato_morto

        CivDatiProvenienzaAtto datiProvenienza = new CivDatiProvenienzaAtto()
        datiProvenienza.tipoDichiarante = ETipoDichiaranteNascita.MD.name()
        datiProvenienza.tipoComparente = ETipoDichiaranteNascita.PDMDIT.name()

        when: "Viene chiamato il metodo findByAtto"
        def result = anscCasoUsoService.findByAtto(nascita, datiProvenienza)

        then: "Il caso uso restituito dovrebbe essere 11216100"
        result != null
        result.id == 11216100

        and: "Il caso uso restituito dovrebbe essere di tipo AnscCasoUsoNascita"
        result instanceof AnscCasoUsoNascita
    }

    def "11216100 - Dic_Nasc_100"() {
        given: "Un atto di nascita con comparente padre madre"
        CivNascita nascita = new CivNascita()
        nascita.parte = 1
        nascita.serie = 'A'
        nascita.tipoAttoDomain = civTipoAttoService.get(TIPO_ATTO_NASCITA_1_A_DENUNCIA_NASCITA_COMUNE)
        nascita.tipoFiliazione = ETipoFiliazione.C
        nascita.natoMorto = EStatoNascita.Nato_morto

        CivDatiProvenienzaAtto datiProvenienza = new CivDatiProvenienzaAtto()
        datiProvenienza.tipoDichiarante = ETipoDichiaranteNascita.MD.name()
        datiProvenienza.tipoComparente = ETipoDichiaranteNascita.PDMD.name()

        when: "Viene chiamato il metodo findByAtto"
        def result = anscCasoUsoService.findByAtto(nascita, datiProvenienza)

        then: "Il caso uso restituito dovrebbe essere 11216100"
        result != null
        result.id == 11216100

        and: "Il caso uso restituito dovrebbe essere di tipo AnscCasoUsoNascita"
        result instanceof AnscCasoUsoNascita
    }

    @Unroll
    def "CU per Parte1 SerieA, Fuori Matrimonio, con il dichiarante #dichiarante, comparente #comparente, tipo consenso #tipoConsenso, tipo riconoscimento prenatale #tipoRiconoscimentoPrenatale ed expected #expected"() {
        given: "Un atto di nascita Fuori Matrimonio"
        CivNascita nascita = new CivNascita()
        nascita.parte = 1
        nascita.serie = 'A'
        nascita.tipoAttoDomain = civTipoAttoService.get(TIPO_ATTO_NASCITA_1_A_DENUNCIA_NASCITA_COMUNE)
        nascita.tipoFiliazione = ETipoFiliazione.C
        nascita.tipoRiconoscimento = tipoRiconoscimentoPrenatale
        nascita.tipoConsenso = tipoConsenso

        CivDatiProvenienzaAtto datiProvenienza = new CivDatiProvenienzaAtto()
        datiProvenienza.tipoDichiarante = dichiarante
        datiProvenienza.tipoComparente = comparente

        expect: "Il caso uso restituito dovrebbe essere #expected"
        def result = anscCasoUsoService.findByAtto(nascita, datiProvenienza)
        result != null
        result.id == expected
        result instanceof AnscCasoUsoNascita

        where:
        dichiarante                       | comparente                          | tipoConsenso     | tipoRiconoscimentoPrenatale       | expected
        ETipoDichiaranteNascita.MD.name() | ETipoDichiaranteNascita.MD.name()   | null             | ETipoRiconoscimentoPrenatale.PD   | 11412010
        ETipoDichiaranteNascita.MD.name() | ETipoDichiaranteNascita.MD.name()   | null             | ETipoRiconoscimentoPrenatale.PDMD | 11412010

        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.PD.name()   | ETipoConsenso.CM | ETipoRiconoscimentoPrenatale.MD   | 11411024
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.PD.name()   | ETipoConsenso.SM | ETipoRiconoscimentoPrenatale.MD   | 11999999
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.PD.name()   | null             | ETipoRiconoscimentoPrenatale.PD   | 11411010
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.PD.name()   | null             | ETipoRiconoscimentoPrenatale.PDMD | 11411010

        ETipoDichiaranteNascita.MD.name() | ETipoDichiaranteNascita.PDMD.name() | null             | ETipoRiconoscimentoPrenatale.MD   | 11416020
        ETipoDichiaranteNascita.MD.name() | ETipoDichiaranteNascita.PDMD.name() | null             | ETipoRiconoscimentoPrenatale.PD   | 11999999
        ETipoDichiaranteNascita.MD.name() | ETipoDichiaranteNascita.PDMD.name() | null             | ETipoRiconoscimentoPrenatale.PDMD | 11999999

        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.PDMD.name() | null             | ETipoRiconoscimentoPrenatale.MD   | 11413020
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.PDMD.name() | null             | ETipoRiconoscimentoPrenatale.PD   | 11999999
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.PDMD.name() | null             | ETipoRiconoscimentoPrenatale.PDMD | 11999999
    }

    @Unroll
    def "CU per Centro Nascita con tipo filiazione #tipoFiliazione, tipo riconoscimento prenatale #tipoRiconoscimentoPrenatale ed expected #expected"() {
        given: "Un atto di nascita con categoria Centro Nascita"
        CivNascita nascita = new CivNascita()
        nascita.parte = 2
        nascita.serie = 'B'
        nascita.tipoAttoDomain = civTipoAttoService.get(TIPO_ATTO_2_B_DENUNCIA_NASCITA_PRESSO_DIREZIONE_SANITARIA)
        nascita.tipoFiliazione = tipoFiliazione
        nascita.tipoRiconoscimento = tipoRiconoscimentoPrenatale

        CivDatiProvenienzaAtto datiProvenienza = new CivDatiProvenienzaAtto()

        expect: "Il caso uso restituito dovrebbe essere #expected"
        def result = anscCasoUsoService.findByAtto(nascita, datiProvenienza)
        result != null
        result.id == expected
        result instanceof AnscCasoUsoNascita

        where:
        tipoFiliazione    | tipoRiconoscimentoPrenatale       | expected
        null              | null                              | 1314

        ETipoFiliazione.L | null                              | 1314

        ETipoFiliazione.C | ETipoRiconoscimentoPrenatale.MD   | 1314
        ETipoFiliazione.C | ETipoRiconoscimentoPrenatale.PD   | 1314
        ETipoFiliazione.C | ETipoRiconoscimentoPrenatale.PDMD | 1314
    }

    @Unroll
    def "CU per Trascrizione Estero da Privato - Dichiarazione Giudiziale #dichiarazioneGiudiziale - expected #expected"() {
        given: "Un atto di nascita con categoria TEP - Trascrizione Estero da Privato"
        CivNascita nascita = new CivNascita()
        nascita.parte = 2
        nascita.serie = 'B'
        nascita.tipoAttoDomain = civTipoAttoService.get(TIPO_ATTO_2_B_TRASCRIZIONE_ESTERO_DA_PRIVATO)

        CivDatiProvenienzaAtto datiProvenienza = new CivDatiProvenienzaAtto()
        datiProvenienza.dichiarazioneGiudiziale = dichiarazioneGiudiziale

        expect: "Il caso uso restituito dovrebbe essere #expected"
        def result = anscCasoUsoService.findByAtto(nascita, datiProvenienza)
        result != null
        result.id == expected
        result instanceof AnscCasoUsoNascita

        where:
        dichiarazioneGiudiziale | expected
        ETipoSiNo.NO            | 1312
        // Il cu 1322 è da implementare.
        // Lo rilascio su ANSCU2 come non visibile.
        // Per la dichiarazione giudiziale SI,
        // verifico di ottenere il cu di servizio 1399
        // ETipoSiNo.SI            | 1322
        ETipoSiNo.SI            | 1399
    }

    @Unroll
    def "CU per Trascrizione Estero da Autorita - Dichiarazione Giudiziale #dichiarazioneGiudiziale - flagInViaggio #flagInViaggio - expected #expected"() {
        given: "Un atto di nascita con categoria TEA - Trascrizione Estero da Autorita"
        CivNascita nascita = new CivNascita()
        nascita.parte = 2
        nascita.serie = 'B'
        nascita.tipoAttoDomain = civTipoAttoService.get(TIPO_ATTO_2_B_TRASCRIZIONE_ESTERO_DA_AUTORITA)

        CivDatiProvenienzaAtto datiProvenienza = new CivDatiProvenienzaAtto()
        datiProvenienza.dichiarazioneGiudiziale = dichiarazioneGiudiziale
        datiProvenienza.flagInViaggio = flagInViaggio

        expect: "Il caso uso restituito dovrebbe essere #expected"
        def result = anscCasoUsoService.findByAtto(nascita, datiProvenienza)
        result != null
        result.id == expected
        result instanceof AnscCasoUsoNascita

        where:
        dichiarazioneGiudiziale | flagInViaggio | expected
        ETipoSiNo.NO            | false         | 1311
        // Il cu 1323 è da implementare.
        // Lo rilascio su ANSCU2 come non visibile.
        // Per la dichiarazione giudiziale SI,
        // verifico di ottenere il cu di servizio 1399
        // ETipoSiNo.SI            | 1323
        ETipoSiNo.SI            | false         | 1399
        ETipoSiNo.NO            | null          | 1311
        ETipoSiNo.SI            | null          | 1399
        ETipoSiNo.NO            | true          | 1313
        ETipoSiNo.SI            | true          | 1313
    }

    @Unroll
    def "CU per Riconoscimento Pre-Natale (RPN) - tipoDichiarante #tipoDichiarante, tipoComparente #tipoComparente - expected #expected"() {
        given: "Un atto di nascita con categoria RPN"
        CivNascita nascita = new CivNascita()
        nascita.parte = 2
        nascita.serie = 'B'
        nascita.tipoAttoDomain = civTipoAttoService.get(TIPO_ATTO_2_B_RICONOSCIMENTO_PRE_NATALE)

        CivDatiProvenienzaAtto datiProvenienza = new CivDatiProvenienzaAtto()
        datiProvenienza.tipoDichiarante = tipoDichiarante
        datiProvenienza.tipoComparente = tipoComparente

        expect: "Il caso uso restituito dovrebbe essere #expected"
        def result = anscCasoUsoService.findByAtto(nascita, datiProvenienza)
        result != null
        result.id == expected
        result instanceof AnscCasoUsoNascita

        where:
        tipoDichiarante                   | tipoComparente                    | expected
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.PD.name() | 12211312
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.EN.name() | 12214300
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.AL.name() | 12999999
        ETipoDichiaranteNascita.MD.name() | ETipoDichiaranteNascita.MD.name() | 12212300
        ETipoDichiaranteNascita.MD.name() | ETipoDichiaranteNascita.EN.name() | 12216300
        ETipoDichiaranteNascita.MD.name() | ETipoDichiaranteNascita.AL.name() | 12999999
    }

    @Unroll
    def "CU per Riconoscimento Post-Nascita (RIC) - tipoDichiarante #tipoDichiarante, tipoComparente #tipoComparente, dataNascita #dataNascita, flagFiglioDiIgnoti #flagFiglioDiIgnoti - expected #expected"() {
        given: "Un atto di nascita con categoria RIC"
        CivNascita nascita = new CivNascita()
        nascita.parte = 2
        nascita.serie = 'B'
        nascita.tipoAttoDomain = civTipoAttoService.get(TIPO_ATTO_2_B_RICONOSCIMENTO_POST_NASCITA)
        nascita.dataNascita = dataNascita
        nascita.flagFiglioDiIgnoti = flagFiglioDiIgnoti

        CivDatiProvenienzaAtto datiProvenienza = new CivDatiProvenienzaAtto()
        datiProvenienza.dataAtto = DataUtils.fromStringToDate("01/01/2025")
        datiProvenienza.tipoDichiarante = tipoDichiarante
        datiProvenienza.tipoComparente = tipoComparente


        expect: "Il caso uso restituito dovrebbe essere #expected"
        def result = anscCasoUsoService.findByAtto(nascita, datiProvenienza)
        result != null
        result.id == expected
        result instanceof AnscCasoUsoNascita

        //Altrenanza null e false per vedere se funziona in entrambi i casi
        where:
        tipoDichiarante                   | tipoComparente                    | dataNascita   | flagFiglioDiIgnoti | expected // fasciaEtaFiglio
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.PD.name() | dataNascitaIQ | false              | 12221212 // ETipoFasciaEta.IQ
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.PD.name() | dataNascitaSQ | null               | 12221122 // ETipoFasciaEta.SQ
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.PD.name() | dataNascitaMG | false              | 12221422 // ETipoFasciaEta.MG
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.EN.name() | dataNascitaIQ | null               | 12221212 // ETipoFasciaEta.IQ
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.EN.name() | dataNascitaSQ | false              | 12221122 // ETipoFasciaEta.SQ
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.EN.name() | dataNascitaMG | false              | 12221422 // ETipoFasciaEta.MG
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.AL.name() | dataNascitaIQ | false              | 12999999 // ETipoFasciaEta.IQ
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.AL.name() | dataNascitaSQ | null               | 12999999 // ETipoFasciaEta.SQ
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.AL.name() | dataNascitaMG | null               | 12999999 // ETipoFasciaEta.MG
        ETipoDichiaranteNascita.MD.name() | ETipoDichiaranteNascita.MD.name() | dataNascitaIQ | null               | 12222231 // ETipoFasciaEta.IQ
        ETipoDichiaranteNascita.MD.name() | ETipoDichiaranteNascita.MD.name() | dataNascitaSQ | false              | 12222121 // ETipoFasciaEta.SQ
        ETipoDichiaranteNascita.MD.name() | ETipoDichiaranteNascita.EN.name() | dataNascitaIQ | false              | 12222231 // ETipoFasciaEta.IQ
        ETipoDichiaranteNascita.MD.name() | ETipoDichiaranteNascita.EN.name() | dataNascitaSQ | false              | 12222121 // ETipoFasciaEta.SQ
        ETipoDichiaranteNascita.MD.name() | ETipoDichiaranteNascita.AL.name() | dataNascitaIQ | null               | 12999999 // ETipoFasciaEta.IQ
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.EN.name() | dataNascitaSQ | true               | 12224123 // ETipoFasciaEta.SQ
        ETipoDichiaranteNascita.MD.name() | ETipoDichiaranteNascita.EN.name() | dataNascitaSQ | true               | 12226123 // ETipoFasciaEta.SQ
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.PD.name() | dataNascitaSQ | true               | 12221123 // ETipoFasciaEta.SQ
        ETipoDichiaranteNascita.MD.name() | ETipoDichiaranteNascita.MD.name() | dataNascitaSQ | true               | 12222123 // ETipoFasciaEta.SQ
        ETipoDichiaranteNascita.PD.name() | ETipoDichiaranteNascita.PD.name() | dataNascitaIQ | true               | 12221203 // ETipoFasciaEta.IQ
        ETipoDichiaranteNascita.MD.name() | ETipoDichiaranteNascita.MD.name() | dataNascitaIQ | true               | 12222203 // ETipoFasciaEta.IQ

    }
}
