package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdValidazioneTestoService
import it.finmatica.de4gsdzk.IEstremiAttoNascitaSoggetto1Domain
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreAssenzaTipoSalvataggioAnnotazioneComuneClienteSuAttoNascita1RuntimeException
import it.finmatica.de4gsdzk.errors.ErroreDatiAnnotazioneRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.ETipoSalvataggioAnnotazioneComuneCliente
import spock.lang.Specification
import spock.lang.Unroll

class CivAnnotazioneAttoServiceSuNascita1Spec extends Specification {
    private static IEstremiAttoNascitaSoggetto1Domain ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO = new CivMargine(ufficioAttoNascita1: 1, annoAttoNascita1: 2020, attoAttoNascita1: 100, parteAttoNascitaString: 1, serieAttoNascita1: "A", codiceComuneAttoNascita1: 111, codiceProvinciaAttoNascita1: 22)
    private static IEstremiAttoNascitaSoggetto1Domain ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO = new CivMargine(idAttoAnscNascita1: "123456789", codiceComuneAttoNascita1: 111, codiceProvinciaAttoNascita1: 22)

    ArcParametroService arcParametroService = Mock(ArcParametroService)
    ArcComuneBaseService arcComuneBaseService = Mock(ArcComuneBaseService)
    CivFormulaAnnotazioneService civFormulaAnnotazioneService = Mock(CivFormulaAnnotazioneService)
    CivNascitaRepository civNascitaRepository = Mock(CivNascitaRepository)
    CivNascitaService civNascitaService = Mock(CivNascitaService)

    CivAnnotazioneAttoService civAnnotazioneAttoService

    void setup() {
        CivAnnotazioneAttoRepository civAnnotazioneAttoRepository = Mock(CivAnnotazioneAttoRepository)
        StatoCivileService statoCivileService = Mock(StatoCivileService)
        CivAnagrafeService civAnagrafeService = Mock(CivAnagrafeService)
        GsdValidazioneTestoService gsdValidazioneTestoService = Mock(GsdValidazioneTestoService)
        CivArchivioComunicazioneService civArchivioComunicazioneService = Mock(CivArchivioComunicazioneService)
        CivComunicazioneFormulaService civComunicazioneFormulaService = Mock(CivComunicazioneFormulaService)
        CivMatrimonioRepository civMatrimonioRepository = Mock(CivMatrimonioRepository)
        CivUnioneCivileRepository civUnioneCivileRepository = Mock(CivUnioneCivileRepository)
        CivComunicazioneAllegatoService civComunicazioneAllegatoService = Mock(CivComunicazioneAllegatoService)

        civAnnotazioneAttoService = Spy(CivAnnotazioneAttoService, constructorArgs: [arcParametroService,
                                                                                     civAnnotazioneAttoRepository,
                                                                                     statoCivileService,
                                                                                     civAnagrafeService,
                                                                                     gsdValidazioneTestoService,
                                                                                     civArchivioComunicazioneService,
                                                                                     civFormulaAnnotazioneService,
                                                                                     civComunicazioneFormulaService,
                                                                                     civNascitaRepository,
                                                                                     civMatrimonioRepository,
                                                                                     civUnioneCivileRepository,
                                                                                     arcComuneBaseService,
                                                                                     civComunicazioneAllegatoService,
                                                                                     civNascitaService]) as CivAnnotazioneAttoService
    }

