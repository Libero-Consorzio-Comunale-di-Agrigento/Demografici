package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.AbstractServiceSpec
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdValidazioneTestoService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.utils.DataUtils
import it.finmatica.de4gsdzk.utils.ENaturaAtto
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import spock.lang.Shared
import spock.lang.Unroll

import javax.sql.DataSource

@SpringBootTest
class CivAnnotazioneAttoService175QuinquSpec extends AbstractServiceSpec<CivAnnotazioneAttoService175QuinquSpec> {
    CivAnnotazioneAttoService service

    def civAnnotazioneAttoRepository = Mock(CivAnnotazioneAttoRepository)

    CivAnagrafeService civAnagrafeService
    GsdValidazioneTestoService gsdValidazioneTestoService
    CivArchivioComunicazioneService civArchivioComunicazioneService
    CivComunicazioneAllegatoService civComunicazioneAllegatoService
    CivNascitaService civNascitaService
    CivFormulaAnnotazioneService civFormulaAnnotazioneService
    CivComunicazioneFormulaService civComunicazioneFormulaService
    ArcComuneBaseService arcComuneBaseService
    ArcParametroService arcParametroService
    CivNotaFormulaService civNotaFormulaService
    CivTestoFormulaService civTestoFormulaService

    def civNascitaRepository = Mock(CivNascitaRepository)
    def civMatrimonioRepository = Mock(CivMatrimonioRepository)
    def civUnioneCivileRepository = Mock(CivUnioneCivileRepository)
    def civFormulaAnnotazioneRepository = Mock(CivFormulaAnnotazioneRepository)

    @Autowired
    DataSource dataSource

    CivAttoBaseDomain attoSource = Stub(CivAttoBaseDomain)

    CivDatiProvenienzaAtto dpaSource = Stub(CivDatiProvenienzaAtto)

    String testoAtteso
    String testoDb

    String nomeConiuge1 = "nomeConiuge1"
    String cognomeConiuge1 = "cogConiuge1"
    String nomeConiuge2 = "nomeConiuge2"
    String cognomeConiuge2 = "cogConiuge2"

    String nomeAvvocato1 = "nomeAvvocato1"
    String cognomeAvvocato1 = "cogAvvocato1"
    String nomeAvvocato2 = "nomeAvvocato2"
    String cognomeAvvocato2 = "cogAvvocato2"

    String annoAccordo = "2015"

    String dataAccordoDivorzioString = "15/07/2015"

    String numeroAttoAccordo = "18"
    String parteAttoAccordo = "2"
    String serieAttoAccordo = "B"

    String dataAttoString = "15/02/2023"

    String numeroAtto = "2"
    String parteAtto = "1"
    String serieAtto = "A"

    String annoAtto = "2023"

    String annoAtto30 = "2023"
    String numeroAtto30 = "5"

    String tipoDivorzio = "S"

