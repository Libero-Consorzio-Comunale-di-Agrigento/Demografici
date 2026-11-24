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
class CivAnnotazioneAttoService175SexiesSpec extends AbstractServiceSpec<CivAnnotazioneAttoService175SexiesSpec> {
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

    String nomeAvvocato1 = "nome avvocato 1"
    String cognomeAvvocato1 = "cognome avvocato 1"
    String nomeAvvocato2 = "nome avvocato 2"
    String cognomeAvvocato2 = "cognome avvocato 2"

    String dataAccordoDivorzio = "15/07/2015"

    String numeroAccordoDivorzio = "18"
    String parteAccordoDivorzio = "2"
    String serieAccordoDivorzio = "B"

    String dataAttoString = "15/02/2023"

    String numeroAtto = "2"
    String parteAtto = "1"
    String serieAtto = "A"

    String stringaCessazioneScioglimento = "scioglimento"

    String tipoScioglimento = "scioglimento"
    String annoAtto = "2023"

    String annoAtto30 = "2023"
    String numeroAtto30 = "5"

    String tipoDivorzio = "S"

    String testoGALLES = "Con convenzione di negoziazione assistita dagli avvocati #1 e #2 conclusa in data #3 , " +
            "trascritta nei registri di matrimonio di questo ufficio dello stato civile, " +
            "al n. #4 parte #5 serie #6 , e' stato concluso l'accordo di #7 del matrimonio controscritto"
    String testoBelluno = "Con convenzione di negoziazione assistita dagli avvocati #1 #8 e #9 #10 conclusa in data #2 , trascritta nei registri di " +
            "matrimonio di questo ufficio dello stato civile, al n. #3 parte #4 " +
            "serie #5 anno #7 , e' stato concluso l'accordo di #6 del matrimonio controscritto."
    String testoFaenza = "Con convenzione di negoziazione assistita dagli avvocati #1 e #2 conclusa in data #3 , " +
            "trascritta nei registri di matrimonio di questo ufficio dello stato civile, al n. #4 parte #5 " +
            "serie #6 , e' stato concluso l'accordo di #7 del matrimonio controscritto."
    String testoLodi = "Con convenzione di negoziazione assistita dagli avvocati #1 conclusa in data #2 , trascritta " +
            "nei registri di matrimonio di questo ufficio dello stato civile, al n. #3 parte #4 " +
            "serie #5 , e' stato concluso l'accordo di #6 del matrimonio controscritto."
    String testoValeggio = "Con convenzione di negoziazione assistita dagli avvocati #1 conclusa in data #2 , " +
            "trascritta nei registri di matrimonio di #7 , al n. #3 parte #4 serie #5 , " +
            "e' stato concluso l'accordo di #6 del matrimonio controscritto."
    String testoSanLazzaro = "Con convenzione di negoziazione assistita dagli avvocati #1 #2 conclusa in data #3 " +
            "trascritta nei registri di matrimonio di questo ufficio dello stato civile " +
            "al n. #4 Parte II Serie C anno #5 e' stato concluso l'accordo di #6 del matrimonio controscritto."
    String testoCodigoro = "Con convenzione di negoziazione assistita dagli avvocati #1 conclusa in data #2 , " +
            "trascritta nei registri di matrimonio di questo ufficio dello stato civile, " +
            "al n. #3 parte #4 serie #5 , e' stato concluso l'accordo di #6 del matrimonio controscritto."
    String testoSanDonato = "Con convenzione di negoziazione assistita dagli avvocati #1 conclusa in data #2 , " +
            "trascritta nei registri di matrimonio di questo ufficio dello stato civile, " +
            "al n. #3 parte #4 serie #5 , e' stato concluso l'accordo di #6 del matrimonio controscritto."
    String testoGuastalla = "Con convenzione di negoziazione assistita dagli avvocati #1 conclusa in data #2 , " +
            "trascritta nei registri di matrimonio di questo ufficio dello stato civile, " +
            "al n. #3 parte #4 serie #5 , e' stato concluso l'accordo di #6 del matrimonio controscritto."
    String testoTrapani = "Con convenzione di negoziazione assistita dagli avvocati #1 e #2  conclusa in data #3 " +
            "trascritta nei registri di matrimonio dello stato civile del Comune di #4 " +
            "al n. #5 parte 2 serie C anno #6 e' stato concluso l'accordo di #7 del matrimonio controscritto."

    Map<String, String> mappaVariabili = ["#1": nomeAvvocato1+" "+cognomeAvvocato1, "#2": nomeAvvocato2+" "+cognomeAvvocato2, "#3": dataAccordoDivorzio,
                                          "#4": numeroAtto, "#5": parteAtto, "#6": serieAtto, "#7": stringaCessazioneScioglimento,
                                          "#8": "", "#9": "", "#10": "", "#11": "", "#12": "", "#13": "", "#14": "",
                                          "#15": "", "#16": "", "#17": "", "#18": "", "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                          "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto30, "#30": numeroAtto30]