    @Unroll
    def "Valida Dati Atto Nascita Soggetto 1 per gestione nuova annotazione #nuovaGestioneAnnotazioneSuAttoAttiva, attoSecondario #attoSecondario, ufficioObbligatory #ufficioObbligatory, si aspetta result #expectedResult"() {
        given:
        IEstremiAttoNascitaSoggetto1Domain estremiAttoPrimario = new CivMargine(ufficioAttoNascita1: ufficioPrimario,
                annoAttoNascita1: annoPrimario,
                attoAttoNascita1: attoPrimario,
                parteAttoNascitaString: partePrimario,
                serieAttoNascita1: seriePrimario,
                codiceComuneAttoNascita1: codiceComunePrimario,
                codiceProvinciaAttoNascita1: codiceProvinciaPrimario)
        arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva() >> nuovaGestioneAnnotazioneSuAttoAttiva
        arcComuneBaseService.isComuneClienteAnnotazione(codiceComunePrimario, codiceProvinciaPrimario) >> ufficioObbligatory

        when:
        Boolean result = civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto1(attoSecondario, estremiAttoPrimario, formula)

        then:
        result == expectedResult

        where:
        nuovaGestioneAnnotazioneSuAttoAttiva | attoSecondario        | ufficioObbligatory | ufficioPrimario | annoPrimario | attoPrimario | partePrimario | seriePrimario | codiceComunePrimario | codiceProvinciaPrimario | formula   || expectedResult
        false                                | new CivNascita()      | false              | null            | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true
        false                                | new CivNascita()      | false              | null            | null         | null         | null          | null          | null                 | null                    | null      || false
        false                                | new CivNascita()      | true               | 1               | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true

        false                                | new CivCittadinanza() | false              | null            | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true
        false                                | new CivCittadinanza() | false              | null            | null         | null         | null          | null          | null                 | null                    | null      || false
        false                                | new CivCittadinanza() | true               | 1               | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true

        false                                | new CivMatrimonio()   | false              | null            | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true
        false                                | new CivMatrimonio()   | false              | null            | null         | null         | null          | null          | null                 | null                    | null      || false
        false                                | new CivMatrimonio()   | true               | 1               | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true

        false                                | new CivUnioneCivile() | false              | null            | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true
        false                                | new CivUnioneCivile() | false              | null            | null         | null         | null          | null          | null                 | null                    | null      || false
        false                                | new CivUnioneCivile() | true               | 1               | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true

        false                                | new CivMorte()        | false              | null            | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true
        false                                | new CivMorte()        | false              | null            | null         | null         | null          | null          | null                 | null                    | null      || false
        false                                | new CivMorte()        | true               | 1               | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true

        true                                 | new CivNascita()      | false              | null            | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true
        true                                 | new CivNascita()      | false              | null            | null         | null         | null          | null          | null                 | null                    | null      || false
        true                                 | new CivNascita()      | true               | 1               | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true

        true                                 | new CivCittadinanza() | false              | null            | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true
        true                                 | new CivCittadinanza() | false              | null            | null         | null         | null          | null          | null                 | null                    | null      || false
        true                                 | new CivCittadinanza() | true               | 1               | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true

        true                                 | new CivMatrimonio()   | false              | null            | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true
        true                                 | new CivMatrimonio()   | false              | null            | null         | null         | null          | null          | null                 | null                    | null      || false
        true                                 | new CivMatrimonio()   | true               | 1               | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true

        true                                 | new CivUnioneCivile() | false              | null            | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true
        true                                 | new CivUnioneCivile() | false              | null            | null         | null         | null          | null          | null                 | null                    | null      || false
        true                                 | new CivUnioneCivile() | true               | 1               | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true

        true                                 | new CivMorte()        | false              | null            | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true
        true                                 | new CivMorte()        | false              | null            | null         | null         | null          | null          | null                 | null                    | null      || false
        true                                 | new CivMorte()        | true               | 1               | 2021         | 123          | 1             | "A"           | 100                  | 20                      | "FORMULA" || true
    }