    String testoGALLES = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 in data #2 , " +
            "di cui all'atto iscritto nei registri di matrimonio del predetto ufficio dello stato civile, al n.#3 parte #4 serie #5 " +
            "e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri, al n. #6 parte #7 serie #8 anno #13 , " +
            "i coniugi #9 #10 e #11 #12 , di cui al matrimonio controscritto si sono separati."
    String testoBelluno = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 in data #2 , " +
            "di cui all'atto iscritto nei registri di matrimonio del predetto ufficio dello stato civile, al n.#3 " +
            "parte #4 serie #5 e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri, al n. #6 parte #7 serie #8 anno #13 , " +
            "i coniugi #9 #10 e #11 #12 , di cui al matrimonio controscritto si sono separati."
    String testoFaenza = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 , in data #2 , " +
            "di cui all'atto iscritto nei registri di matrimonio del predetto ufficio dello stato civile, al n. #3 parte #4 serie #5 , " +
            "e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri, al n. #6 parte #7 " +
            "serie #8 , i coniugi #9 e #10 #11 #12 #13 #14 di cui al matrimonio controscritto si sono separati."
    String testoLodi = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 , in data #2 , " +
            "di cui all'atto iscritto nei registri di matrimonio del predetto ufficio dello stato civile, al n. #3 parte #4 serie #5 , " +
            "e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri, al n. #6 parte #7 serie #8 , " +
            "i coniugi #9 #10 #11 e #12 #13 #14 di cui al matrimonio controscritto si sono separati."
    String testoValeggio = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 , in data #2 , " +
            "di cui all'atto iscritto nei registri di matrimonio del predetto ufficio dello stato civile, al n. #3 parte #4 serie #5 ," +
            " e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri, al n. #6 parte #7 serie #8 , " +
            "i coniugi #9 #10 #11 e #12 #13 #14 di cui al matrimonio controscritto si sono separati."
    String testoSanLazzaro = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 in data #2 , di cui all'atto iscritto nei registri " +
            "di matrimonio del predetto ufficio dello stato civile al n. #3 Parte II Serie C anno #4 e confermato con dichiarazioni " +
            "di cui all'atto iscritto nei predetti registri al n. #5 Parte II Serie C anno #6 , i coniugi #7 #8 di cui al matrimonio controscritto si sono separati."
    String testoCodigoro = "Con accordo concluso innanzi all'Ufficiale di Stato Civile del Comune di #1 in data #2 , di cui all'atto iscritto nei registri " +
            "di matrimonio del predetto ufficio dello Stato Civile, al n. #3 parte seconda serie C, e confermato con dichiarazioni di cui all'atto " +
            "iscritto nei predetti registri, al n. #4 parte seconda serie C, i coniugi #5 #6 e #7 #8 di cui al matrimonio controscritto si sono separati."
    String testoSanDonato = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 , in data #2 , di cui all'atto iscritto nei registri " +
            "di matrimonio del predetto ufficio dello stato civile, al n. #3 parte #4 serie #5 , e confermato con dichiarazioni di cui all'atto iscritto " +
            "nei predetti registri, al n. #6 parte #7 serie #8 , i coniugi #9 #10 #11 e #12 #13 #14 di cui al matrimonio controscritto si sono separati."
    String testoGuastalla = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 , in data #2 , di cui all'atto iscritto nei registri " +
            "di matrimonio del predetto ufficio dello stato civile, al n. #3 parte #4 serie #5 , e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri, " +
            "al n. #6 parte #7 serie #8 , i coniugi #9 #10 #11 e #12 #13 #14 di cui al matrimonio controscritto si sono separati."
    String testoTrapani = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 in data #2 di cui all'atto iscritto nei registri " +
            "di matrimonio del predetto ufficio di stato civile al n. #3 parte 2 serie C anno #4 e confermato con dichiarazioni di cui all'atto iscritto nei " +
            "predetti registri al n. #5 parte 2 serie C anno #6 i coniugi #7 e #8 di cui al matrimonio controscritto si sono separati."

    Map<String, String> mappaVariabili = ["#1": "FAENZA", "#2": dataAccordoDivorzioString, "#3": numeroAttoAccordo,
                                          "#4": parteAttoAccordo, "#5": serieAttoAccordo, "#6": numeroAtto, "#7": parteAtto,
                                          "#8": serieAtto, "#9": cognomeConiuge1+" "+nomeConiuge1, "#10": cognomeConiuge2+" "+nomeConiuge2,
                                          "#11": "", "#12": "", "#13": "", "#14": "",
                                          "#15": "", "#16": "", "#17": "", "#18": "", "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                          "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto30, "#30": numeroAtto30]

