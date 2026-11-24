package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.IAttoAnsc
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAtto
import it.finmatica.de4gsdzk.statocivile.CivFormulaTestoLibero

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta as getEtichetta
import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichettaEnum

class TestoUtils {

    public static final String aCapo = "\n"
    public static final String spazio = " "
    public static final String cancelletto = "#"
    public static final String carattereRiempitivo = "-"
    public static final String parentesiApertaOdt = "<"
    public static final String parentesiChiusaOdt = ">"

    static final int maxGeneralitaLength = 32

    public static final String formatoA4 = "A4"
    public static final String formatoA3 = "A3"
    public static final String formatoCustom = "FC"

    static String fillCharacter(String testo, String character, int limit) {
        String ret = testo
        if (testo.length() <= limit) {
            ret = ret.padRight(limit, character)
        }
        return ret
    }

    static String cleanCharacter(String testo, String character) {
        String ret = testo
        if ((ret ?: "") != "") {
            int i = ret.length()
            while (i >= 0) {
                i--
                if (ret[i] != character) {
                    break
                }
            }
            ret = ret.substring(0, ++i)
        }
        return ret
    }

    static String formattaTesto(String testo, int maxRowCharacters) {
        String formattedTesto = ""
        String parsedTesto = (testo ?: "")
        while ((parsedTesto ?: "") != "") {
            if (parsedTesto.length() > maxRowCharacters) {
                Boolean searchSpazio = Boolean.TRUE
                int aCapoPosition = parsedTesto.indexOf(aCapo)
                if ((aCapoPosition >= 0) && (aCapoPosition <= maxRowCharacters)) {
                    int subLen = aCapoPosition + 1
                    formattedTesto += parsedTesto.substring(0, subLen) // Tiro su anche il carattere a capo
                    parsedTesto = ((parsedTesto.length() >= subLen) ? parsedTesto.substring(subLen) : "")
                    searchSpazio = Boolean.FALSE
                }
                if (searchSpazio) {
                    // Mi fermo alla posizione antecedente il massimo numero di caratteri ammessi per caricare anche il
                    // carattere spazio e non sforare di un'unità la massima lunghezza ammessa
                    String frammento = parsedTesto.substring(0, (maxRowCharacters - 1))
                    int spacePosition = frammento.lastIndexOf(spazio)
                    if (spacePosition >= 0) {
                        int subLen = spacePosition + 1
                        formattedTesto += parsedTesto.substring(0, subLen) // Tiro su anche il carattere spazio
                        formattedTesto += ((parsedTesto.length() >= subLen) ? aCapo : "")
                        parsedTesto = ((parsedTesto.length() >= subLen) ? parsedTesto.substring(subLen) : "")
                    } else {
                        if (parsedTesto.length() >= maxRowCharacters) {
                            //FIXME: tronco o restituisco testo vuoto?
                            int subLen = maxRowCharacters + 1
                            formattedTesto += parsedTesto.substring(0, maxRowCharacters)
                            formattedTesto += ((parsedTesto.length() >= subLen) ? aCapo : "")
                            parsedTesto = ((parsedTesto.length() >= subLen) ? parsedTesto.substring(subLen) : "")
                        } else {
                            formattedTesto += parsedTesto
                            parsedTesto = ""
                        }
                    }
                }
            } else {
                formattedTesto += parsedTesto
                parsedTesto = ""
            }
        }
        return formattedTesto
    }

    static Map aggiungiTogliCarattere(Boolean togli, String carattere, String testo, int maxRowCharacters, int maxRows) {
        String finalTesto = ""
        String parsedTesto = ""
        StringBuilder aggiunta = new StringBuilder("")
        if (togli) {
            //Devo togliere
            parsedTesto = (testo ?: "")
            StringBuilder cleanedTesto = new StringBuilder("")
            while ((parsedTesto ?: "") != "") {
                int aCapoPosition = parsedTesto.indexOf(aCapo)
                String frammento = ""
                if (aCapoPosition >= 0) {
                    frammento = cleanCharacter(parsedTesto.substring(0, aCapoPosition), carattere)
                    cleanedTesto.append(frammento)
                    cleanedTesto.append(aCapo)
                    parsedTesto = ((parsedTesto.length() >= (aCapoPosition + 1)) ? parsedTesto.substring(aCapoPosition + 1) : "")
                } else {
                    frammento = cleanCharacter(parsedTesto, carattere)
                    cleanedTesto.append(frammento)
                    parsedTesto = ""
                }
            }
            finalTesto = cleanedTesto.toString()
        } else {
            //Devo aggiungere
            parsedTesto = formattaTesto((testo ?: ""), maxRowCharacters)
            StringBuilder filledTesto = new StringBuilder("")
            Boolean continua = ((parsedTesto ?: "") != "")
            while (continua) {
                int aCapoPosition = parsedTesto.indexOf(aCapo)
                StringBuilder frammento = new StringBuilder("")
                if (aCapoPosition >= 0) {
                    frammento.append(fillCharacter(parsedTesto.substring(0, aCapoPosition), carattere, maxRowCharacters))
                    filledTesto.append(frammento.toString())
                    if (parsedTesto.length() >= (aCapoPosition + 1)) {
                        filledTesto.append(aCapo)
                        parsedTesto = parsedTesto.substring(aCapoPosition + 1)
                    } else {
                        continua = Boolean.FALSE
                    }
                } else {
                    frammento.append(fillCharacter(parsedTesto, carattere, maxRowCharacters))
                    filledTesto.append(frammento.toString())
                    continua = Boolean.FALSE
                }
            }
            Map m = calcolaRighe(filledTesto.toString(), maxRowCharacters, Boolean.TRUE)
            int totRighe = m["totRighe"]
            if (totRighe < maxRows) {
                for (int i = 0; i < (maxRows - totRighe); i++) {
                    aggiunta.append(aCapo)
                    aggiunta.append(fillCharacter("", carattere, maxRowCharacters))
                }
            }
            finalTesto = filledTesto.toString()
        }
        return [testo: finalTesto, aggiunta: aggiunta.toString()]
    }

