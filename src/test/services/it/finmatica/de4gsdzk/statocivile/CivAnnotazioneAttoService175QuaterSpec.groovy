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
class CivAnnotazioneAttoService175QuaterSpec extends AbstractServiceSpec<CivAnnotazioneAttoService175QuaterSpec> {
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
    String testoDbPrimaDiChiamataFunzione

    String nomeAvvocato1 = "nomeAvvocato1"
    String cognomeAvvocato1 = "cognomeAvvocato1"

    String nomeAvvocato2 = "nomeAvvocato2"
    String cognomeAvvocato2 = "cognomeAvvocato2"

    String annoAccordo_Septie = "2018"

    String dataAttoString_Septie = "15/02/2018"

    String dataEvento = "15/02/2023"
    String numeroAtto = "2"
    String parteAtto = "2"
    String serieAtto = "C"
    String nomeConiuge1 = "nome1"
    String cognomeConiuge1 = "cognome1"
    String nomeConiuge2 = "nome2"
    String cognomeConiuge2 = "cognome2"
    String annoAtto = "2023"
    String numeroAtto30 = "5"

    String numeroAttoAccordo = "18"
    String parteAttoAccordo = "2"
    String serieAttoAccordo = "B"

    String tipoDivorzio = "S"

    String testoGALLES = "Con convenzione di negoziazione assistita dagli avvocati  #1 e #2 ,conclusa in data #3 , trascritta nei registri di " +
            "matrimonio di questo ufficio dello stato civile, al n. #4 parte #5 serie #6 , " +
            "e' stato concluso l'accordo di separazione personale tra i coniugi #7 #8 #9 e #10 #11 #12 di cui all'atto di matrimonio controscritto."
    String testoBelluno = "Con convenzione di negoziazione assistita dagli avvocati #1 #14 e #2 #15 , conclusa in data #3 , " +
            "trascritta nei registri di matrimonio di questo ufficio dello stato civile, al n. #4 parte #5 serie #6 anno #13 , e' stato concluso l'accordo di " +
            "separazione personale tra i coniugi #7 #8 #9 e #10 #11 #12 di cui all'atto di matrimonio controscritto."
    String testoFaenza = "Con convenzione di negoziazione assistita dagli avvocati  #1 e #2 ,conclusa in data #3 , trascritta nei registri di matrimonio " +
            "dell' ufficio dello stato civile del Comune di Faenza, al n. #4 parte #5 serie #6 , e' stato concluso l'accordo " +
            "di separazione personale tra i coniugi #7 #8 #9 e #10 #11 #12 di cui all'atto di matrimonio controscritto."
    String testoLodi = "Con convenzione di negoziazione assistita dagli avvocati  #1 e #2 , conclusa in data #3 , trascritta nei registri di matrimonio " +
            "di questo ufficio dello stato civile, al n. #4 parte #5 serie #6 , e' stato " +
            "concluso l'accordo di separazione personale tra i coniugi #7 #8 #9 e #10 #11 #12 di cui all'atto di matrimonio controscritto."
    String testoValeggio = "Con convenzione di negoziazione assistita dagli avvocati  #1 e #2 ,conclusa in data #3 , trascritta nei registri " +
            "di matrimonio di questo ufficio dello stato civile, al n. #4 parte #5 serie #6 , " +
            "e' stato concluso l'accordo di separazione personale tra i coniugi #7 #8 #9 e #10 #11 #12 di cui all'atto di matrimonio controscritto."
    String testoSanLazzaro = "Con convenzione di negoziazione assistita dagli avvocati #1 #2 conclusa in data #3 trascritta nei registri " +
            "di matrimonio di questo ufficio dello stato civile al n. #4 Parte II Serie C anno #5 e' " +
            "stato concluso l'accordo di separazione personale tra i coniugi #6 #7 di cui all'atto di matrimonio controscritto."
    String testoCodigoro = "Con convenzione di negoziazione assistita dagli avvocati  #1 e #2 ,conclusa in data #3 , trascritta nei registri " +
            "di matrimonio di questo ufficio dello stato civile, al n. #4 parte #5 serie #6 , e' stato concluso " +
            "l'accordo di separazione personale tra i coniugi #7 #8 #9 e #10 #11 #12 di cui all'atto di matrimonio controscritto."
    String testoSanDonato = "Con convenzione di negoziazione assistita dagli avvocati  #1 e #2 ,conclusa in data #3 , trascritta " +
            "nei registri di matrimonio di questo ufficio dello stato civile, al n. #4 parte #5 serie #6 , e' stato concluso l'accordo " +
            "di separazione personale tra i coniugi #7 #8 #9 e #10 #11 #12 di cui all'atto di matrimonio controscritto."
    String testoGuastalla = "Con convenzione di negoziazione assistita dagli avvocati  #1 e #2 ,conclusa in data #3 , trascritta nei registri di matrimonio di " +
            "questo ufficio dello stato civile, al n. #4 parte #5 serie #6 , " +
            "e' stato concluso l'accordo di separazione personale tra i coniugi #7 #8 #9 e #10 #11 #12 di cui all'atto di matrimonio controscritto. "
    String testoTrapani = "Con convenzione di negoziazione assistita dagli avvocati #1 e #2  conclusa in data #3 trascritta nei registri " +
            "di matrimonio dello stato civile del Comune di #4 al n. #5 parte 2 serie C anno #6 " +
            "e' stato concluso l'accordo di separazione personale tra i coniugi #7 e #8 di cui all'atto di matrimonio controscritto"