    @Unroll
    def "Valida Dati Atto Nascita Soggetto 1 per gestione nuova annotazione #nuovaGestioneAnnotazioneSuAttoAttiva si aspetta CampoMandatoryRuntimeException per attoSecondario #attoSecondario"() {
        given:
        IEstremiAttoNascitaSoggetto1Domain estremiAttoPrimario = new CivMargine(ufficioAttoNascita1: ufficioPrimario,
                annoAttoNascita1: annoPrimario,
                attoAttoNascita1: attoPrimario,
                parteAttoNascitaString: partePrimario,
                serieAttoNascita1: seriePrimario,
                codiceComuneAttoNascita1: codiceComunePrimario,
                codiceProvinciaAttoNascita1: codiceProvinciaPrimario)
        arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva() >> nuovaGestioneAnnotazioneSuAttoAttiva
        arcComuneBaseService.isComuneClienteAnnotazione(codiceComunePrimario, codiceProvinciaPrimario) >> ufficioObbligatory

        when:
        civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto1(attoSecondario, estremiAttoPrimario, formula)

        then:
        thrown(exception)

        where:
        nuovaGestioneAnnotazioneSuAttoAttiva | attoSecondario        | ufficioObbligatory | ufficioPrimario | annoPrimario | attoPrimario | partePrimario | seriePrimario | codiceComunePrimario | codiceProvinciaPrimario | formula   || exception
        false                                | new CivNascita()      | false              | null            | null         | 123          | 1             | null          | 100                  | 20                      | "FORMULA" || De4gsdzkRuntimeException
        false                                | new CivNascita()      | false              | null            | 2021         | null         | 1             | null          | 100                  | 20                      | "FORMULA" || De4gsdzkRuntimeException
        false                                | new CivNascita()      | false              | null            | 2021         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || De4gsdzkRuntimeException
        false                                | new CivNascita()      | false              | null            | 2021         | 123          | 1             | null          | null                 | 20                      | "FORMULA" || De4gsdzkRuntimeException
        false                                | new CivNascita()      | false              | null            | 2021         | 123          | 1             | null          | 100                  | null                    | "FORMULA" || De4gsdzkRuntimeException
        false                                | new CivNascita()      | false              | null            | 2021         | 123          | 1             | null          | 100                  | 20                      | null      || De4gsdzkRuntimeException
        false                                | new CivNascita()      | true               | null            | 2021         | 123          | 1             | null          | 100                  | 20                      | "FORMULA" || De4gsdzkRuntimeException

        false                                | new CivCittadinanza() | false              | null            | null         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivCittadinanza() | false              | null            | 2021         | null         | null          | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivCittadinanza() | false              | null            | 2021         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivCittadinanza() | false              | null            | 2021         | 123          | null          | null          | null                 | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivCittadinanza() | false              | null            | 2021         | 123          | null          | null          | 100                  | null                    | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivCittadinanza() | false              | null            | 2021         | 123          | null          | null          | 100                  | 20                      | null      || CampoMandatoryRuntimeException
        false                                | new CivCittadinanza() | true               | null            | 2021         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException

        false                                | new CivMatrimonio()   | false              | null            | null         | 123          | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivMatrimonio()   | false              | null            | 2021         | null         | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivMatrimonio()   | false              | null            | 2021         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivMatrimonio()   | false              | null            | 2021         | 123          | 1             | null          | null                 | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivMatrimonio()   | false              | null            | 2021         | 123          | 1             | null          | 100                  | null                    | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivMatrimonio()   | false              | null            | 2021         | 123          | 1             | null          | 100                  | 20                      | null      || CampoMandatoryRuntimeException
        false                                | new CivMatrimonio()   | true               | null            | 2021         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException


        false                                | new CivUnioneCivile() | false              | null            | null         | 123          | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivUnioneCivile() | false              | null            | 2021         | null         | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivUnioneCivile() | false              | null            | 2021         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivUnioneCivile() | false              | null            | 2021         | 123          | 1             | null          | null                 | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivUnioneCivile() | false              | null            | 2021         | 123          | 1             | null          | 100                  | null                    | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivUnioneCivile() | false              | null            | 2021         | 123          | 1             | null          | 100                  | 20                      | null      || CampoMandatoryRuntimeException
        false                                | new CivUnioneCivile() | true               | null            | 2021         | 123          | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException

        false                                | new CivMorte()        | false              | null            | null         | 123          | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivMorte()        | false              | null            | 2021         | null         | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivMorte()        | false              | null            | 2021         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivMorte()        | false              | null            | 2021         | 123          | 1             | null          | null                 | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivMorte()        | false              | null            | 2021         | 123          | 1             | null          | 100                  | null                    | "FORMULA" || CampoMandatoryRuntimeException
        false                                | new CivMorte()        | false              | null            | 2021         | 123          | 1             | null          | 100                  | 20                      | null      || CampoMandatoryRuntimeException
        false                                | new CivMorte()        | true               | null            | 2021         | 123          | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException

        true                                 | new CivNascita()      | false              | null            | null         | 123          | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivNascita()      | false              | null            | 2021         | null         | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivNascita()      | false              | null            | 2021         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivNascita()      | false              | null            | 2021         | 123          | 1             | null          | null                 | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivNascita()      | false              | null            | 2021         | 123          | 1             | null          | 100                  | null                    | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivNascita()      | false              | null            | 2021         | 123          | 1             | null          | 100                  | 20                      | null      || CampoMandatoryRuntimeException
        true                                 | new CivNascita()      | true               | null            | 2021         | 123          | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException

        true                                 | new CivCittadinanza() | false              | null            | null         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivCittadinanza() | false              | null            | 2021         | null         | null          | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivCittadinanza() | false              | null            | 2021         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivCittadinanza() | false              | null            | 2021         | 123          | null          | null          | null                 | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivCittadinanza() | false              | null            | 2021         | 123          | null          | null          | 100                  | null                    | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivCittadinanza() | false              | null            | 2021         | 123          | null          | null          | 100                  | 20                      | null      || CampoMandatoryRuntimeException
        true                                 | new CivCittadinanza() | true               | null            | 2021         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException

        true                                 | new CivMatrimonio()   | false              | null            | null         | 123          | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivMatrimonio()   | false              | null            | 2021         | null         | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivMatrimonio()   | false              | null            | 2021         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivMatrimonio()   | false              | null            | 2021         | 123          | 1             | null          | null                 | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivMatrimonio()   | false              | null            | 2021         | 123          | 1             | null          | 100                  | null                    | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivMatrimonio()   | false              | null            | 2021         | 123          | 1             | null          | 100                  | 20                      | null      || CampoMandatoryRuntimeException
        true                                 | new CivMatrimonio()   | true               | null            | 2021         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException

        true                                 | new CivUnioneCivile() | false              | null            | null         | 123          | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivUnioneCivile() | false              | null            | 2021         | null         | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivUnioneCivile() | false              | null            | 2021         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivUnioneCivile() | false              | null            | 2021         | 123          | 1             | null          | null                 | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivUnioneCivile() | false              | null            | 2021         | 123          | 1             | null          | 100                  | null                    | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivUnioneCivile() | false              | null            | 2021         | 123          | 1             | null          | 100                  | 20                      | null      || CampoMandatoryRuntimeException
        true                                 | new CivUnioneCivile() | true               | null            | 2021         | 123          | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException

        true                                 | new CivMorte()        | false              | null            | null         | 123          | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivMorte()        | false              | null            | 2021         | null         | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivMorte()        | false              | null            | 2021         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivMorte()        | false              | null            | 2021         | 123          | 1             | null          | null                 | 20                      | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivMorte()        | false              | null            | 2021         | 123          | 1             | null          | 100                  | null                    | "FORMULA" || CampoMandatoryRuntimeException
        true                                 | new CivMorte()        | false              | null            | 2021         | 123          | 1             | null          | 100                  | 20                      | null      || CampoMandatoryRuntimeException
        true                                 | new CivMorte()        | true               | null            | 2021         | 123          | 1             | null          | 100                  | 20                      | "FORMULA" || CampoMandatoryRuntimeException

    }

