package it.finmatica.de4gsdzk.utils

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanza
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.statocivile.*

@Slf4j
class FormulaUtils {

    public static final String FORMULA_TESTO_LIBERO = "formulaTestoLibero"

    public static final String FORMULA_TESTATA_TRASCRIZIONE = "formulaTestataTrascrizione"
    public static final String FORMULA_TESTATA = "formulaTestata"
    public static final String FORMULA_DICHIARANTE_FISSA = "formulaDichiaranteFissa"
    public static final String FORMULA_DICHIARANTE = "formulaDichiarante"
    public static final String FORMULA_FILIAZIONE_FISSA = "formulaFiliazioneFissa"
    public static final String FORMULA_FILIAZIONE = "formulaFiliazione"
    public static final String FORMULA_PRESENTAZIONE = "formulaPresentazione"
    public static final String FORMULA_PARTO_PLURIMO = "formulaPartoPlurimo"
    public static final String FORMULA_STATO_NASCITA = "formulaStatoNascita"
    public static final String FORMULA_CIRCOSTANZE_PARTICOLARI = "formulaCircostanzeParticolari"
    public static final String FORMULA_CHIUSURA = "formulaChiusura"
    public static final String FORMULA_DATI_MATRIMONIO = "formulaDatiMatrimonio"
    public static final String FORMULA_SPOSI = "formulaSposi"
    public static final String FORMULA_RICHIESTA_FISSA = "formulaRichiestaFissa"
    public static final String FORMULA_RICHIESTA = "formulaRichiesta"
    public static final String FORMULA_TESTIMONI = "formulaTestimoni"
    public static final String FORMULA_DOCUMENTI_FISSA = "formulaDocumentiFissa"
    public static final String FORMULA_DOCUMENTI = "formulaDocumenti"
    public static final String FORMULA_DOCUMENTI_ALTRO = "formulaDocumentiAltro"
    public static final String FORMULA_PUBBLICAZIONI_FISSA = "formulaPubblicazioniFissa"
    public static final String FORMULA_PUBBLICAZIONI = "formulaPubblicazioni"
    public static final String FORMULA_MATRIMONIO_CONCORDATARIO = "formulaMatrimonioConcordatario"
    public static final String FORMULA_AMMISSIONE_OLTRE_IMPEDIMENTI = "formulaAmmissioneOltreImpedimenti"
    public static final String FORMULA_RICONOSCIMENTO_FIGLI = "formulaRiconoscimentoFigli"
    public static final String FORMULA_SCELTA_COGNOME = "formulaSceltaCognome"
    public static final String FORMULA_REGIME_PATRIMONIALE = "formulaRegimePatrimoniale"
    public static final String FORMULA_FIRMA = "formulaFirma"
    public static final String FORMULA_MARGINE_MINISTRO = "formulaMargineMinistro"
    public static final String FORMULA_MARGINE_TR1 = "formulaMargineTr1"
    public static final String FORMULA_MARGINE_TR2 = "formulaMargineTr2"
    public static final String FORMULA_MARGINE_CONVENZIONI = "formulaMargineConvenzioni"
    public static final String FORMULA_MARGINE_LIBRETTO = "formulaMargineLibretto"
    public static final String FORMULA_MARGINE_SENTENZA = "formulaMargineSentenza"
    public static final String FORMULA_MARGINE_NASCITA = "formulaMargineNascita"
    public static final String FORMULA_MARGINE_COGNOME_1 = "formulaMargineCognome1"
    public static final String FORMULA_MARGINE_COGNOME_2 = "formulaMargineCognome2"
    public static final String FORMULA_RICHIEDENTI_FISSA = "formulaRichiedentiFissa"
    public static final String FORMULA_RICHIEDENTI = "formulaRichiedenti"
    public static final String FORMULA_CONTRAENTI = "formulaContraenti"
    public static final String FORMULA_DATI_DECESSO = "formulaDatiDecesso"
    public static final String FORMULA_CONGIUNTI = "formulaCongiunti"
    public static final String FORMULA_DATI_INTEGRATIVI = "formulaDatiIntegrativi"
    public static final String FORMULA_APOSTILLE = "formulaApostille"

