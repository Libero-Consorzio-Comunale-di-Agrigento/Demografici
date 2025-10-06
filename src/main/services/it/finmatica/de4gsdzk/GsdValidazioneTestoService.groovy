package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class GsdValidazioneTestoService {

    String bonificaTesto(String testo){
        //FIXME: montare lettura da db
        if (testo){
            List<Map<String, String>> mappaCaratteri = [[search:"′", replace:"'"],
                                                        [search:"‛", replace:"'"],
                                                        [search:"‘", replace:"'"],
                                                        [search:"’", replace:"'"],
                                                        [search:"“", replace:"\""],
                                                        [search:"‟", replace:"\""],
                                                        [search:"‴", replace:"\""],
                                                        [search:"”", replace:"\""],
                                                        [search:"\n", replace:" "],
                                                        [search:"\t", replace:" "],
                                                        [search:"–", replace:"-"]
            ]
            for (Map<String, String> elemento : mappaCaratteri) {
                testo = testo.replaceAll(elemento.search, elemento.replace)
            }
        }
        return testo
    }

    void checkWrongVar(String testo, List<String> listaVariabiliPossibili){
        if (testo) {
            List<String> listaVariabili = []
            List<String> listaVarErrate = []
            String testoDaParsare = testo
            String testoParsato = ""
            int i = testoDaParsare.indexOf(TestoUtils.parentesiApertaOdt)
            int j = testoDaParsare.indexOf(TestoUtils.parentesiChiusaOdt)
            //Fisso un limite di 25 caratteri per circoscrivere il punto
            int limit = 25
            while ((i >= 0) || (j >= 0) ) {
                int tLength = testoDaParsare.length()
                if ((i < 0) || (j < 0) || (j < i)){ // casi di errore
                    String wrongVar = null
                    if (i < 0){ // sicuramente j >= 0
                        wrongVar = (j>limit)?(testoDaParsare.substring(j-limit, j+1)):testoDaParsare.substring(j, Math.min(j+limit, tLength))
                        if (wrongVar == TestoUtils.parentesiChiusaOdt){
                            wrongVar = "Il testo termina con un carattere non ammesso"
                        }
                    } else if (j < 0){ // sicuramente i >= 0
                        wrongVar = testoDaParsare.substring(i, Math.min(i+limit, tLength))
                        if (wrongVar == TestoUtils.parentesiApertaOdt){
                            wrongVar = "Il testo termina con un carattere non ammesso"
                        }
                        j = i // sposto j per fissare il punto da cui partire con il parse successivo
                    } else  if (j < i){ // chiusa prima che aperta
                        int k = testoParsato.lastIndexOf(TestoUtils.parentesiApertaOdt)
                        if (k >= 0){
                            wrongVar = testoParsato.substring(k) + testoDaParsare.substring(0, j+1)
                        } else {
                            wrongVar = testoDaParsare.substring(j, Math.min(j+limit, tLength))
                        }
                    }
                    listaVarErrate.add(wrongVar)
                } else { //i < j ordine corretto
                    listaVariabili.add(testoDaParsare.substring(i, j+1))
                }
                testoParsato += testoDaParsare.substring(0, j+1)
                testoDaParsare = testoDaParsare.substring(j+1)
                i = testoDaParsare.indexOf(TestoUtils.parentesiApertaOdt)
                j = testoDaParsare.indexOf(TestoUtils.parentesiChiusaOdt)
            }
            for (String v : listaVariabili) {
                if (!(listaVariabiliPossibili.contains(v.toUpperCase()))) {
                    listaVarErrate.add(v)
                }
            }
            String wrongVar = listaVarErrate.join("\n ....")
            if (wrongVar){
                throw new De4gsdzkRuntimeException("Variabile/i errata/e all'interno del testo:\n ...." + wrongVar + "....")
            }
        }
    }

}