    static Map getFrammentiXRichiamo(List<CivFormulaTestoLibero> ftliLista, int maxRowCharacters) {
        int lSize = ftliLista.size()
        Map mframmenti = [:]
        for (int i = 0; i < lSize; i++) {
            CivFormulaTestoLibero f = ftliLista[i]
            Boolean isLastItem = (i == (lSize - 1))
            CivFormulaTestoLibero fNext = (isLastItem ? null : ftliLista[i + 1])
            mframmenti[f.richiamo] = (mframmenti[f.richiamo] ?: "") + (f.testo ?: "")
            StringBuilder charToAdd = new StringBuilder("")
            if (f.getACapo()) {
                charToAdd.append(aCapo)
            } else {
                charToAdd.append((isLastItem ? "" : " "))
            }
            if (f.numeroRighe && (isLastItem || ((!isLastItem) && (fNext?.richiamo.compareTo(f.richiamo) != 0)))) {
                StringBuilder checkTesto = new StringBuilder("")
                checkTesto.append(formattaTesto(mframmenti[f.richiamo], maxRowCharacters))
                Map m = calcolaRighe(checkTesto.toString(), maxRowCharacters, Boolean.FALSE)
                int righeFrammento = m["totRighe"] + ((m["totRighe"] == 0) ? 1 : 0)
                if (righeFrammento < f.numeroRighe) {
                    for (int j = 0; j < (f.numeroRighe - righeFrammento); j++) {
                        checkTesto.append(aCapo)
                    }
                }
                mframmenti[f.richiamo] = checkTesto.toString()
            }
            mframmenti[f.richiamo] += charToAdd.toString()
        }
        return mframmenti
    }

    static Map getFrammentiNonFormattatiXRichiamo(List<CivFormulaTestoLibero> ftliLista) {
        int lSize = ftliLista.size()
        Map mframmenti = [:]
        for (int i = 0; i < lSize; i++) {
            CivFormulaTestoLibero f = ftliLista[i]
            Boolean isLastItem = (i == (lSize - 1))
            mframmenti[f.richiamo] = (mframmenti[f.richiamo] ?: "") + (f.testo ?: "")
            StringBuilder charToAdd = new StringBuilder("")
            if (f.getACapo()) {
                charToAdd.append(aCapo)
            } else {
                charToAdd.append((isLastItem ? "" : " "))
            }
            mframmenti[f.richiamo] += charToAdd.toString()
        }
        return mframmenti
    }

    /* Calcola il numero di righe tenendo conto del numero massimo di caratteri ammessi per ogni riga
    return:
     -1 se un carattere a capo casca oltre il numero massimo di caratteri ammessi per riga
     -2 se riga di lunghezza superiore al massimo consentito
    */

    static Map calcolaRighe(String testo, int maxRowCharacters, Boolean checkFinalCharPosition = Boolean.TRUE) {
        Map m = [:]
        String parsedTesto = testo
        int totRighe = 0
        for (; ((parsedTesto ?: "") != "");) {
            int aCapoPosition = parsedTesto.indexOf(aCapo)
            if (aCapoPosition >= 0) {
                totRighe++
                if ((checkFinalCharPosition && (aCapoPosition == maxRowCharacters)) || ((!checkFinalCharPosition) && (aCapoPosition <= maxRowCharacters))) {
                    int subLen = aCapoPosition + 1
                    if (parsedTesto.length() > subLen) {
                        parsedTesto = parsedTesto.substring(subLen)
                        continue
                    }
                    if (parsedTesto.length() == subLen) {
                        totRighe = totRighe + ((parsedTesto[subLen - 1] == aCapo) ? 1 : 0)
                        break
                    }
                } else {
                    totRighe = -1
                    String riga = ((parsedTesto.length() >= maxRowCharacters) ? (parsedTesto.substring(0, maxRowCharacters) + ".....") : parsedTesto)
                    m['riga'] = riga
                    break
                }
            } else {
                if (parsedTesto.length() <= maxRowCharacters) {
                    totRighe++
                } else {
                    totRighe = -2
                    String riga = ((parsedTesto.length() >= maxRowCharacters) ? (parsedTesto.substring(0, maxRowCharacters) + ".....") : parsedTesto)
                    m["riga"] = riga
                }
                break
            }
        }
        m["totRighe"] = totRighe
        return m
    }