    static CivFormulaTestoLibero getFormula(List<CivFormulaTestoLibero> formule, String propertyName){
        CivFormulaTestoLibero formula = null
        for (CivFormulaTestoLibero f: formule){
            if (f."$propertyName"){
                log.info("Recuperata formula ${propertyName} ")
                formula = f
                break
            }
        }
        return formula
    }

    //////////////////////////////////// TESTO LIBERO ////////////////////////////////////////

    static Integer getRichiamoTestoLibero(){
        return new Integer(90)
    }

    static Integer getProgressivoGenericoTestoLiberoGreaterThen(){
        return new Integer(0)
    }

    ///////////////////////////////// TESTATA TRASCRIZIONE ///////////////////////////////////

    static Integer getRichiamoTestataTrascrizione(){
        return new Integer(0)
    }

    static Integer getProgressivoTestataTrascrizione(){
        return new Integer(0)
    }

    ////////////////////////////////////// TESTATA //////////////////////////////////////////

    static Integer getRichiamoTestata(){
        return new Integer(1)
    }

    static Integer getProgressivoTestata(){
        return new Integer(0)
    }

    ////////////////////////////////////// DATI MATRIMONIO //////////////////////////////////////

    static Integer getRichiamoDatiMatrimonio(){
        return new Integer(2)
    }

    static Integer getProgressivoDatiMatrimonio(){
        return new Integer(0)
    }

    /////////////////////////////////////////// SPOSI ///////////////////////////////////////////

    static Integer getRichiamoSposi(){
        return new Integer(3)
    }

    static Integer getProgressivoSposi(){
        return new Integer(0)
    }

    ///////////////////////////////////////// CONTRAENTI /////////////////////////////////////////

    static Integer getRichiamoContraenti(){
        return new Integer(3)
    }

    static Integer getProgressivoContraenti(){
        return new Integer(1)
    }

    ///////////////////////////////////////// RICHIEDENTI /////////////////////////////////////////

    static Integer getRichiamoRichiedenti(){
        return new Integer(3)
    }

    static Integer getProgressivoRichiedenti(){
        return new Integer(1)
    }

    static Integer getRichiamoRichiedentiFisso(){
        return getRichiamoRichiedenti()
    }

    static Integer getProgressivoRichiedentiFisso(){
        return new Integer(0)
    }

    //////////////////////////////////////// RICHIESTA ///////////////////////////////////////////

    static Integer getRichiamoRichiesta(){
        return new Integer(4)
    }

    static Integer getProgressivoRichiestaFissa(){
        return new Integer(0)
    }

    static Integer getProgressivoRichiesta(){
        return new Integer(1)
    }

    //////////////////////////////////////// TESTIMONI ///////////////////////////////////////////

    static Integer getRichiamoTestimoni(){
        return new Integer(5)
    }

    static Integer getProgressivoTestimoni(){
        return new Integer(0)
    }

    //////////////////////////////////////// DATI DECESSO ///////////////////////////////////////////

    static Integer getRichiamoDatiDecesso(){
        return new Integer(5)
    }

    static Integer getProgressivoDatiDecesso(){
        return new Integer(0)
    }

    ////////////////// DOCUMENTI - DOCUMENTI FORMULA FISSA - DOCUMENTI ALTRO ///////////////////////

    static Integer getRichiamoDocumentiFisso(){
        return getRichiamoDocumenti()
    }

    static Integer getProgressivoDocumentiFisso(){
        return new Integer(0)
    }

    static Integer getRichiamoDocumenti(){
        return new Integer(6)
    }

    static Integer getProgressivoDocumenti(){
        return new Integer(1)
    }

    static Integer getRichiamoDocumentiAltro(){
        return getRichiamoDocumenti()
    }

    static Integer getProgressivoDocumentiAltro(){
        return new Integer(2)
    }

    //////////////////////////////////////// CONGIUNTI ///////////////////////////////////////////

    static Integer getRichiamoCongiunti(){
        return new Integer(6)
    }

    static Integer getProgressivoCongiunti(){
        return new Integer(0)
    }

    //////////////////////////// PUBBLICAZIONI - PUBBLICAZIONI FORMULA FISSA ////////////////////////

    static Integer getRichiamoPubblicazioniFisso(){
        return getRichiamoPubblicazioni()
    }

    static Integer getProgressivoPubblicazioniFisso(){
        return new Integer(0)
    }