    Map<String, String> mappaVariabileFae = ["#1": nomeAvvocato1+" "+cognomeAvvocato1, "#2": nomeAvvocato2+" "+cognomeAvvocato2, "#3": dataAccordoDivorzio,
                                             "#4": numeroAtto, "#5": parteAtto, "#6": serieAtto, "#7": stringaCessazioneScioglimento,
                                             "#8": "", "#9": "", "#10": "", "#11": "", "#12": "", "#13": "", "#14": "",
                                             "#15": "", "#16": "", "#17": "", "#18": "", "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                             "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto30, "#30": numeroAtto30]

    Map<String, String> mappaVariabileBel = ["#1" : nomeAvvocato1+" "+cognomeAvvocato1, "#2": dataAccordoDivorzio, "#3": numeroAtto,
                                             "#4" : parteAtto, "#5": serieAtto, "#6": stringaCessazioneScioglimento, "#7": annoAtto,
                                             "#8" : "", "#9": nomeAvvocato2+" "+cognomeAvvocato2, "#10": "", "#11": "", "#12": "", "#13": "", "#14": "",
                                             "#15": "", "#16": "", "#17": "", "#18": "", "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                             "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto30, "#30": numeroAtto30]

    Map<String, String> mappaVariabileLodValCodGuaSnd = ["#1" : nomeAvvocato1+" "+cognomeAvvocato1, "#2": dataAccordoDivorzio, "#3": numeroAtto,
                                                         "#4" : parteAtto, "#5": serieAtto+" anno "+annoAtto, "#6": stringaCessazioneScioglimento, "#7": "",
                                                         "#8" : "", "#9": "", "#10": "", "#11": "", "#12": "", "#13": "", "#14": "",
                                                         "#15": "", "#16": "", "#17": "", "#18": "", "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                                         "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto30, "#30": numeroAtto30]

    Map<String, String> mappaVariabileSnl = ["#1" : nomeAvvocato1+" "+cognomeAvvocato1, "#2": nomeAvvocato2+" "+cognomeAvvocato2, "#3": dataAccordoDivorzio,
                                             "#4" : numeroAtto, "#5": annoAtto, "#6": stringaCessazioneScioglimento, "#7": "",
                                             "#8" : "", "#9": "", "#10": "", "#11": "", "#12": "", "#13": "", "#14": "",
                                             "#15": "", "#16": "", "#17": "", "#18": "", "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                             "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto30, "#30": numeroAtto30]

    Map<String, String> mappaVariabileTra = ["#1" : nomeAvvocato1+" "+cognomeAvvocato1, "#2": nomeAvvocato2+" "+cognomeAvvocato2, "#3": dataAccordoDivorzio,
                                             "#4" : "FAENZA", "#5": numeroAtto, "#6": annoAtto, "#7": stringaCessazioneScioglimento,
                                             "#8" : "", "#9": "", "#10": "", "#11": "", "#12": "", "#13": "", "#14": "",
                                             "#15": "", "#16": "", "#17": "", "#18": "", "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                             "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto30, "#30": numeroAtto30]

    @Shared
    List<String> listaComuni = [//"FAENZA",
                                "Belluno", "Faenza", "Lodi", "Codigoro", "Valeggio", "San Lazzaro", "San Donato", "Guastalla", "Trapani"]

    Map<String, Map<String,?>> annotazioneComune = ["FAENZA":[testo:testoGALLES, formula:"175-SEXIES", variabili:mappaVariabili],
                                                    "Belluno":[testo:testoBelluno, formula:"175-SEXBEL", variabili:mappaVariabileBel],
                                                    "Faenza":[testo:testoFaenza, formula:"175-SEXFAE", variabili:mappaVariabileFae],
                                                    "Lodi":[testo:testoLodi, formula:"175-SEXLOD", variabili:mappaVariabileLodValCodGuaSnd],
                                                    "Codigoro":[testo:testoCodigoro, formula:"175-SEXCOD", variabili:mappaVariabileLodValCodGuaSnd],
                                                    "Valeggio":[testo:testoValeggio, formula:"175-SEXVAL", variabili:mappaVariabileLodValCodGuaSnd],
                                                    "San Lazzaro":[testo:testoSanLazzaro, formula:"175-SEXSNL", variabili:mappaVariabileSnl],
                                                    "San Donato":[testo:testoSanDonato, formula:"175-SEXSND", variabili:mappaVariabileLodValCodGuaSnd],
                                                    "Guastalla":[testo:testoGuastalla, formula:"175-SEXGUA", variabili:mappaVariabileLodValCodGuaSnd],
                                                    "Trapani":[testo:testoTrapani, formula:"175-SEXTRA", variabili:mappaVariabileTra],
    ]

    String comune

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
                anno: annoAtto as Integer, natura: ENaturaAtto.O, dataMatrimonio: DataUtils.fromStringToDate(dataAttoString), divorzio: true)

        dpaSource = new CivDatiProvenienzaAtto(dataAccordo: DataUtils.fromStringToDate(dataAccordoDivorzio), dataAtto: DataUtils.fromStringToDate(dataAttoString),
                attoAccordo: numeroAccordoDivorzio as Integer, parteAccordo: parteAccordoDivorzio as Integer, serieAccordo: serieAccordoDivorzio,
                tipoDivorzio: tipoDivorzio, avvocato1: nomeAvvocato1+" "+cognomeAvvocato1, avvocato2: nomeAvvocato2+" "+cognomeAvvocato2)
    }

    @Unroll
    def "Test per l'annotazione 175-SEXIES - #comune"(){
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