    @Unroll
    def "Salva Annotazione su Atto Nascita Soggetto 1 per nuova gestione annotazione #nuovaGestioneAnnotazioneSuAttoAttiva, estremi atto primario validi #valid, del comune cliente #isComuneCliente, atti primari trovati #countAttoPrimarioTrovato, tipoSalvataggio #tipoSalvataggio, ci si aspetta l'esecuzione #expectedExecution"() {

        given:
        arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva() >> nuovaGestioneAnnotazioneSuAttoAttiva
        arcComuneBaseService.isComuneClienteAnnotazione(_ as Integer, _ as Integer) >> isComuneCliente

        civFormulaAnnotazioneService.get(_ as String) >> new CivFormulaAnnotazione()

        civNascitaRepository.countByUfficioAndAnnoAndAttoAndParteAndSerie(_ as Integer, _ as Integer, _ as Integer, _ as Integer, _ as String) >> countAttoPrimarioTrovato
        civNascitaRepository.findByUkAtto(_ as Integer, _ as Integer, _ as Integer, _ as Integer, _ as String) >> Mock(CivNascita)
        civNascitaRepository.countByIdAttoAnsc(_ as String) >> countAttoPrimarioTrovato
        civNascitaRepository.findByIdAttoAnsc(_ as String) >> Mock(CivNascita)

        civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto1(attoSecondario, estremiAttoPrimario, _ as String) >> { obj, estremi, formulaId -> valid }
        civAnnotazioneAttoService.save(_ as ETipoOperazione, _ as CivAnnotazioneAtto, _ as CivAttoBaseDomain, _ as CivAttoBaseDomain) >> { new CivAnnotazioneAtto() }
        civAnnotazioneAttoService.save(_ as ETipoOperazione, _ as CivAnnotazioneAtto, _ as CivAttoBaseDomain) >> { new CivAnnotazioneAtto() }

        when:
        civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita1(attoSecondario as CivAttoBaseDomain, estremiAttoPrimario, _ as String, new CivAnnotazioneTestoLibero(), tipoSalvataggio as ETipoSalvataggioAnnotazioneComuneCliente)

        then:
        if (expectedExecution == 'comuneIstanza') {
            1 * civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita1ComuneCliente(estremiAttoPrimario, _ as CivAnnotazioneAtto, attoSecondario)
            0 * civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita1AltroComune(attoSecondario, _ as CivAnnotazioneAtto)
        } else if (expectedExecution == 'comuneAltro') {
            1 * civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita1AltroComune(attoSecondario, _ as CivAnnotazioneAtto)
            0 * civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita1ComuneCliente(estremiAttoPrimario, _ as CivAnnotazioneAtto, attoSecondario)
        } else if (expectedExecution == 'none') {
            0 * civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita1ComuneCliente(estremiAttoPrimario, _ as CivAnnotazioneAtto, attoSecondario)
            0 * civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita1AltroComune(attoSecondario, _ as CivAnnotazioneAtto)
        }

        where:
        nuovaGestioneAnnotazioneSuAttoAttiva | valid | isComuneCliente | estremiAttoPrimario                            | attoSecondario        | countAttoPrimarioTrovato | tipoSalvataggio                                                               || expectedExecution
        false                                | false | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMatrimonio()   | 0                        | null                                                                          || "none"

        false                                | true  | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMatrimonio()   | 1                        | null                                                                          || 'comuneIstanza'
        false                                | true  | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivUnioneCivile() | 1                        | null                                                                          || 'comuneIstanza'
        false                                | true  | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMorte()        | 1                        | null                                                                          || 'comuneIstanza'
        false                                | true  | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMorte()        | 0                        | ETipoSalvataggioAnnotazioneComuneCliente.CREA_ATTO_E_SALVA_COMUNE_CLIENTE     || 'comuneIstanza'
        false                                | true  | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMorte()        | 0                        | ETipoSalvataggioAnnotazioneComuneCliente.NON_CREARE_ATTO_E_SALVA_ALTRO_COMUNE || 'comuneAltro'
        false                                | true  | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivCittadinanza() | 1                        | null                                                                          || 'comuneIstanza'

        false                                | true  | false           | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMatrimonio()   | _                        | null                                                                          || 'comuneAltro'
        false                                | true  | false           | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivUnioneCivile() | _                        | null                                                                          || 'comuneAltro'
        false                                | true  | false           | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMorte()        | _                        | null                                                                          || 'comuneAltro'
        false                                | true  | false           | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivCittadinanza() | _                        | null                                                                          || 'comuneAltro'

        true                                 | false | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMatrimonio()   | 0                        | null                                                                          || "none"
        true                                 | false | true            | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivMatrimonio()   | 0                        | null                                                                          || "none"

        true                                 | true  | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMatrimonio()   | 1                        | null                                                                          || 'comuneIstanza'
        true                                 | true  | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivUnioneCivile() | 1                        | null                                                                          || 'comuneIstanza'
        true                                 | true  | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMorte()        | 1                        | null                                                                          || 'comuneIstanza'
        true                                 | true  | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMorte()        | 0                        | ETipoSalvataggioAnnotazioneComuneCliente.CREA_ATTO_E_SALVA_COMUNE_CLIENTE     || 'comuneIstanza'
        true                                 | true  | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMorte()        | 0                        | ETipoSalvataggioAnnotazioneComuneCliente.NON_CREARE_ATTO_E_SALVA_ALTRO_COMUNE || 'comuneAltro'
        true                                 | true  | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivCittadinanza() | 1                        | null                                                                          || 'comuneIstanza'
        true                                 | true  | true            | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivMatrimonio()   | 1                        | null                                                                          || 'comuneIstanza'
        true                                 | true  | true            | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivUnioneCivile() | 1                        | null                                                                          || 'comuneIstanza'
        true                                 | true  | true            | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivMorte()        | 1                        | null                                                                          || 'comuneIstanza'
        true                                 | true  | true            | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivMorte()        | 0                        | ETipoSalvataggioAnnotazioneComuneCliente.CREA_ATTO_E_SALVA_COMUNE_CLIENTE     || 'comuneIstanza'
        true                                 | true  | true            | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivMorte()        | 0                        | ETipoSalvataggioAnnotazioneComuneCliente.NON_CREARE_ATTO_E_SALVA_ALTRO_COMUNE || 'comuneAltro'
        true                                 | true  | true            | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivCittadinanza() | 1                        | null                                                                          || 'comuneIstanza'

        true                                 | true  | false           | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMatrimonio()   | _                        | null                                                                          || 'comuneAltro'
        true                                 | true  | false           | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivUnioneCivile() | _                        | null                                                                          || 'comuneAltro'
        true                                 | true  | false           | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMorte()        | _                        | null                                                                          || 'comuneAltro'
        true                                 | true  | false           | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivCittadinanza() | _                        | null                                                                          || 'comuneAltro'
        true                                 | true  | false           | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivMatrimonio()   | _                        | null                                                                          || 'comuneAltro'
        true                                 | true  | false           | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivUnioneCivile() | _                        | null                                                                          || 'comuneAltro'
        true                                 | true  | false           | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivMorte()        | _                        | null                                                                          || 'comuneAltro'
        true                                 | true  | false           | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivCittadinanza() | _                        | null                                                                          || 'comuneAltro'
    }