    static Integer getRichiamoPubblicazioni(){
        return new Integer(12)
    }

    static Integer getProgressivoPubblicazioni(){
        return new Integer(1)
    }

    //////////////////////////////// MATRIMONIO CONCORDATARIO /////////////////////////////////

    static Integer getRichiamoMatrimonioConcordatario(){
        return new Integer(13)
    }

    static Integer getProgressivoMatrimonioConcordatario(){
        return new Integer(1)
    }

    //////////////////////////////// AMMISSIONE NONOSTANTE IMPEDIMENTI /////////////////////////////////

    static Integer getRichiamoAmmissioneOltreImpedimenti(){
        return new Integer(7)
    }

    static Integer getProgressivoAmmissioneOltreImpedimenti(){
        return new Integer(1)
    }

    //////////////////////////////// RICONOSCIMENTO FIGLI /////////////////////////////////

    static Integer getRichiamoRiconoscimentoFigli(){
        return new Integer(8)
    }

    static Integer getProgressivoRiconoscimentoFigli(){
        return new Integer(1)
    }

    //////////////////////////////// SCELTA COGNOME /////////////////////////////////

    static Integer getRichiamoSceltaCognome(){
        return new Integer(8)
    }

    static Integer getProgressivoSceltaCognome(){
        return new Integer(1)
    }

    //////////////////////////////// REGIME PATRIMONIALE /////////////////////////////////

    static Integer getRichiamoRegimePatrimoniale(){
        return new Integer(9)
    }

    static Integer getProgressivoRegimePatrimoniale(){
        return new Integer(1)
    }

    //////////////////////////// DICHIARANTE - DICHIARANTE FORMULA FISSA ///////////////////////////

    static Integer getRichiamoDichiaranteFisso(){
        return getRichiamoDichiarante()
    }

    static Integer getProgressivoDichiaranteFisso(){
        return new Integer(0)
    }

    static Integer getRichiamoDichiarante(){
        return new Integer(4)
    }

    static Integer getProgressivoGenericoDichiaranteGreaterThen(){
        return new Integer(0)
    }

    ///////////////////////////// FILIAZIONE - FILIAZIONE FORMULA FISSA //////////////////////////

    static Integer getRichiamoFiliazioneFisso(){
        return getRichiamoFiliazione()
    }

    static Integer getProgressivoFiliazioneFisso(){
        return new Integer(0)
    }

    static Integer getRichiamoFiliazione(){
        return new Integer(5)
    }

    static Integer getProgressivoGenericoFiliazioneGreaterThen(){
        return new Integer(0)
    }

    ///////////////////////////////////// PRESENTAZIONE ////////////////////////////////////

    static Integer getRichiamoPresentazione(){
        return new Integer(6)
    }

    /////////////////////////////////// PARTO PLURIMO //////////////////////////////////////

    static Integer getRichiamoPartoPlurimo(){
        return new Integer(9)
    }

    static Integer getProgressivoPartoPlurimo(){
        return new Integer(1)
    }

    //////////////////////////////////// STATO NASCITA /////////////////////////////////////

    static Integer getRichiamoStatoNascita(){
        return new Integer(9)
    }

    static Integer getProgressivoStatoNascita(){
        return new Integer(2)
    }

    /////////////////////////////// CIRCOSTANZE PARTICOLARI ////////////////////////////////

    static Integer getRichiamoCircostanzeParticolari(){
        return new Integer(9)
    }

    static Integer getProgressivoGenericoCircostanzeParticolariGreaterThen(){
        return new Integer(2)
    }

    /////////////////////////////// DATI INTEGRATIVI ////////////////////////////////

    static Integer getRichiamoDatiIntegrativi(){
        return new Integer(9)
    }

    static Integer getProgressivoDatiIntegrativi(){
        return new Integer(1)
    }

    /////////////////////////////// APOSTILLE ////////////////////////////////

    static Integer getRichiamoApostille(){
        return new Integer(9)
    }

    static Integer getProgressivoGenericoApostilleGreaterThen(){
        return new Integer(2)
    }

    ////////////////////////////////////// CHIUSURA ////////////////////////////////////////

    static Integer getRichiamoChiusura(){
        return new Integer(10)
    }

    ////////////////////////////////////// FIRMA ///////////////////////////////////////////

