package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdValidazioneTestoService
import it.finmatica.de4gsdzk.IEstremiAttoNascitaSoggetto2Domain
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreDatiAnnotazioneRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import spock.lang.Specification
import spock.lang.Unroll

class CivAnnotazioneAttoServiceSuNascita2Spec extends Specification {
    private static IEstremiAttoNascitaSoggetto2Domain ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO = new CivSposiAtto(ufficioAttoNascita2: 1, annoAttoNascita2: 2020, attoAttoNascita2: 100, parteAttoNascita2String: "1", serieAttoNascita2: "A", codiceComuneAttoNascita2: 111, codiceProvinciaAttoNascita2: 22)
    private static IEstremiAttoNascitaSoggetto2Domain ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO = new CivSposiAtto(idAttoAnscNascita2: "123456789", codiceComuneAttoNascita2: 111, codiceProvinciaAttoNascita2: 22)

    ArcParametroService arcParametroService = Mock(ArcParametroService)
    ArcComuneBaseService arcComuneBaseService = Mock(ArcComuneBaseService)
    CivFormulaAnnotazioneService civFormulaAnnotazioneService = Mock(CivFormulaAnnotazioneService)
    CivNascitaRepository civNascitaRepository = Mock(CivNascitaRepository)

    CivAnnotazioneAttoService civAnnotazioneAttoService