    @Unroll
    def "Salva Annotazione su Atto Nascita Soggetto 1 per atto primario del comune cliente ma con atto non esistente, attoSecondario #attoSecondario, genera l'eccezione #expectedException"() {

        given:
        arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva() >> nuovaGestioneAnnotazioneSuAttoAttiva
        arcComuneBaseService.isComuneClienteAnnotazione(_ as Integer, _ as Integer) >> true

        civFormulaAnnotazioneService.get(_ as String) >> new CivFormulaAnnotazione()

        civNascitaRepository.countByUfficioAndAnnoAndAttoAndParteAndSerie(_ as Integer, _ as Integer, _ as Integer, _ as Integer, _ as String) >> 0
        civNascitaRepository.countByIdAttoAnsc(_ as String) >> 0

        civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto1 >> { true }

        when:
        civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita1(attoSecondario, estremiAttoPrimario, "123", new CivAnnotazioneTestoLibero(), null)

        then:
        thrown(expectedException)

        where:
        nuovaGestioneAnnotazioneSuAttoAttiva | estremiAttoPrimario                            | attoSecondario        || expectedException
        false                                | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMatrimonio()   || ErroreDatiAnnotazioneRuntimeException
        false                                | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivUnioneCivile() || ErroreDatiAnnotazioneRuntimeException
        false                                | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMorte()        || ErroreAssenzaTipoSalvataggioAnnotazioneComuneClienteSuAttoNascita1RuntimeException
        false                                | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivCittadinanza() || ErroreDatiAnnotazioneRuntimeException

        true                                 | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMatrimonio()   || ErroreDatiAnnotazioneRuntimeException
        true                                 | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivUnioneCivile() || ErroreDatiAnnotazioneRuntimeException
        true                                 | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMorte()        || ErroreAssenzaTipoSalvataggioAnnotazioneComuneClienteSuAttoNascita1RuntimeException
        true                                 | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivCittadinanza() || ErroreDatiAnnotazioneRuntimeException
        true                                 | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivMatrimonio()   || ErroreDatiAnnotazioneRuntimeException
        true                                 | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivUnioneCivile() || ErroreDatiAnnotazioneRuntimeException
        true                                 | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivMorte()        || ErroreAssenzaTipoSalvataggioAnnotazioneComuneClienteSuAttoNascita1RuntimeException
        true                                 | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivCittadinanza() || ErroreDatiAnnotazioneRuntimeException

    }

}