    Map<String, String> mappaVariabili = ["#1": nomeAvvocato1+" "+cognomeAvvocato1, "#2": nomeAvvocato2+" "+cognomeAvvocato2, "#3": dataEvento, "#4": numeroAttoAccordo,
                                          "#5": parteAttoAccordo, "#6": serieAttoAccordo, "#7": cognomeConiuge1+" "+nomeConiuge1,
                                          "#8": "", "#9": "", "#10": cognomeConiuge2+" "+nomeConiuge2,
                                          "#11": "", "#12": "", "#13": "", "#14": "", "#15": "", "#16": "", "#17": "", "#18": "",
                                          "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                          "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto, "#30": numeroAtto30]
    Map<String, String> mappaVariabileBel = ["#1": nomeAvvocato1+" "+cognomeAvvocato1, "#2": nomeAvvocato2+" "+cognomeAvvocato2, "#3": dataEvento, "#4": numeroAttoAccordo,
                                             "#5": parteAttoAccordo, "#6": serieAttoAccordo, "#7": cognomeConiuge1+" "+nomeConiuge1,
                                             "#8": "", "#9": "", "#10": cognomeConiuge2+" "+nomeConiuge2,
                                             "#11": "", "#12": "", "#13": annoAtto, "#14": "", "#15": "", "#16": "", "#17": "", "#18": "",
                                             "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                             "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto, "#30": numeroAtto30]
    Map<String, String> mappaVariabileFaeLodValCodSndGua = ["#1": nomeAvvocato1+" "+cognomeAvvocato1, "#2": nomeAvvocato2+" "+cognomeAvvocato2, "#3":dataEvento, "#4": numeroAttoAccordo,
                                                            "#5": parteAttoAccordo, "#6": serieAttoAccordo, "#7": cognomeConiuge1+" "+nomeConiuge1,
                                                            "#8": "", "#9": "", "#10": cognomeConiuge2+" "+nomeConiuge2,
                                                            "#11": "", "#12": "", "#13": "", "#14": "", "#15": "", "#16": "", "#17": "", "#18": "",
                                                            "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                                            "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto, "#30": numeroAtto30]
    Map<String, String> mappaVariabileSnl = ["#1": nomeAvvocato1+" "+cognomeAvvocato1, "#2": nomeAvvocato2+" "+cognomeAvvocato2, "#3": dataEvento, "#4": numeroAtto,
                                             "#5": annoAtto, "#6": cognomeConiuge1+" "+nomeConiuge1, "#7": cognomeConiuge2+" "+nomeConiuge2, "#8": "", "#9": "", "#10": "",
                                             "#11": "", "#12": "", "#13": "", "#14": "", "#15": "", "#16": "", "#17": "", "#18": "",
                                             "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                             "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto, "#30": numeroAtto30]
    Map<String, String> mappaVariabileTra = ["#1": nomeAvvocato1+" "+cognomeAvvocato1, "#2": nomeAvvocato2+" "+cognomeAvvocato2, "#3": dataEvento, "#4": "FAENZA",
                                             "#5": numeroAtto, "#6": annoAtto, "#7": cognomeConiuge1+" "+nomeConiuge1, "#8": cognomeConiuge2+" "+nomeConiuge2,
                                             "#9": "", "#10": cognomeConiuge2+" "+nomeConiuge2,
                                             "#11": "", "#12": "", "#13": "", "#14": "", "#15": "", "#16": "", "#17": "", "#18": "",
                                             "#19": "", "#20": "", "#21": "", "#22": "", "#23": "", "#24": "",
                                             "#25": "", "#26": "", "#27": "", "#28": "", "#29": annoAtto, "#30": numeroAtto30]