    static Integer getRichiamoFirma(){
        return new Integer(99)
    }

    static Integer getProgressivoFirma(){
        return new Integer(0)
    }

    ////////////////////////////////////// MARGINE ///////////////////////////////////////////

    static Integer getRichiamoMargine(){
        return new Integer(98)
    }

    static Integer getProgressivoMargineNascita(){
        return new Integer(0)
    }

    static Integer getProgressivoMargineMinistro(){
        return new Integer(1)
    }

    static Integer getProgressivoMargineTr1(){
        return new Integer(2)
    }

    static Integer getProgressivoMargineTr2(){
        return new Integer(3)
    }

    static Integer getProgressivoMargineConvenzioni(){
        return new Integer(4)
    }

    static Integer getProgressivoMargineLibretto(){
        return new Integer(5)
    }

    static Integer getProgressivoMargineSentenza(){
        return new Integer(1)
    }

    static Integer getProgressivoMargineCognome1(){
        return new Integer(5)
    }

    static Integer getProgressivoMargineCognome2(){
        return new Integer(6)
    }

    ///////////////////////////////////////NASCITA////////////////////////////////////////////

    //refs #61890: aggiungo il nuovo parametro comuneClienteOggi per capire quando stampare la formula a margine Tr1 per i CNA
    static Boolean addFormulaNascita(String chiave, ETipoOperazione tipoOperazione, CivNascita obj, CivDatiProvenienzaAtto datiProvenienza, ArcComune comuneClienteOggi=null) {
        Boolean add = Boolean.FALSE
        if (tipoOperazione.isUpdate()) {
            switch (chiave) {
                case FORMULA_TESTATA_TRASCRIZIONE:
                    add = ( ( obj.isSecondaA() && ( (obj.natura?.name()?:"") == ENaturaAtto.T.name() ) ) || obj.isCentroNascita() )
                    break
                case FORMULA_TESTATA:
                    add = ( obj.isPrimaA() || obj.isPrimaB() || obj.isSecondaA() || obj.isCentroNascita() )
                    break
                case FORMULA_DICHIARANTE_FISSA:
                    add = ( obj.isPrimaA() || obj.isPrimaB() || obj.isSecondaA() )
                    break
                case FORMULA_DICHIARANTE:
                    add = ( ( obj.isPrimaA() || obj.isPrimaB() || obj.isSecondaA() || obj.isCentroNascita() ) && obj?.tipoFiliazione && datiProvenienza?.tipoDichiarante )
                    break
                case FORMULA_FILIAZIONE_FISSA:
                    add = ( obj.isPrimaA() || obj.isPrimaB() || obj.isSecondaA() || obj.isCentroNascita() )
                    break
                case FORMULA_FILIAZIONE:
                    add = ( ( obj.isPrimaA() || obj.isPrimaB() || obj.isSecondaA() || obj.isCentroNascita() ) && obj?.tipoFiliazione && datiProvenienza?.tipoDichiarante )
                    break
                case FORMULA_PRESENTAZIONE:
                    add = ( obj.isPrimaA() || obj.isPrimaB() || obj.isSecondaA() )
                    break
                case FORMULA_PARTO_PLURIMO:
                    add = ( ( obj.isPrimaA() || obj.isPrimaB() || obj.isSecondaA() || obj.isCentroNascita() ) && obj.partoPlurimo && obj.numeroGemello && obj.totaleGemelli )
                    break
                case FORMULA_STATO_NASCITA:
                    add = ( (obj.isPrimaA() || obj.isPrimaB() || obj.isSecondaA() || obj.isCentroNascita() ) && ((obj.natoMorto == EStatoNascita.Nato_morto) || (obj.natoMorto == EStatoNascita.Vivo_morto)) )
                    break
                case FORMULA_CIRCOSTANZE_PARTICOLARI:
                    add = ( obj.isPrimaA() || obj.isPrimaB() || obj.isSecondaA() || obj.isCentroNascita() )
                    break
                case FORMULA_TESTO_LIBERO:
                    add = ( obj.isTestoLibero() || obj.isSenzaSerie() || ( obj.isSecondaB() && (!(obj.tipoAttoDomain?.categoriaDomain?.flagFormule)) ) )
                    break
                case FORMULA_CHIUSURA:
                    add = ( obj.isPrimaA() || obj.isPrimaB() || obj.isSecondaA() || obj.isCentroNascita() )
                    break
                case FORMULA_FIRMA:
                    add = ( ( obj.isPrimaA() || obj.isPrimaB() || obj.isSecondaA() || obj.isCentroNascita() ) && obj?.tipoFiliazione && datiProvenienza?.tipoDichiarante )
                    break
                case FORMULA_MARGINE_TR1:
                    add = (obj.natura == ENaturaAtto.O)
                    //refs #61890
                    if (obj.isSecondaB()){
                        add = (add && (!(ComuneUtils.stessiCodici(obj.codiceComuneResidenza, obj.codiceProvinciaResidenza, comuneClienteOggi))) )
                    }
                    break
                case FORMULA_MARGINE_SENTENZA:
                    add = ( obj.isPrimaB() || (obj.isSecondaA() && datiProvenienza.isAttoOriginalePrimaB()) )
                    break
            }
        }
        return add
    }

