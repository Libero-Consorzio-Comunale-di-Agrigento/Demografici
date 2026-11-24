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
class CivAnnotazioneAttoService175SeptieSpec extends AbstractServiceSpec<CivAnnotazioneAttoService175SeptieSpec> {
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

    String dataAccordoDivorzioString = "15/07/2015"

    String numeroAttoAccordo = "18"
    String parteAttoAccordo = "2"
    String serieAttoAccordo = "B"
    String annoAccordo = "2018"

    String dataAttoString = "15/02/2018"

    String numeroAtto = "5"
    String parteAtto = "2"
    String serieAtto = "A"

    String stringaCessazione = "e' stato sciolto il"

    String annoAtto = "2023"

    String annoAtto30 = "2023"
    String numeroAtto30 = "5"

    String testoGALLES = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 in data #2 , " +
            "di cui all'atto iscritto nei registri di matrimonio del predetto ufficio dello stato civile " +
            "al n. #3 parte #4 serie #5 e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri, " +
            "al n. #6 parte #7 serie #8 anno #10 , #9 matrimonio controscritto.   "
    String testoBelluno = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 in data #2 , " +
            "di cui all'atto iscritto nei registri di matrimonio del predetto ufficio dello stato civile al n.#3 parte #4 serie #5 " +
            "e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri," +
            " al n. #6 parte #7 serie #8 anno #10 , #9 matrimonio controscritto."
    String testoValeggio = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 , in data #2 , di cui all'atto iscritto nei registri " +
            "di matrimonio del predetto ufficio dello stato civile, al n. #3 parte #4 serie #5 , " +
            "e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri, al n. #6 parte #7 serie #8 , #9 matrimonio controscritto."
    String testoSanLazzaro = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 in data #2 di cui all'atto iscritto nei registri di matrimonio " +
            "del predetto ufficio dello stato civile al n. #3 Parte II Serie C anno #4 e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri al " +
            "n #5 Parte II Serie C anno #6 #7 #8 matrimonio controscritto."
    String testoCodigoro = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 , in data #2 , di cui all'atto " +
            "iscritto nei registri di matrimonio del predetto ufficio dello stato civile, al n. #3 parte #4 serie #5 , " +
            "e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri, al n. #6 parte #7 serie #8 , #9 matrimonio controscritto."
    String testoFaenza = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 , in data #2 , " +
            "di cui all' atto iscritto nei registri di matrimonio del predetto ufficio dello stato civile, " +
            "al n. #3 parte #4 serie #5 , e confermato con dichiarazioni di cui all' atto iscritto nei predetti registri, " +
            "al n. #6 parte #7 serie #8 , #9 matrimonio controscritto."
    String testoLodi = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1  in data #2" +
            "  di cui all'atto iscritto nei registri di matrimonio del predetto ufficio dello stato civile al n #3 parte #4 serie #5 " +
            "e confermato con dichiarazioni di cui all'atto iscritto nei predetti registri" +
            " al n #6 parte #7 serie #8  #9 matrimonio controscritto"
    String testoSanDonato = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 , in data #2 , di cui all'atto iscritto nei " +
            "registri di matrimonio del predetto ufficio dello stato civile, al n. #3 parte #4 serie #5 , e confermato con dichiarazioni di " +
            "cui all'atto iscritto nei predetti registri, al n. #6 parte #7 serie #8 , #9 matrimonio controscritto."
    String testoGuastalla = "Con accordo concluso innanzi all'ufficiale di stato civile del Comune di #1 , in data #2 , di cui all'atto iscritto nei registri" +
            " di matrimonio del predetto ufficio dello stato civile, al n. #3 parte #4 serie #5 , e confermato con dichiarazioni di cui all'atto " +
            "iscritto nei predetti registri, al n. #6 parte #7 serie #8 , #9 matrimonio controscritto ."
    String testoTrapani = "Con accordo concluso innanzi all'Ufficiale dello Stato Civile del Comune di #1 in data #2 di cui all'atto iscritto nei " +
            "registri di matrimonio del predetto ufficio dello stato civile al n. #3 parte 2 serie C e confermato con dichiarazioni di cui " +
            "all'atto iscritto nei predetti registri al n. #4 parte 2 serie C #5 matrimonio controscritto"