    static int calcolaRigheA4(String testo, int maxRowCharacters) {
        int numRighe = 0
        // Tento un calcolo più accurato; se non funziona, faccio una stima più approssimativa
        String t = formattaTesto(testo, maxRowCharacters)
        Map m = calcolaRighe(t, maxRowCharacters, Boolean.FALSE)
        numRighe = m["totRighe"]
        if (numRighe <= 0) {
            numRighe = Math.round((testo?:"").length()/maxRowCharacters) + (testo?:"").split(aCapo)?.size()
        }
        return numRighe
    }

    static String getParteRomana(int parte) {
        switch (parte) {
            case 1:
                return "I"
                break
            case 2:
                return "II"
                break
        }
        return null
    }

    static String getTestoEtichettaCompleto(CivAnnotazioneAtto annotazioneAtto, String formato, String dataFirma, String attiLi, String dataReg){
        // refs #61786
        // 'S', abilita l'aggiunta di DATA e FIRMA in calce al testo dell'annoazione.
        // 'D', abilita la sola aggiunta della DATA.
        // 'F', abilita la sola aggiunta della FIRMA
        String testoAttiLi = (attiLi?.trim()?(attiLi?.trim() + spazio) : "") + "lì" + spazio + dataReg
        String testoFirma = "L'Ufficiale di Stato Civile"

        if (dataFirma == "S"){
            if (formato == formatoA4){
                return annotazioneAtto.testoAtto
            } else {
                return annotazioneAtto.testo + aCapo + testoAttiLi + aCapo + testoFirma
            }
        }
        if (dataFirma == "D"){
            return annotazioneAtto.testo + aCapo + testoAttiLi
        }
        if (dataFirma == "F"){
            return annotazioneAtto.testo + aCapo + testoFirma
        }
        return annotazioneAtto.testo
    }

    static String getDescrizioneAtto(CivAttoBaseDomain atto, Map<String, String> etichette, String codiceIstat, Boolean anscIntestazioneOn=Boolean.FALSE){
        String tipoAttoLabel = getDescrizioneTipoAtto(atto, etichette)
        StringBuilder d = new StringBuilder(tipoAttoLabel)
        if ( anscIntestazioneOn && (atto instanceof IAttoAnsc) && (atto.numeroUnico != null) ) {
            d.append(aCapo)
            d.append("ANNO")
            d.append(spazio)
            d.append(atto.anno.toString())
            d.append(" - ")
            d.append("NUMERO COMUNALE")
            d.append(spazio)
            d.append(atto.numeroUnico.toString())
            d.append("-")
            d.append((codiceIstat?:""))
        } else {
            if (atto.hasParte() && (atto.parte != null)) {
                d.append(" - ")
                d.append(getEtichetta(etichette, Etichette.getEtichetta("Parte")).toUpperCase())
                d.append(spazio)
                d.append(getParteRomana(atto.parte.intValue()))
            }
            if (atto.hasSerie() && ((atto.serie ?: "") != "")) {
                d.append(" - ")
                d.append(getEtichetta(etichette, Etichette.getEtichetta("Serie")).toUpperCase())
                d.append(spazio)
                d.append(atto.serie.toUpperCase())
            }
            d.append(aCapo)
            d.append('N. ')
            d.append(atto.atto.toString())
        }
        return d.toString()
    }

    static String getDescrizioneTipoAtto(CivAttoBaseDomain atto, Map<String, String> etichette){
        return getEtichettaEnum(etichette, atto.getTipoAttoEnum()).toUpperCase()
    }

    static String getNomeReportAtto(CivAttoBaseDomain atto, Boolean isCia){
        return getNomeReportAttoSenzaEstensione(atto, isCia) + "." + ETipoFile.PDF.estensione
    }

    static String getNomeReportAttoSenzaEstensione(CivAttoBaseDomain atto, Boolean isCia){
        return atto.idAtto + (isCia?"_CIA":"")
    }

    static boolean checkAcapo(String testo){
        String testoDaControllare = (testo?:"")
        if (testoDaControllare.contains(aCapo)){
            return true
        }
        return false
    }

    static boolean isVuoto(String testo){
        return ( (testo?:"") == "")
    }

}