    ///////////////////////////////////////MATRIMONIO////////////////////////////////////////////

    static Boolean addFormulaMatrimonio(String chiave, ETipoOperazione tipoOperazione, CivMatrimonio obj, CivMargine margine, ArcComune comuneClienteOggi=null) {
        Boolean add = Boolean.FALSE
        // Gestione eccezioni: la gestione della formula del libretto internazionale di famiglia, diversamente dalle altre, dipende da un flag in maschera
        // per cui il controllo va svincolato dal valore del tipoOperazione (deve essere fatto anche in insert)
        switch (chiave) {
            case FORMULA_MARGINE_LIBRETTO:
                add = ( ( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) ) && ( obj.isPartePrima() || obj.isSecondaA() || obj.isSecondaC() ) && ( (obj.nazionalita1?.codCi == AnaCittadinanza.ID_ITALIA) || (obj.nazionalita2?.codCi == AnaCittadinanza.ID_ITALIA) ) )
                break
        }
        if (tipoOperazione.isUpdate()){
            switch (chiave) {
                case FORMULA_TESTATA_TRASCRIZIONE:
                    add = ( obj.isSecondaB() && ( (obj.natura?.name()?:"") == ENaturaAtto.T.name() ) )
                    break
                case FORMULA_TESTATA:
                    add = ( obj.isPartePrima() || obj.isSecondaA() || obj.isSecondaB() )
                    break
                case FORMULA_SPOSI:
                    add = ( obj.isPartePrima() || obj.isSecondaA() || obj.isSecondaB() )
                    break
                case FORMULA_DATI_MATRIMONIO:
                    add = ( obj.isSecondaA() || obj.isSecondaB() )
                    break
                case FORMULA_PUBBLICAZIONI_FISSA:
                    add = ( obj.isSecondaA() || obj.isSecondaB() )
                    break
                case FORMULA_PUBBLICAZIONI:
                    add = ( obj.isSecondaA() || obj.isSecondaB() )
                    break
                case FORMULA_MATRIMONIO_CONCORDATARIO:
                    add = ( obj.isSecondaA() || obj.isSecondaB() )
                    break
                case FORMULA_RICHIESTA_FISSA:
                    add = obj.isPartePrima()
                    break
                case FORMULA_TESTIMONI:
                    add = ( obj.isPartePrima() || ( (obj.isCivileXDelega() || obj.isTrascrizioneMatrimonioCivile() || obj.isTrascrizioneMatrimonioCivileSuDelega()) && obj.tipoAttoDomain?.categoriaDomain?.flagFormule ) )
                    break
                case FORMULA_DOCUMENTI_FISSA:
                case FORMULA_DOCUMENTI:
                    add = ( obj.isPartePrima() && (margine.documentoPresentatoMatrimonio != null) )
                    break
                case FORMULA_AMMISSIONE_OLTRE_IMPEDIMENTI:
                    add = obj.isPartePrima()
                    break
                case FORMULA_RICONOSCIMENTO_FIGLI:
                    add = obj.isPartePrima()
                    break
                case FORMULA_REGIME_PATRIMONIALE:
                    add = obj.isPartePrima()
                    break
                case FORMULA_TESTO_LIBERO:
                    add = ( obj.isTestoLibero() || ( obj.isSecondaC() && (!(obj.tipoAttoDomain?.categoriaDomain?.flagFormule)) ) )
                    break
                case FORMULA_CHIUSURA:
                    add = obj.isPartePrima()
                    break
                case FORMULA_FIRMA:
                    add = ( obj.isPartePrima() || obj.isSecondaA() || obj.isSecondaB() )
                    break
                case FORMULA_MARGINE_MINISTRO:
                    add = ( obj.isSecondaA() || obj.isSecondaB() )
                    break
                case FORMULA_MARGINE_CONVENZIONI:
                    add = ( ( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) ) && obj.convenzioni )
                    break
                case FORMULA_MARGINE_TR1:
                    add = (obj.natura == ENaturaAtto.O)
                    //refs #61890
                    if (obj.isSecondaC()){
                        add = (add && (!(ComuneUtils.stessiCodici(obj.codiceComuneResidenza1, obj.codiceProvinciaResidenza1, comuneClienteOggi))) )
                    }
                    break
                case FORMULA_MARGINE_TR2:
                    add = (obj.natura == ENaturaAtto.O)
                    //refs #61890
                    if (obj.isSecondaC()){
                        add = (add && (!(ComuneUtils.stessiCodici(obj.codiceComuneResidenza2, obj.codiceProvinciaResidenza2, comuneClienteOggi))) )
                    }
                    break
            }
        }
        return add
    }

    ///////////////////////////////////// DIVORZI ////////////////////////////////////////////

    static Boolean addFormulaDivorzio(String chiave, ETipoOperazione tipoOperazione, CivMatrimonio obj) {
        Boolean add = Boolean.FALSE
        if (tipoOperazione.isUpdate()){
            switch (chiave) {
                case FORMULA_TESTATA_TRASCRIZIONE:
                    add = ( obj.isSecondaC() && obj.isAvvocati() )
                    break
                case FORMULA_TESTATA:
                    add = ( obj.isSecondaC() && obj.tipoAttoDomain?.categoriaDomain?.flagFormule )
                    break
                case FORMULA_SPOSI:
                case FORMULA_RICHIESTA:
                case FORMULA_CHIUSURA:
                    add = ( obj.isSecondaC() && (obj.isUfficialeAccordo() || obj.isUfficialeConferma()) )
                    break
                case FORMULA_FIRMA:
                    add = ( obj.isSecondaC() && obj.tipoAttoDomain?.categoriaDomain?.flagFormule )
                    break
                case FORMULA_DOCUMENTI_ALTRO:
                    add = ( obj.isSecondaC() && obj.isUfficialeAccordo() )
                    break
                case FORMULA_TESTO_LIBERO:
                    add = ( obj.isTestoLibero() || ( obj.isSecondaC() && (!(obj.tipoAttoDomain?.categoriaDomain?.flagFormule)) ) )
                    break
            }
        }
        return add
    }

    ///////////////////////////////////// PUBBLICAZIONI ////////////////////////////////////////////

    static Boolean addFormulaPubblicazione(String chiave, ETipoOperazione tipoOperazione, CivPubblicazione obj, CivDatiProvenienzaAtto datiProvenienza, CivMargine margine, CivDocumentoPubblicazione documentoPubblicazione) {
        Boolean add = Boolean.FALSE
        if (tipoOperazione.isUpdate()){
            switch (chiave) {
                case FORMULA_TESTATA:
                    add = ( ( obj.isPartePrima() || obj.isSecondaA() ) && (margine.documentoPresentatoMatrimonio != null) )
                    break
                case FORMULA_RICHIEDENTI:
                    add = ( ( obj.isPartePrima() || obj.isSecondaA() ) && (datiProvenienza?.tipoDichiarante != null) && (margine.documentoPresentatoMatrimonio != null) )
                    break
                case FORMULA_DOCUMENTI:
                    add = ( ( obj.isPartePrima() || obj.isSecondaA() ) && (margine.documentoPresentatoMatrimonio != null) && (documentoPubblicazione.documentoPresentatoPubblicazione != null) )
                    break
                case FORMULA_CHIUSURA:
                case FORMULA_FIRMA:
                    add = ( ( obj.isPartePrima() || obj.isSecondaA() ) && (datiProvenienza?.tipoDichiarante != null) )
                    break
                case FORMULA_TESTO_LIBERO:
                    add = obj.isTestoLibero()
                    break
            }
        }
        return add
    }

    /////////////////////////////////////// DECESSO ////////////////////////////////////////////

    static Boolean addFormulaDecesso(String chiave, ETipoOperazione tipoOperazione, CivMorte obj, ArcComune comuneClienteOggi=null) {
        Boolean add = Boolean.FALSE
        if (tipoOperazione.isUpdate()){
            switch (chiave) {
                case FORMULA_TESTATA:
                    add = ( obj.isPartePrima() || obj.isSecondaA() || obj.isSecondaB() || obj.isSecondaBBis() )
                    break
                case FORMULA_TESTATA_TRASCRIZIONE:
                    add = ( ( obj.isSecondaA() || obj.isSecondaBBis() ) && (obj.natura?.name()?:"") == ENaturaAtto.T.name() )
                    break
                case FORMULA_DICHIARANTE_FISSA:
                    add = ( obj.isPartePrima() || obj.isSecondaA() )
                    break
                case FORMULA_DATI_INTEGRATIVI:
                    add = ( obj.isSecondaB() || obj.isSecondaBBis() )
                    break
                case FORMULA_APOSTILLE:
                    add = ( obj.isPartePrima() || obj.isSecondaA() || obj.isSecondaB() || obj.isSecondaBBis() )
                    break
                case FORMULA_DATI_DECESSO:
                case FORMULA_CONGIUNTI:
                    add = ( obj.isPartePrima() || obj.isSecondaA() || obj.isSecondaB() || obj.isSecondaBBis() )
                    break
                case FORMULA_CHIUSURA:
                    add = ( obj.isPartePrima() || obj.isSecondaA() )
                    break
                case FORMULA_FIRMA:
                    add = ( obj.isPartePrima() || obj.isSecondaA() || obj.isSecondaB() || obj.isSecondaBBis() )
                    break
                case FORMULA_TESTO_LIBERO:
                    add = ( obj.isTestoLibero() || ( obj.isSecondaC() && (!(obj.tipoAttoDomain?.categoriaDomain?.flagFormule)) ) )
                    break
                case FORMULA_MARGINE_NASCITA:
                    add =( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) )
                    break
                case FORMULA_MARGINE_TR1:
                    add = (obj.natura == ENaturaAtto.O)
                    //refs #61890
                    if (obj.isSecondaC()){
                        add = (add && (!(ComuneUtils.stessiCodici(obj.codiceComuneResidenza, obj.codiceProvinciaResidenza, comuneClienteOggi))) )
                    }
                    break
            }
        }
        return add
    }

    /////////////////////////////////////// PROCESSO VERBALE ////////////////////////////////////////////

    static Boolean addFormulaProcessoVerbale(String chiave, ETipoOperazione tipoOperazione, CivProcessoVerbale obj, CivDocumentoPubblicazione documentoPubblicazione) {
        Boolean add = Boolean.FALSE
        if (tipoOperazione.isUpdate()) {
            switch (chiave) {
                case FORMULA_TESTATA:
                case FORMULA_RICHIEDENTI:
                case FORMULA_CHIUSURA:
                case FORMULA_FIRMA:
                    add = (obj.tipoAttoDomain?.categoriaDomain?.flagFormule)
                    break
                case FORMULA_DOCUMENTI:
                case FORMULA_DOCUMENTI_ALTRO:
                    add = ( obj.tipoAttoDomain?.categoriaDomain?.flagFormule && (documentoPubblicazione.documentoPresentatoPubblicazione != null) )
                    break
                case FORMULA_TESTO_LIBERO:
                    add = ( obj.isTestoLibero() )
                    break
            }
        }
        return add
    }

    /////////////////////////////////////// UNIONE CIVILE ////////////////////////////////////////////

    // per gli atti registrati con forms mostro sempre il testo libero
    // per gli atti registrati con zk mostro testo libero o frammenti in funzione della categoria
    static Boolean addFormulaUnioneCivile(String chiave, ETipoOperazione tipoOperazione, CivUnioneCivile obj, CivDocumentoPubblicazione documentoPubblicazione) {
        Boolean add = Boolean.FALSE
        if (tipoOperazione.isUpdate()){
            switch (chiave) {
                case FORMULA_TESTATA_TRASCRIZIONE:
                    add = ( (obj.natura == ENaturaAtto.T) && obj.tipoAttoDomain?.categoriaDomain?.flagFormule )
                    break
                case FORMULA_TESTATA:
                case FORMULA_CONTRAENTI:
                case FORMULA_RICHIESTA_FISSA:
                    add = ( ( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) ) && obj.tipoAttoDomain?.categoriaDomain?.flagFormule )
                    break
                case FORMULA_TESTIMONI:
                    add = ( ( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) ) && obj.tipoAttoDomain?.categoriaDomain?.flagFormule )
                    break
                case FORMULA_DOCUMENTI:
                    add = ( ( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) ) && obj.tipoAttoDomain?.categoriaDomain?.flagFormule && (documentoPubblicazione.documentoPresentatoPubblicazione != null) )
                    break
                case FORMULA_AMMISSIONE_OLTRE_IMPEDIMENTI:
                    add = ( ( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) ) && obj.tipoAttoDomain?.categoriaDomain?.flagFormule )
                    break
                case FORMULA_SCELTA_COGNOME:
                    add = ( ( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) ) && obj.tipoAttoDomain?.categoriaDomain?.flagFormule )
                    break
                case FORMULA_REGIME_PATRIMONIALE:
                    //verificare se anche in caso di convenzioni?
                    add = ( ( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) ) && obj.tipoAttoDomain?.categoriaDomain?.flagFormule )
                    break
                case FORMULA_CHIUSURA:
                case FORMULA_FIRMA:
                    add = ( ( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) ) && obj.tipoAttoDomain?.categoriaDomain?.flagFormule )
                    break
                case FORMULA_TESTO_LIBERO:
                    add = ( obj.isTestoLibero() || (!(obj.tipoAttoDomain?.categoriaDomain?.flagFormule)) )
                    break
                case FORMULA_MARGINE_CONVENZIONI:
                    add = ( ( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) ) && obj.convenzioni )
                    break
                case FORMULA_MARGINE_COGNOME_1:
                    add = ( ( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) ) && (obj.cambioCognome1 != null) )
                    break
                case FORMULA_MARGINE_COGNOME_2:
                    add = ( ( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) ) && (obj.cambioCognome2 != null) )
                    break
            }
        }
        return add
    }

    ///////////////////////////////////// SCIOGLIMENTI ////////////////////////////////////////////

    static Boolean addFormulaScioglimento(String chiave, ETipoOperazione tipoOperazione, CivUnioneCivile obj) {
        Boolean add = Boolean.FALSE
        if (tipoOperazione.isUpdate()){
            switch (chiave) {
                case FORMULA_TESTATA_TRASCRIZIONE:
                    add = ( obj.isParteSeconda() && obj.isAvvocati() )
                    break
                case FORMULA_TESTATA:
                    add = ( obj.isParteSeconda() && obj.tipoAttoDomain?.categoriaDomain?.flagFormule )
                    break
                case FORMULA_RICHIEDENTI_FISSA:
                case FORMULA_RICHIESTA:
                    add = ( obj.isParteSeconda() && (obj.isUfficialeAccordo() || obj.isUfficialeConferma()) )
                    break
                case FORMULA_DOCUMENTI_ALTRO:
                    add = ( obj.isParteSeconda() && obj.isUfficialeAccordo() )
                    break
                case FORMULA_FIRMA:
                case FORMULA_CHIUSURA:
                    add = ( obj.isParteSeconda() && obj.tipoAttoDomain?.categoriaDomain?.flagFormule )
                    break
                case FORMULA_TESTO_LIBERO:
                    add = ( obj.isTestoLibero() || ( obj.isParteSeconda() && (!(obj.tipoAttoDomain?.categoriaDomain?.flagFormule)) ) )
                    break
            }
        }
        return add
    }

    /////////////////////////////////////// CITTADINANZA ////////////////////////////////////////////

    static Boolean addFormulaCittadinanza(String chiave, ETipoOperazione tipoOperazione, CivCittadinanza obj){
        Boolean add = Boolean.FALSE
        if (tipoOperazione.isUpdate()){
            switch (chiave) {
                case FORMULA_TESTO_LIBERO:
                    add = (obj.id && Boolean.TRUE)
                    break
            }
        }
        return add
    }

}