    Map<String, String> mappaVariabili = ["#1" : "FAENZA", "#2": dataAccordoDivorzioString, "#3": numeroAttoAccordo,
                                          "#4" : parteAttoAccordo, "#5": serieAttoAccordo, "#6": numeroAtto, "#7": parteAtto,
                                          "#8" : serieAtto, "#9": stringaCessazione, "#10": annoAtto, "#11": "", "#12": "", "#13": "", "#14": "",
                                          "#15": "", "#16": "", "#17": "", "#18": "", "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                          "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto30, "#30": numeroAtto30]

    Map<String, String> mappaVariabileTra = ["#1" : "FAENZA", "#2": dataAccordoDivorzioString, "#3": numeroAttoAccordo,
                                             "#4" : numeroAtto, "#5": stringaCessazione, "#6": "", "#7": "",
                                             "#8" : "", "#9": "", "#10": "", "#11": "", "#12": "", "#13": "", "#14": "",
                                             "#15": "", "#16": "", "#17": "", "#18": "", "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                             "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto30, "#30": numeroAtto30]

    Map<String, String> mappaVariabileSnl = ["#1" : "FAENZA", "#2": dataAccordoDivorzioString, "#3": numeroAttoAccordo,
                                             "#4" : annoAtto, "#5": numeroAtto, "#6": annoAccordo, "#7": stringaCessazione,
                                             "#8" : "", "#9": "", "#10": "", "#11": "", "#12": "", "#13": "", "#14": "",
                                             "#15": "", "#16": "", "#17": "", "#18": "", "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                             "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto30, "#30": numeroAtto30]

    Map<String, Map<String,?>> annotazioneComune = ["FAENZA":[testo:testoGALLES, formula:"175-SEPTIE", variabili:mappaVariabili],
                                                    "Belluno":[testo:testoBelluno, formula:"175-SEPBEL", variabili:mappaVariabili],
                                                    "Faenza":[testo:testoFaenza, formula:"175-SEPFAE", variabili:mappaVariabili],
                                                    "Lodi":[testo:testoLodi, formula:"175-SEPLOD", variabili:mappaVariabili],
                                                    "Codigoro":[testo:testoCodigoro, formula:"175-SEPCOD", variabili:mappaVariabili],
                                                    "Valeggio":[testo:testoValeggio, formula:"175-SEPVAL", variabili:mappaVariabili],
                                                    "San Lazzaro":[testo:testoSanLazzaro, formula:"175-SEPSNL", variabili:mappaVariabileSnl],
                                                    "San Donato":[testo:testoSanDonato, formula:"175-SEPSND", variabili:mappaVariabili],
                                                    "Guastalla":[testo:testoGuastalla, formula:"175-SEPGUA", variabili:mappaVariabili],
                                                    "Trapani":[testo:testoTrapani, formula:"175-SEPTRA", variabili:mappaVariabileTra],
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
                anno: annoAtto as Integer, natura: ENaturaAtto.O,
                dataMatrimonio: DataUtils.fromStringToDate(dataAttoString), divorzio: true)

        dpaSource = new CivDatiProvenienzaAtto(dataAccordo: DataUtils.fromStringToDate(dataAccordoDivorzioString), dataAtto: DataUtils.fromStringToDate(dataAttoString),
                attoAccordo: numeroAttoAccordo as Integer, parteAccordo: parteAttoAccordo as Integer, serieAccordo: serieAttoAccordo,
                tipoDivorzio: "S", annoAccordo: annoAccordo as Integer, anno: annoAtto as Integer)
    }

    @Unroll
    def "Test per l'annotazione 175-SEPTIE - #comune"(){
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

    String estraiTestoDaMappa(Map<String, String> mappaCorrispondeteAFormula, String testoCodificato){
        String testoRisultante

        List<String> listaIndiciVariabili = testoCodificato.findAll("(#=?)[0-9]+(?=\\s)")

        for (String indice: listaIndiciVariabili){
            if (mappaCorrispondeteAFormula[indice] != "") {
                if (testoCodificato.substring(testoCodificato.indexOf(indice) - 7, testoCodificato.indexOf(indice)).contains("parte")){
                    if (mappaCorrispondeteAFormula[indice] == "1"){
                        mappaCorrispondeteAFormula[indice] = "I"
                    }
                    else if (mappaCorrispondeteAFormula[indice] == "2"){
                        mappaCorrispondeteAFormula[indice] = "II"
                    }
                }
                testoRisultante = testoCodificato.replace(indice + " ", mappaCorrispondeteAFormula[indice] + " ")
            }
            else {
                testoRisultante = testoCodificato.replace(indice + " "," ")
            }
            testoCodificato = testoRisultante
        }
        return testoRisultante
    }

}