    Map<String, String> mappaVariabileBel = ["#1": "FAENZA", "#2": dataAccordoDivorzioString, "#3": numeroAttoAccordo,
                                             "#4": parteAttoAccordo, "#5": serieAttoAccordo, "#6": numeroAtto, "#7": parteAtto,
                                             "#8": serieAtto, "#9": cognomeConiuge1, "#10": nomeConiuge1, "#11": cognomeConiuge2, "#12": nomeConiuge2,
                                             "#13": annoAtto, "#14": "", "#15": "", "#16": "", "#17": "", "#18": "", "#19": "", "#20": "", "#21": "",
                                             "#22": "", "#23": "", "#24": "", "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto30, "#30": numeroAtto30]

    Map<String, String> mappaVariabileFae = ["#1": "FAENZA", "#2": dataAccordoDivorzioString, "#3": numeroAttoAccordo,
                                             "#4": parteAttoAccordo, "#5": serieAttoAccordo, "#6": numeroAtto, "#7": parteAtto,
                                             "#8": serieAtto, "#9": cognomeConiuge1+" "+nomeConiuge1, "#10": cognomeConiuge2+" "+nomeConiuge2, "#11": "",
                                             "#12": "", "#13": "", "#14": "", "#15": "", "#16": "", "#17": "", "#18": "", "#19": "", "#20": "", "#21": "",
                                             "#22": "", "#23": "", "#24": "", "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto30, "#30": numeroAtto30]

    Map<String, String> mappaVariabileLodValGuaSnd = ["#1": "FAENZA", "#2": dataAccordoDivorzioString, "#3": numeroAttoAccordo,
                                                      "#4": parteAttoAccordo, "#5": serieAttoAccordo, "#6": numeroAtto, "#7": parteAtto,
                                                      "#8": serieAtto, "#9": cognomeConiuge1+" "+nomeConiuge1, "#10": "", "#11": "", "#12": cognomeConiuge2+" "+nomeConiuge2,
                                                      "#13": "", "#14": "", "#15": "", "#16": "", "#17": "", "#18": "",
                                                      "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                                      "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto30, "#30": numeroAtto30]

    Map<String, String> mappaVariabileSnlTra = ["#1": "FAENZA", "#2": dataAccordoDivorzioString, "#3": numeroAttoAccordo,
                                                "#4": annoAccordo, "#5": numeroAtto, "#6": annoAtto, "#7": cognomeConiuge1+" "+nomeConiuge1,
                                                "#8": cognomeConiuge2+" "+nomeConiuge2, "#9": "", "#10": "", "#11": "", "#12": "",
                                                "#13": "", "#14": "", "#15": "", "#16": "", "#17": "", "#18": "",
                                                "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                                "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto30, "#30": numeroAtto30]

    Map<String, String> mappaVariabileCod = ["#1": "FAENZA", "#2": dataAccordoDivorzioString, "#3": numeroAttoAccordo,
                                             "#4": numeroAtto, "#5": cognomeConiuge1+" "+nomeConiuge1, "#6": "", "#7": cognomeConiuge2+" "+nomeConiuge2,
                                             "#8": "", "#9": "", "#10": "", "#11": "", "#12": "",
                                             "#13": "", "#14": "", "#15": "", "#16": "", "#17": "", "#18": "",
                                             "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                             "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto30, "#30": numeroAtto30]

    Map<String, Map<String,?>> annotazioneComune = ["FAENZA":[testo:testoGALLES, formula:"175-QUINQU", variabili:mappaVariabili],
                                                    "Belluno":[testo:testoBelluno, formula:"175-QUIBEL", variabili:mappaVariabileBel],
                                                    "Faenza":[testo:testoFaenza, formula:"175-QUIFAE", variabili:mappaVariabileFae],
                                                    "Lodi":[testo:testoLodi, formula:"175-QUILOD", variabili:mappaVariabileLodValGuaSnd],
                                                    "Codigoro":[testo:testoCodigoro, formula:"175-QUICOD", variabili:mappaVariabileCod],
                                                    "Valeggio":[testo:testoValeggio, formula:"175-QUIVAL", variabili:mappaVariabileLodValGuaSnd],
                                                    "San Lazzaro":[testo:testoSanLazzaro, formula:"175-QUISNL", variabili:mappaVariabileSnlTra],
                                                    "San Donato":[testo:testoSanDonato, formula:"175-QUISND", variabili:mappaVariabileLodValGuaSnd],
                                                    "Guastalla":[testo:testoGuastalla, formula:"175-QUIGUA", variabili:mappaVariabileLodValGuaSnd],
                                                    "Trapani":[testo:testoTrapani, formula:"175-QUITRA", variabili:mappaVariabileSnlTra],
    ]

    String comune

    @Shared
    List<String> listaComuni = ["FAENZA", "Belluno", "Faenza", "Lodi", "Codigoro", "Valeggio", "San Lazzaro", "San Donato", "Guastalla", "Trapani"]

    def setup(){
        gsdService = new GsdService(dataSource,
                Mock(UtenteCustomService), Mock(ArcComuneBaseService), Mock(ArcParametroService)
        )

        service = new CivAnnotazioneAttoService(Mock(ArcParametroService), civAnnotazioneAttoRepository,
                gsdService, civAnagrafeService, gsdValidazioneTestoService, civArchivioComunicazioneService,
                civFormulaAnnotazioneService, civComunicazioneFormulaService, civNascitaRepository,
                civMatrimonioRepository, civUnioneCivileRepository, arcComuneBaseService, civComunicazioneAllegatoService, civNascitaService
        )

        civFormulaAnnotazioneService = new CivFormulaAnnotazioneService(civFormulaAnnotazioneRepository, gsdService,
                civNotaFormulaService, civTestoFormulaService, arcParametroService, Mock(GsdValidazioneTestoService)
        )

        attoSource = new CivMatrimonio(atto: numeroAtto as Integer, parte: parteAtto as Integer, serie: serieAtto,
                anno: annoAtto as Integer, natura: ENaturaAtto.O, dataMatrimonio: DataUtils.fromStringToDate(dataAttoString), nome1: nomeConiuge1,
                cognome1: cognomeConiuge1, nome2: nomeConiuge2, cognome2: cognomeConiuge2, divorzio: true)

        dpaSource = new CivDatiProvenienzaAtto(dataAccordo: DataUtils.fromStringToDate(dataAccordoDivorzioString), dataAtto: DataUtils.fromStringToDate(dataAttoString),
                attoAccordo: numeroAttoAccordo as Integer, parteAccordo: parteAttoAccordo as Integer, serieAccordo: serieAttoAccordo,
                tipoDivorzio: tipoDivorzio, annoAccordo: annoAccordo as Integer, avvocato1: nomeAvvocato1+" "+cognomeAvvocato1, avvocato2: nomeAvvocato2+" "+cognomeAvvocato2)
    }

    @Unroll
    def "Test per l'annotazione 175-QUINQU - #comune"(){
        given:

        when:
        ((CivMatrimonio) attoSource).descrizioneComuneMatrimonio = comune

        Boolean variabiliVuoteSuCivnfa = gestioneVariabiliOld(annotazioneComune[comune].formula)

        testoDb = gsdService.decodificaTestoAnnotazione(attoSource.getTipoAtto(), annotazioneComune[comune].formula, attoSource, dpaSource, 1)?.trim()
        testoAtteso = estraiTestoDaMappa(annotazioneComune[comune].variabili, annotazioneComune[comune].testo)?.trim()

        then:
        testoDb == testoAtteso || (testoDb != testoAtteso && variabiliVuoteSuCivnfa)

        where:
        i << (0..(listaComuni.size() - 1))
        comune = listaComuni[i]
    }

    String estraiTestoDaMappa(Map<String, String> mappaCorrispondeteAFormula, String testoCodificato) {
        String testoRisultante

        List<String> listaIndiciVariabili = testoCodificato.findAll("(#=?)[0-9]+(?=\\s)")

        for (String indice : listaIndiciVariabili) {
            if (mappaCorrispondeteAFormula[indice] != "") {
                if (testoCodificato.substring(testoCodificato.indexOf(indice) - 7, testoCodificato.indexOf(indice)).contains("parte")) {
                    if (mappaCorrispondeteAFormula[indice] == "1") {
                        mappaCorrispondeteAFormula[indice] = "I"
                    } else if (mappaCorrispondeteAFormula[indice] == "2") {
                        mappaCorrispondeteAFormula[indice] = "II"
                    }
                }
                testoRisultante = testoCodificato.replace(indice + " ", mappaCorrispondeteAFormula[indice] + " ")
            } else {
                testoRisultante = testoCodificato.replace(indice + " ", " ")
            }
            testoCodificato = testoRisultante
        }
        return testoRisultante
    }

}