    Map<String, Map<String,?>> annotazioneComune = ["FAENZA":[testo:testoGALLES, formula:"175-QUATER", variabili:mappaVariabili],
                                                    "Belluno":[testo:testoBelluno, formula:"175-QUABEL", variabili:mappaVariabileBel],
                                                    "Faenza":[testo:testoFaenza, formula:"175-QUAFAE", variabili:mappaVariabileFaeLodValCodSndGua],
                                                    "Lodi":[testo:testoLodi, formula:"175-QUALOD", variabili:mappaVariabileFaeLodValCodSndGua],
                                                    "Codigoro":[testo:testoCodigoro, formula:"175-QUACOD", variabili:mappaVariabileFaeLodValCodSndGua],
                                                    "Valeggio":[testo:testoValeggio, formula:"175-QUAVAL", variabili:mappaVariabileFaeLodValCodSndGua],
                                                    "San Lazzaro":[testo:testoSanLazzaro, formula:"175-QUASNL", variabili:mappaVariabileSnl],
                                                    "San Donato":[testo:testoSanDonato, formula:"175-QUASND", variabili:mappaVariabileFaeLodValCodSndGua],
                                                    "Guastalla":[testo:testoGuastalla, formula:"175-QUAGUA", variabili:mappaVariabileFaeLodValCodSndGua],
                                                    "Trapani":[testo:testoTrapani, formula:"175-QUATRA", variabili:mappaVariabileTra],
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

        attoSource = new CivMatrimonio(atto: numeroAtto as Integer, parte: parteAtto as Integer, serie: serieAtto, nome1: nomeConiuge1,
                cognome1: cognomeConiuge1, nome2: nomeConiuge2, cognome2: cognomeConiuge2, anno: annoAtto as Integer,
                natura: ENaturaAtto.O, dataMatrimonio: DataUtils.fromStringToDate(dataEvento), divorzio: true)

        dpaSource = new CivDatiProvenienzaAtto(tipoDivorzio: tipoDivorzio, annoAccordo: annoAccordo_Septie as Integer, avvocato1: nomeAvvocato1+" "+cognomeAvvocato1,
                avvocato2: nomeAvvocato2+" "+cognomeAvvocato2, parteAccordo: parteAttoAccordo as Integer, numeroAccordo: numeroAttoAccordo as Integer,
                serieAccordo: serieAttoAccordo)
    }

    @Unroll
    def "Test per l'annotazione 175-QUATER - #comune"(){
        given:

        when:
        ((CivMatrimonio) attoSource).descrizioneComuneMatrimonio = comune

        Boolean variabiliVuoteSuCivnfa = gestioneVariabiliOld(annotazioneComune[comune].formula)

        testoDb = gsdService.decodificaTestoAnnotazione(attoSource.getTipoAtto(), annotazioneComune[comune].formula, attoSource, dpaSource, 1)?.trim()?.replaceAll(" +", " ")
        testoAtteso = estraiTestoDaMappa(annotazioneComune[comune].variabili as Map<String, String>, annotazioneComune[comune].testo as String).trim().replaceAll(" +", " ")

        then:
        testoDb == testoAtteso || (testoDb != testoAtteso && variabiliVuoteSuCivnfa)

        where:
        i << (0..(listaComuni.size() - 1))
        comune = listaComuni[i]
    }

    String estraiTestoDaMappa(Map<String, String> mappaCorrispondeteAFormula, String testoCodificato) {
        String testoRisultante

        List<String> listaIndiciVariabili = testoCodificato.findAll("(#=?)[0-9]+(?=\\s)")

        for (String indice: listaIndiciVariabili) {
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