    void setup() {
        CivAnnotazioneAttoRepository civAnnotazioneAttoRepository = Mock(CivAnnotazioneAttoRepository)
        GsdService gsdService = Mock(GsdService)
        CivAnagrafeService civAnagrafeService = Mock(CivAnagrafeService)
        GsdValidazioneTestoService gsdValidazioneTestoService = Mock(GsdValidazioneTestoService)
        CivArchivioComunicazioneService civArchivioComunicazioneService = Mock(CivArchivioComunicazioneService)
        CivComunicazioneFormulaService civComunicazioneFormulaService = Mock(CivComunicazioneFormulaService)
        CivMatrimonioRepository civMatrimonioRepository = Mock(CivMatrimonioRepository)
        CivUnioneCivileRepository civUnioneCivileRepository = Mock(CivUnioneCivileRepository)
        CivComunicazioneAllegatoService civComunicazioneAllegatoService = Mock(CivComunicazioneAllegatoService)
        CivNascitaService civNascitaService = Mock(CivNascitaService)

        civAnnotazioneAttoService = Spy(CivAnnotazioneAttoService, constructorArgs: [arcParametroService,
                                                                                     civAnnotazioneAttoRepository,
                                                                                     gsdService,
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
    def "Valida Dati Atto Nascita Soggetto 2 per gestione nuova annotazione #nuovaGestioneAnnotazioneSuAttoAttiva, attoSecondario #attoSecondario, ufficioObbligatory #ufficioObbligatory, si aspetta result #expectedResult"() {
        given:
        IEstremiAttoNascitaSoggetto2Domain estremiAttoPrimario = new CivSposiAtto(ufficioAttoNascita2: ufficioPrimario,
                annoAttoNascita2: annoPrimario,
                attoAttoNascita2: attoPrimario,
                parteAttoNascita2String: partePrimario,
                serieAttoNascita2: seriePrimario,
                codiceComuneAttoNascita2: codiceComunePrimario,
                codiceProvinciaAttoNascita2: codiceProvinciaPrimario)
        arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva() >> nuovaGestioneAnnotazioneSuAttoAttiva
        arcComuneBaseService.isComuneClienteAnnotazione(codiceComunePrimario, codiceProvinciaPrimario) >> ufficioObbligatory

        when:
        Boolean result = civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto2(attoSecondario, estremiAttoPrimario, formula)

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
    def "Valida Dati Atto Nascita Soggetto 2 per gestione nuova annotazione #nuovaGestioneAnnotazioneSuAttoAttiva si aspetta CampoMandatoryRuntimeException per attoSecondario #attoSecondario"() {
        given:
        IEstremiAttoNascitaSoggetto2Domain estremiAttoPrimario = new CivSposiAtto(ufficioAttoNascita2: ufficioPrimario,
                annoAttoNascita2: annoPrimario,
                attoAttoNascita2: attoPrimario,
                parteAttoNascita2String: partePrimario,
                serieAttoNascita2: seriePrimario,
                codiceComuneAttoNascita2: codiceComunePrimario,
                codiceProvinciaAttoNascita2: codiceProvinciaPrimario)
        arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva() >> nuovaGestioneAnnotazioneSuAttoAttiva
        arcComuneBaseService.isComuneClienteAnnotazione(codiceComunePrimario, codiceProvinciaPrimario) >> ufficioObbligatory

        when:
        civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto2(attoSecondario, estremiAttoPrimario, formula)

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

        false                                | new CivCittadinanza() | false              | null            | null         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || De4gsdzkRuntimeException
        false                                | new CivCittadinanza() | false              | null            | 2021         | null         | null          | null          | 100                  | 20                      | "FORMULA" || De4gsdzkRuntimeException
        false                                | new CivCittadinanza() | false              | null            | 2021         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || De4gsdzkRuntimeException
        false                                | new CivCittadinanza() | false              | null            | 2021         | 123          | null          | null          | null                 | 20                      | "FORMULA" || De4gsdzkRuntimeException
        false                                | new CivCittadinanza() | false              | null            | 2021         | 123          | null          | null          | 100                  | null                    | "FORMULA" || De4gsdzkRuntimeException
        false                                | new CivCittadinanza() | false              | null            | 2021         | 123          | null          | null          | 100                  | 20                      | null      || De4gsdzkRuntimeException
        false                                | new CivCittadinanza() | true               | null            | 2021         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || De4gsdzkRuntimeException

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

        false                                | new CivMorte()        | false              | null            | null         | 123          | 1             | null          | 100                  | 20                      | "FORMULA" || De4gsdzkRuntimeException
        false                                | new CivMorte()        | false              | null            | 2021         | null         | 1             | null          | 100                  | 20                      | "FORMULA" || De4gsdzkRuntimeException
        false                                | new CivMorte()        | false              | null            | 2021         | 123          | null          | null          | 100                  | 20                      | "FORMULA" || De4gsdzkRuntimeException
        false                                | new CivMorte()        | false              | null            | 2021         | 123          | 1             | null          | null                 | 20                      | "FORMULA" || De4gsdzkRuntimeException
        false                                | new CivMorte()        | false              | null            | 2021         | 123          | 1             | null          | 100                  | null                    | "FORMULA" || De4gsdzkRuntimeException
        false                                | new CivMorte()        | false              | null            | 2021         | 123          | 1             | null          | 100                  | 20                      | null      || De4gsdzkRuntimeException
        false                                | new CivMorte()        | true               | null            | 2021         | 123          | 1             | null          | 100                  | 20                      | "FORMULA" || De4gsdzkRuntimeException

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
    def "Salva Annotazione su Atto Nascita Soggetto 2 per nuova gestione annotazione #nuovaGestioneAnnotazioneSuAttoAttiva, estremi atto primario validi #valid, del comune cliente #isComuneCliente, atti primari trovati #countAttoPrimarioTrovato, ci si aspetta l'esecuzione #expectedExecution"() {

        given:
        arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva() >> nuovaGestioneAnnotazioneSuAttoAttiva
        arcComuneBaseService.isComuneClienteAnnotazione(_ as Integer, _ as Integer) >> isComuneCliente

        civFormulaAnnotazioneService.get(_ as String) >> new CivFormulaAnnotazione()

        civNascitaRepository.countByUfficioAndAnnoAndAttoAndParteAndSerie(_ as Integer, _ as Integer, _ as Integer, _ as Integer, _ as String) >> { countAttoPrimarioTrovato }
        civNascitaRepository.findByUkAtto(_ as Integer, _ as Integer, _ as Integer, _ as Integer, _ as String) >> Mock(CivNascita)
        civNascitaRepository.countByIdAttoAnsc(_ as String) >> countAttoPrimarioTrovato
        civNascitaRepository.findByIdAttoAnsc(_ as String) >> Mock(CivNascita)

        civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto2(attoSecondario, estremiAttoPrimario, _ as String) >> { obj, estremi, formulaId -> valid }
        civAnnotazioneAttoService.save(_ as ETipoOperazione, _ as CivAnnotazioneAtto, _ as CivAttoBaseDomain, _ as CivAttoBaseDomain) >> { new CivAnnotazioneAtto() }
        civAnnotazioneAttoService.save(_ as ETipoOperazione, _ as CivAnnotazioneAtto, _ as CivAttoBaseDomain) >> { new CivAnnotazioneAtto() }

        when:
        civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita2(attoSecondario as CivAttoBaseDomain, estremiAttoPrimario, _ as String, new CivAnnotazioneTestoLibero())

        then:
        if (expectedExecution == 'comuneIstanza') {
            1 * civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita2ComuneCliente(estremiAttoPrimario, _ as CivAnnotazioneAtto, attoSecondario)
            0 * civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita2AltroComune(attoSecondario, _ as CivAnnotazioneAtto, _ as CivFormulaAnnotazione)
        } else if (expectedExecution == 'comuneAltro') {
            1 * civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita2AltroComune(attoSecondario, _ as CivAnnotazioneAtto, _ as CivFormulaAnnotazione)
            0 * civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita2ComuneCliente(estremiAttoPrimario, _ as CivAnnotazioneAtto, attoSecondario)
        } else if (expectedExecution == 'none') {
            0 * civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita2ComuneCliente(estremiAttoPrimario, _ as CivAnnotazioneAtto, attoSecondario)
            0 * civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita2AltroComune(attoSecondario, _ as CivAnnotazioneAtto, _ as CivFormulaAnnotazione)
        }

        where:
        nuovaGestioneAnnotazioneSuAttoAttiva | valid | isComuneCliente | estremiAttoPrimario                            | attoSecondario        | countAttoPrimarioTrovato || expectedExecution
        false                                | false | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMatrimonio()   | 0                        || "none"

        false                                | true  | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMatrimonio()   | 1                        || 'comuneIstanza'
        false                                | true  | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivUnioneCivile() | 1                        || 'comuneIstanza'

        false                                | true  | false           | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMatrimonio()   | _                        || 'comuneAltro'
        false                                | true  | false           | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivUnioneCivile() | _                        || 'comuneAltro'

        true                                 | false | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMatrimonio()   | 0                        || "none"
        true                                 | false | true            | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivMatrimonio()   | 0                        || "none"

        true                                 | true  | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMatrimonio()   | 1                        || 'comuneIstanza'
        true                                 | true  | true            | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivUnioneCivile() | 1                        || 'comuneIstanza'
        true                                 | true  | true            | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivMatrimonio()   | 1                        || 'comuneIstanza'
        true                                 | true  | true            | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivUnioneCivile() | 1                        || 'comuneIstanza'

        true                                 | true  | false           | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMatrimonio()   | _                        || 'comuneAltro'
        true                                 | true  | false           | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivUnioneCivile() | _                        || 'comuneAltro'
        true                                 | true  | false           | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivMatrimonio()   | _                        || 'comuneAltro'
        true                                 | true  | false           | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivUnioneCivile() | _                        || 'comuneAltro'
    }

    @Unroll
    def "Salva Annotazione su Atto Nascita Soggetto 2 per atto primario del comune cliente ma con atto non esistente, attoSecondario #attoSecondario, genera l'eccezione #expectedException"() {

        given:
        arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva() >> nuovaGestioneAnnotazioneSuAttoAttiva
        arcComuneBaseService.isComuneClienteAnnotazione(_ as Integer, _ as Integer) >> true

        civFormulaAnnotazioneService.get(_ as String) >> new CivFormulaAnnotazione()

        civNascitaRepository.countByUfficioAndAnnoAndAttoAndParteAndSerie(_ as Integer, _ as Integer, _ as Integer, _ as Integer, _ as String) >> 0
        civNascitaRepository.countByIdAttoAnsc(_ as String) >> 0

        civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto2 >> { true }

        when:
        civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita2(attoSecondario, estremiAttoPrimario, _ as String, new CivAnnotazioneTestoLibero())

        then:
        thrown(expectedException)

        where:
        nuovaGestioneAnnotazioneSuAttoAttiva | estremiAttoPrimario                            | attoSecondario        || expectedException
        false                                | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMatrimonio()   || ErroreDatiAnnotazioneRuntimeException
        false                                | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivUnioneCivile() || ErroreDatiAnnotazioneRuntimeException

        true                                 | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivMatrimonio()   || ErroreDatiAnnotazioneRuntimeException
        true                                 | ESTREMI_ATTO_NASCITA_ANALOGICI_PER_SALVATAGGIO | new CivUnioneCivile() || ErroreDatiAnnotazioneRuntimeException
        true                                 | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivMatrimonio()   || ErroreDatiAnnotazioneRuntimeException
        true                                 | ESTREMI_ATTO_NASCITA_DIGITALE_PER_SALVATAGGIO  | new CivUnioneCivile() || ErroreDatiAnnotazioneRuntimeException

    }

}
