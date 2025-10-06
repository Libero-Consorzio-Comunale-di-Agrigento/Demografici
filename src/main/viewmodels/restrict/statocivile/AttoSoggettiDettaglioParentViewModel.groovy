package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeBaseDomain
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.statocivile.embed.Testimone
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class AttoSoggettiDettaglioParentViewModel extends AttoDettaglioParentViewModel{

    CivSposiAtto sposi
    CivTestimoniAtto testimoni

    List<Integer> listaNumeroTestimoni = [null] + [new Integer(2), new Integer(3), new Integer(4)]

    CivSoggettoCollegato getInterprete(){
        CivSoggettoCollegato scInterprete = getSoggettoCollegato(ETipoSoggettoCollegato.IT)
        return scInterprete
    }

    CivSoggettoCollegato getAscendente(){
        CivSoggettoCollegato scAscendente = getSoggettoCollegato(ETipoSoggettoCollegato.AS)
        return scAscendente
    }

    CivSoggettoCollegato getIntestatarioVecchioGeneralita(){
        CivSoggettoCollegato scIntestatarioVecchieGeneralita = getSoggettoCollegato(ETipoSoggettoCollegato.CG)
        return scIntestatarioVecchieGeneralita
    }

    CivSoggettoCollegato getSoggettoCollegatoPadre(){
        CivSoggettoCollegato scPadre = getSoggettoCollegato(ETipoSoggettoCollegato.PD)
        return scPadre
    }

    CivSoggettoCollegato getSoggettoCollegatoMadre(){
        CivSoggettoCollegato scMadre = getSoggettoCollegato(ETipoSoggettoCollegato.MD)
        return scMadre
    }

    CivSoggettoCollegato getSanitario(){
        CivSoggettoCollegato scSanitario = getSoggettoCollegato(ETipoSoggettoCollegato.OS)
        return scSanitario
    }

    CivSoggettoCollegato getProcuratorePadre(){
        CivSoggettoCollegato scProcuratorePadre = getSoggettoCollegato(ETipoSoggettoCollegato.PP)
        return scProcuratorePadre
    }

    CivSoggettoCollegato getProcuratoreMadre(){
        CivSoggettoCollegato scProcuratoreMadre = getSoggettoCollegato(ETipoSoggettoCollegato.PM)
        return scProcuratoreMadre
    }

    CivSoggettoCollegato getSoggettoCollegato(ETipoSoggettoCollegato tsc){
        CivSoggettoCollegato scFound = null
        if (listaSoggettiCollegati?.size() > 0) {
            for (CivSoggettoCollegato sc : listaSoggettiCollegati) {
                if (sc.tipoSoggettoCollegato == tsc) {
                    scFound = sc
                }
            }
        }
        return scFound
    }

    protected void selezionaComune(ETipoComuneAtto tca, ArcComuneBaseDomain c){
        super.selezionaComune(tca, c)

        switch (tca) {
            case ETipoComuneAtto.CN_TEST1:
                riempiComune(testimoni.testimone1.comuneNascita, c)
                break
            case ETipoComuneAtto.CR_TEST1:
                riempiComune(testimoni.testimone1.comuneResidenza, c)
                break
            case ETipoComuneAtto.CN_TEST2:
                riempiComune(testimoni.testimone2.comuneNascita, c)
                break
            case ETipoComuneAtto.CR_TEST2:
                riempiComune(testimoni.testimone2.comuneResidenza, c)
                break
            case ETipoComuneAtto.CN_TEST3:
                riempiComune(testimoni.testimone3.comuneNascita, c)
                break
            case ETipoComuneAtto.CR_TEST3:
                riempiComune(testimoni.testimone3.comuneResidenza, c)
                break
            case ETipoComuneAtto.CN_TEST4:
                riempiComune(testimoni.testimone4.comuneNascita, c)
                break
            case ETipoComuneAtto.CR_TEST4:
                riempiComune(testimoni.testimone4.comuneResidenza, c)
                break
            case ETipoComuneAtto.CN_CON:
                if ( getAtto() instanceof CivMorte ){
                    riempiComune(((CivMorte)getAtto()).comuneNascitaConiuge, c)
                }
                break
            case ETipoComuneAtto.CR_CON:
                if ( getAtto() instanceof CivMorte ){
                    riempiComune(((CivMorte)getAtto()).comuneResidenzaConiuge, c)
                }
                break
            case ETipoComuneAtto.CN_INT:
                riempiComune(interprete.comuneNascita, c)
                break
            case ETipoComuneAtto.CR_INT:
                riempiComune(interprete.comuneResidenza, c)
                break
            case ETipoComuneAtto.CN_ASC:
                riempiComune(ascendente.comuneNascita, c)
                break
            case ETipoComuneAtto.CR_ASC:
                riempiComune(ascendente.comuneResidenza, c)
                break
            case ETipoComuneAtto.CN_SAN:
                riempiComune(sanitario.comuneNascita, c)
                break
            case ETipoComuneAtto.CR_SAN:
                riempiComune(sanitario.comuneResidenza, c)
                break
            case ETipoComuneAtto.CN_PP:
                riempiComune(procuratorePadre.comuneNascita, c)
                break
            case ETipoComuneAtto.CR_PP:
                riempiComune(procuratorePadre.comuneResidenza, c)
                break
            case ETipoComuneAtto.CN_PM:
                riempiComune(procuratoreMadre.comuneNascita, c)
                break
            case ETipoComuneAtto.CR_PM:
                riempiComune(procuratoreMadre.comuneResidenza, c)
                break
            case ETipoComuneAtto.CN_RIC_PD:
                riempiComune(soggettoCollegatoPadre.comuneNascita, c)
                break
            case ETipoComuneAtto.CR_RIC_PD:
                riempiComune(soggettoCollegatoPadre.comuneResidenza, c)
                break
            case ETipoComuneAtto.CN_RIC_MD:
                riempiComune(soggettoCollegatoMadre.comuneNascita, c)
                break
            case ETipoComuneAtto.CR_RIC_MD:
                riempiComune(soggettoCollegatoMadre.comuneResidenza, c)
                break
            case ETipoComuneAtto.CN_SOGG_1_OLD:
                riempiComune(intestatarioVecchioGeneralita.comuneNascita, c)
                break
            case ETipoComuneAtto.CR_SOGG_1_OLD:
                riempiComune(intestatarioVecchioGeneralita.comuneResidenza, c)
                break
        }
        refreshUi()
    }

    @Command void onAggiornaCaseTestimoni(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")
        aggiornaCaseEntita(testimoni, p)
    }

    @Command void onCancellaCampoTestimoni(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampoEntita(testimoni, p)
    }

    @Command void onAggiornaCaseSoggettoCollegato(@ContextParam(ContextType.TRIGGER_EVENT) Event e, @BindingParam("tipoSoggettoCollegato") String tipoSoggettoCollegato){
        String p = e?.target?.getAttribute("proprieta")
        CivSoggettoCollegato sc = getSoggettoCollegato(ETipoSoggettoCollegato.valueOf(tipoSoggettoCollegato))
        aggiornaCaseEntita(sc, p)
    }

    @Command void onCancellaCampoSoggettoCollegato(@ContextParam(ContextType.TRIGGER_EVENT) Event e, @BindingParam("tipoSoggettoCollegato") String tipoSoggettoCollegato){
        String p = e?.target?.getAttribute("proprieta")
        CivSoggettoCollegato sc = getSoggettoCollegato(ETipoSoggettoCollegato.valueOf(tipoSoggettoCollegato))
        cancellaCampoEntita(sc, p)
    }

    @Command void onCancellaAnagrafica(@BindingParam("tipoSoggetto") String tipoSoggetto){
        ETipoSoggetto ts = ETipoSoggetto.valueOf(tipoSoggetto)
        switch (ts) {
            case ETipoSoggetto.TESTIMONE_1: // UCI - MAT
                cancellaAnagraficaTestimone(testimoni.testimone1)
                break
            case ETipoSoggetto.TESTIMONE_2: // UCI - MAT
                cancellaAnagraficaTestimone(testimoni.testimone2)
                break
            case ETipoSoggetto.TESTIMONE_3: // UCI - MAT
                cancellaAnagraficaTestimone(testimoni.testimone3)
                break
            case ETipoSoggetto.TESTIMONE_4: // UCI - MAT
                cancellaAnagraficaTestimone(testimoni.testimone4)
                break
            case ETipoSoggetto.CONIUGE: // DEC
                cancellaAnagraficaConiuge()
                break
            case ETipoSoggetto.ALTRO: // DICHIARANTE
                cancellaAnagraficaDichiarante()
                break
            case ETipoSoggetto.INTERPRETE: // CIVSOG
                cancellaAnagraficaSoggettoCollegato(interprete)
                break
            case ETipoSoggetto.ASCENDENTE: // CIVSOG
                cancellaAnagraficaSoggettoCollegato(ascendente)
                break
            case ETipoSoggetto.SANITARIO: // CIVSOG
                cancellaAnagraficaSoggettoCollegato(sanitario)
                break
            case ETipoSoggetto.RICONOSCIMENTO_PADRE: // CIVSOG
                cancellaAnagraficaSoggettoCollegato(soggettoCollegatoPadre)
                break
            case ETipoSoggetto.RICONOSCIMENTO_MADRE: // CIVSOG
                cancellaAnagraficaSoggettoCollegato(soggettoCollegatoMadre)
                break
            case ETipoSoggetto.PROCURATORE_PADRE:  // CIVSOG
                cancellaAnagraficaSoggettoCollegato(procuratorePadre)
                break
            case ETipoSoggetto.PROCURATORE_MADRE:  // CIVSOG
                cancellaAnagraficaSoggettoCollegato(procuratoreMadre)
                break
            case ETipoSoggetto.CAMBIO_GENERALITA:  // CIVSOG
                cancellaAnagraficaSoggettoCollegato(intestatarioVecchioGeneralita)
                break
        }
    }

    protected void cancellaAnagraficaConiuge(){
        log.info("punto di estensione")
    }

    protected void cancellaAnagraficaDichiarante(){
        DomainUtils.initDichiaranteFromAnagrafe(datiProvenienza, null)

        if ( (getAtto() instanceof CivMorte) && ( ((CivMorte)getAtto()).isComprensioneDichiaranteVisibile() ) ){
            datiProvenienza.comprensioneDichiarante = getDefaultComprensione()
            datiProvenienza.motivoImpedimentoDichiarante = null
        }

        if ( (getAtto() instanceof CivMorte) ){
            datiProvenienza.senzaCognomeDichiarante = Boolean.FALSE
            datiProvenienza.senzaNomeDichiarante = Boolean.FALSE
        }

        refreshUi()
    }

    protected void cancellaAnagraficaSoggettoCollegato(CivSoggettoCollegato sc){
        DomainUtils.initSoggettoCollegatoFromAnagrafe(sc, null)

        if (sc.tipoSoggettoCollegato == ETipoSoggettoCollegato.AS){
            sc.gradoParentela = null
        }
        if (sc.tipoSoggettoCollegato == ETipoSoggettoCollegato.OS){
            sc.qualifica = null
        }
        if ( (sc.tipoSoggettoCollegato == ETipoSoggettoCollegato.PP) || (sc.tipoSoggettoCollegato == ETipoSoggettoCollegato.PM) ) {
            datiProvenienza.datiProcura = null
        }
        sc.codiceFiscale = null
        refreshUi()
    }

    protected void cancellaAnagraficaTestimone(Testimone t){
        DomainUtils.initTestimoneFromAnagrafe(t, null)
        refreshUi()
    }

    @Command void onCaricaSoggetti(@BindingParam("tipoSoggetto") String tipoSoggetto){
        ETipoSoggetto ts = ETipoSoggetto.valueOf(tipoSoggetto)
        Map params
        switch (ts) {
            case ETipoSoggetto.NATO_A: // NAS (CGE-RIC)
                if (getAtto() instanceof ISoggettoAtto1){
                    ISoggettoAtto1 sa1 = (ISoggettoAtto1) getAtto()
                    if ( (sa1 instanceof CivNascita) && ( ((CivNascita)sa1).isCambioGeneralita() || ((CivNascita)sa1).isRiconoscimentoPostNascita()) ){
                        params = [cognome: sa1.getCognome1(), nome: sa1.getNome1(), sesso : sa1.getSesso1(), dataNascita: sa1.getDataNascita1()]
                    }
                }
                break
            case ETipoSoggetto.SOGGETTO_1: // CITT - DEC - PUBB - DIV - MAT - UCI - PVU - SCIO
                if (getAtto() instanceof ISoggettoAtto1){
                    ISoggettoAtto1 sa1 = (ISoggettoAtto1) getAtto()
                    ESesso s = sa1.getSesso1()
                    if ( (s == null) && ( (sa1 instanceof CivUnioneCivile) || (sa1 instanceof CivProcessoVerbale) ) ){ // UCI - PVU - SCIO
                        ISoggettoAtto2 sa2 = (ISoggettoAtto2) getAtto()
                        s = sa2.getSesso2()
                    }
                    params = [cognome: sa1.getCognome1(), nome: sa1.getNome1(), sesso : s, dataNascita: sa1.getDataNascita1()]
                    if (sa1 instanceof CivMorte) {
                        // params.put("checkConiuge", ((CivMorte) sa1).isConiugato())?
                        params.put("checkConiuge", Boolean.TRUE)
                    }
                }
                break
            case ETipoSoggetto.SOGGETTO_2: // PUBB - DIV - MAT - UCI - PVU - SCIO
                if (getAtto() instanceof ISoggettoAtto2){
                    ISoggettoAtto2 sa2 = (ISoggettoAtto2) getAtto()
                    ESesso s = sa2.getSesso2()
                    if ( (s == null) && ( (sa2 instanceof CivUnioneCivile) || (sa2 instanceof CivProcessoVerbale) ) ){ // UCI - PVU - SCIO
                        ISoggettoAtto1 sa1 = (ISoggettoAtto1) getAtto()
                        s = sa1.getSesso1()
                    }
                    params = [cognome: sa2.getCognome2(), nome: sa2.getNome2(), sesso : s, dataNascita: sa2.getDataNascita2()]
                }
                break
            case ETipoSoggetto.TESTIMONE_1: // UCI - MAT
                params = [cognome: testimoni.testimone1.cognome, nome: testimoni.testimone1.nome, sesso : testimoni.testimone1.sesso, dataNascita: testimoni.testimone1.dataNascita]
                break
            case ETipoSoggetto.TESTIMONE_2: // UCI - MAT
                params = [cognome: testimoni.testimone2.cognome, nome: testimoni.testimone2.nome, sesso : testimoni.testimone2.sesso, dataNascita: testimoni.testimone2.dataNascita]
                break
            case ETipoSoggetto.TESTIMONE_3: // UCI - MAT
                params = [cognome: testimoni.testimone3.cognome, nome: testimoni.testimone3.nome, sesso : testimoni.testimone3.sesso, dataNascita: testimoni.testimone3.dataNascita]
                break
            case ETipoSoggetto.TESTIMONE_4: // UCI - MAT
                params = [cognome: testimoni.testimone4.cognome, nome: testimoni.testimone4.nome, sesso : testimoni.testimone4.sesso, dataNascita: testimoni.testimone4.dataNascita]
                break
            case ETipoSoggetto.ALTRO: // NAS - MAT - DEC - CITT
                params = [cognome: datiProvenienza.cognomeDichiarante, nome: datiProvenienza.nomeDichiarante, sesso : datiProvenienza.sessoDichiarante, dataNascita: datiProvenienza.dataNascitaDichiarante]
                break
            case ETipoSoggetto.INTERPRETE: // CIVSOG
                if (interprete){
                    params = [cognome: interprete.cognome, nome: interprete.nome, sesso: interprete.sesso, dataNascita: interprete.dataNascita]
                }
                break
            case ETipoSoggetto.ASCENDENTE: // CIVSOG
                if (ascendente){
                    params = [cognome: ascendente.cognome, nome: ascendente.nome, sesso: ascendente.sesso, dataNascita: ascendente.dataNascita]
                }
                break
            case ETipoSoggetto.SANITARIO: // CIVSOG
                if (sanitario){
                    params = [cognome: sanitario.cognome, nome: sanitario.nome, sesso: sanitario.sesso, dataNascita: sanitario.dataNascita]
                }
                break
            case ETipoSoggetto.PROCURATORE_PADRE: // CIVSOG
                if (procuratorePadre){
                    params = [cognome: procuratorePadre.cognome, nome: procuratorePadre.nome, sesso: procuratorePadre.sesso, dataNascita: procuratorePadre.dataNascita]
                }
                break
            case ETipoSoggetto.PROCURATORE_MADRE: // CIVSOG
                if (procuratoreMadre){
                    params = [cognome: procuratoreMadre.cognome, nome: procuratoreMadre.nome, sesso: procuratoreMadre.sesso, dataNascita: procuratoreMadre.dataNascita]
                }
                break
            case ETipoSoggetto.PADRE: // NAS - DEC
                if ( getAtto() instanceof ISoggettoAtto1Genitori ){
                    ISoggettoAtto1Genitori sg = (ISoggettoAtto1Genitori)getAtto()
                    params = [cognome: sg.getCognomePadre(), nome: sg.getNomePadre(), sesso: ESesso.M]
                    if (sg instanceof CivNascita){
                        params.put("dataNascita", ((CivNascita) sg).dataNascitaPadre)
                        params.put("checkConiuge", ((CivNascita) sg).tipoFiliazione?.equals(ETipoFiliazione.L))
                    }
                }
                break
            case ETipoSoggetto.MADRE: // NAS - DEC
                if ( getAtto() instanceof ISoggettoAtto1Genitori ){
                    ISoggettoAtto1Genitori sg = (ISoggettoAtto1Genitori)getAtto()
                    params = [cognome: sg.getCognomeMadre(), nome: sg.getNomeMadre(), sesso: ESesso.F]
                    if (sg instanceof CivNascita){
                        params.put("dataNascita", ((CivNascita) sg).dataNascitaMadre)
                        params.put("checkConiuge", ((CivNascita) sg).tipoFiliazione?.equals(ETipoFiliazione.L))
                    }
                }
                break
            case ETipoSoggetto.CONIUGE: // DEC
                if (getAtto() instanceof CivMorte) {
                    CivMorte m = (CivMorte) getAtto()
                    params = [cognome: m.cognomeConiuge, nome: m.nomeConiuge, sesso: m.sessoConiuge, dataNascita: m.dataNascitaConiuge]
                }
                break
            case ETipoSoggetto.RICONOSCIMENTO_PADRE:
                if (soggettoCollegatoPadre){
                    params = [cognome: soggettoCollegatoPadre.cognome, nome: soggettoCollegatoPadre.nome, sesso: ESesso.M, dataNascita: soggettoCollegatoPadre.dataNascita]
                }
                break
            case ETipoSoggetto.RICONOSCIMENTO_MADRE:
                if (soggettoCollegatoMadre){
                    params = [cognome: soggettoCollegatoMadre.cognome, nome: soggettoCollegatoMadre.nome, sesso: ESesso.F, dataNascita: soggettoCollegatoMadre.dataNascita]
                }
                break
            case ETipoSoggetto.CAMBIO_GENERALITA:
                if (intestatarioVecchioGeneralita){
                    params = [cognome: intestatarioVecchioGeneralita.cognome, nome: intestatarioVecchioGeneralita.nome, sesso: intestatarioVecchioGeneralita.sesso, dataNascita: intestatarioVecchioGeneralita.dataNascita]
                }
                break
        }
        if (params){
            Window w = (Window) Executions.createComponents(FormUtils.getUriAnagrafeSelect(ricercaSoggettoInANPROn), self, params)
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                if (event.data instanceof AnaAnagrafeBaseDomain){
                    AnaAnagrafeBaseDomain ana = (AnaAnagrafeBaseDomain)event.data
                    switch (ts) {
                        case ETipoSoggetto.NATO_A: // NAS
                            caricaDatiNato(ana)
                            break
                        case ETipoSoggetto.SOGGETTO_1: // CITT - DEC - PUBB - DIV - MAT - UCI - PVU - SCIO
                            caricaDatiSoggetto1(ana)
                            break
                        case ETipoSoggetto.SOGGETTO_2:
                            caricaDatiSoggetto2(ana)
                            break
                        case ETipoSoggetto.TESTIMONE_1:
                            caricaDatiTestimone(testimoni.testimone1, ana)
                            break
                        case ETipoSoggetto.TESTIMONE_2:
                            caricaDatiTestimone(testimoni.testimone2, ana)
                            break
                        case ETipoSoggetto.TESTIMONE_3:
                            caricaDatiTestimone(testimoni.testimone3, ana)
                            break
                        case ETipoSoggetto.TESTIMONE_4:
                            caricaDatiTestimone(testimoni.testimone4, ana)
                            break
                        case ETipoSoggetto.ALTRO:
                            caricaDatiDichiarante(ana)
                            break
                        case ETipoSoggetto.INTERPRETE:
                            caricaDatiSoggettoCollegato(interprete, ana)
                            break
                        case ETipoSoggetto.ASCENDENTE:
                            caricaDatiSoggettoCollegato(ascendente, ana)
                            break
                        case ETipoSoggetto.SANITARIO:
                            caricaDatiSoggettoCollegato(sanitario, ana)
                            break
                        case ETipoSoggetto.PROCURATORE_PADRE:
                            caricaDatiSoggettoCollegato(procuratorePadre, ana)
                            break
                        case ETipoSoggetto.PROCURATORE_MADRE:
                            caricaDatiSoggettoCollegato(procuratoreMadre, ana)
                            break
                        case ETipoSoggetto.PADRE:
                            caricaDatiPadre(ana)
                            break
                        case ETipoSoggetto.MADRE:
                            caricaDatiMadre(ana)
                            break
                        case ETipoSoggetto.CONIUGE:
                            caricaDatiConiuge(ana)
                            break
                        case ETipoSoggetto.RICONOSCIMENTO_PADRE:
                            caricaDatiSoggettoCollegato(soggettoCollegatoPadre, ana)
                            break
                        case ETipoSoggetto.RICONOSCIMENTO_MADRE:
                            caricaDatiSoggettoCollegato(soggettoCollegatoMadre, ana)
                            break
                        case ETipoSoggetto.CAMBIO_GENERALITA:
                            caricaDatiSoggettoCollegato(intestatarioVecchioGeneralita, ana)
                            break
                    }
                    refreshUi()
                }
            })
            w.doModal()
        }
    }

    protected void caricaDatiPadre(AnaAnagrafeBaseDomain ana){
        if (log.isDebugEnabled()) {
            log.info("Padre: " + ana?.matricola)
        }
        DomainUtils.allineaTestoMinuscole(getAtto(), minuscole)
    }

    protected void caricaDatiMadre(AnaAnagrafeBaseDomain ana){
        if (log.isDebugEnabled()) {
            log.info("Madre: " + ana?.matricola)
        }
        DomainUtils.allineaTestoMinuscole(getAtto(), minuscole)
    }

    protected void caricaDatiConiuge(AnaAnagrafeBaseDomain ana){
        if (log.isDebugEnabled()) {
            log.info("Coniuge: " + ana?.matricola)
        }
        DomainUtils.allineaTestoMinuscole(getAtto(), minuscole)
    }

    protected void caricaDatiNato(AnaAnagrafeBaseDomain ana){
        if (getAtto() instanceof ISoggettoAtto1) {
            ISoggettoAtto1 s1 = (ISoggettoAtto1) getAtto()

            DomainUtils.initSoggetto1FromAnagrafe(s1, ana)

            //DomainUtils.initEstremiAttoNascita1FromAnagrafe(getEstremiAttoNascitaDomain(), ana)

            //recuperaEstremiAttoNascitaSoggetto1DaAttoDiNascita()

            DomainUtils.allineaTestoMinuscole(getAtto(), minuscole)
        }
    }

    protected void caricaDatiSoggetto1(AnaAnagrafeBaseDomain ana){
        if (anagrafe) {
            if (ana instanceof AnpAnagrafe){
                anagrafe.anagrafe1 = ana?.anagrafe
            } else {
                anagrafe.anagrafe1 = (AnaAnagrafe) ana
            }
        }

        if (getAtto() instanceof ISoggettoAtto1) {
            ISoggettoAtto1 s1 = (ISoggettoAtto1) getAtto()

            DomainUtils.initSoggetto1FromAnagrafe(s1, ana)

            if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
                DomainUtils.initEstremiAttoNascita1FromAnagrafeNuovaGestioneAnnotazioni(getEstremiAttoNascitaDomain() as IEstremiAttoNascitaSoggetto1Domain, ana)
            } else {
                DomainUtils.initEstremiAttoNascita1FromAnagrafe(getEstremiAttoNascitaDomain(), ana)
            }

            recuperaEstremiAttoNascitaSoggetto1DaAttoDiNascita()

            DomainUtils.allineaTestoMinuscole(getAtto(), minuscole)
        }
    }

    protected void caricaDatiSoggetto2(AnaAnagrafeBaseDomain ana){
        if (anagrafe) {
            if (ana instanceof AnpAnagrafe){
                anagrafe.anagrafe2 = ana?.anagrafe
            } else {
                anagrafe.anagrafe2 = (AnaAnagrafe) ana
            }
        }

        if (getAtto() instanceof ISoggettoAtto2) {
            ISoggettoAtto2 s2 = (ISoggettoAtto2) getAtto()

            DomainUtils.initSoggetto2FromAnagrafe(s2, ana)

            if(arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()){
                DomainUtils.initEstremiAttoNascita2FromAnagrafeNuovaGestioneAnnotazione(getEstremiAttoNascitaDomain() as IEstremiAttoNascitaSoggetto2Domain, ana)
            } else {
                DomainUtils.initEstremiAttoNascita2FromAnagrafe(getEstremiAttoNascitaDomain(), ana)
            }

            recuperaEstremiAttoNascitaSoggetto2DaAttoDiNascita()

            DomainUtils.allineaTestoMinuscole(getAtto(), minuscole)
        }
    }

    protected void caricaDatiDichiarante(AnaAnagrafeBaseDomain ana){
        DomainUtils.initDichiaranteFromAnagrafe(datiProvenienza, ana)

        DomainUtils.allineaTestoMinuscole(datiProvenienza, minuscole)
    }

    protected void caricaDatiSoggettoCollegato(CivSoggettoCollegato sc, AnaAnagrafeBaseDomain ana){
        if (sc) {
            DomainUtils.initSoggettoCollegatoFromAnagrafe(sc, ana)

            DomainUtils.allineaTestoMinuscole(sc, minuscole)
        }
    }

    protected void caricaDatiTestimone(Testimone t, AnaAnagrafeBaseDomain ana){
        DomainUtils.initTestimoneFromAnagrafe(t, ana)

        DomainUtils.allineaTestoMinuscole(testimoni, minuscole)
    }

    @Command void onCancellaCampoAtto(@ContextParam(ContextType.TRIGGER_EVENT) Event e, @BindingParam("campoAnagrafe") String campoAnagrafe){
        super.onCancellaCampoAtto(e, campoAnagrafe)

        if (anagrafe){
            onAggiornaAna(campoAnagrafe)
        }
    }

    @Command
    void onAggiornaCaseAndAna(@ContextParam(ContextType.TRIGGER_EVENT) Event e, @BindingParam("campoAnagrafe") String campoAnagrafe) {
        onAggiornaCase(e)

        onAggiornaAna(campoAnagrafe)
    }

    void onAggiornaAna(String campoAnagrafe){
        if (anagrafe && campoAnagrafe) {
            ETipoCampoAnagrafe ca = ETipoCampoAnagrafe.valueOf(campoAnagrafe)
            Map<String, String> params = null
            AnaAnagrafe anag
            switch (ca) {
                case ETipoCampoAnagrafe.COGNOME_SOGGETTO_1:
                    if (anagrafe && anagrafe?.anagrafe1 && (getAtto() instanceof ISoggettoAtto1) ){
                        ISoggettoAtto1 sa1 = (ISoggettoAtto1) getAtto()
                        if ( (anagrafe.anagrafe1?.cognome?:"").toLowerCase() != (sa1.cognome1?.trim()?:"").toLowerCase() ) {
                            params = [anagrafe: "1", soggetto: "SOGGETTO_1"]
                            anag = anagrafe.anagrafe1
                        }
                    }
                    break
                case ETipoCampoAnagrafe.NOME_SOGGETTO_1:
                    if (anagrafe && anagrafe?.anagrafe1 && (getAtto() instanceof ISoggettoAtto1) ){
                        ISoggettoAtto1 sa1 = (ISoggettoAtto1) getAtto()
                        if ( (anagrafe.anagrafe1?.nome?:"").toLowerCase() != (sa1.nome1?.trim()?:"").toLowerCase() ) {
                            params = [anagrafe: "1", soggetto: "SOGGETTO_1"]
                            anag = anagrafe.anagrafe1
                        }
                    }
                    break
                case ETipoCampoAnagrafe.SESSO_SOGGETTO_1:
                    if (anagrafe && anagrafe?.anagrafe1 && (getAtto() instanceof ISoggettoAtto1) ){
                        ISoggettoAtto1 sa1 = (ISoggettoAtto1) getAtto()
                        if ( (anagrafe.anagrafe1?.sesso?.name()?:"") != (sa1.sesso1?.name()?:"")) {
                            params = [anagrafe: "1", soggetto: "SOGGETTO_1"]
                            anag = anagrafe.anagrafe1
                        }
                    }
                    break
                case ETipoCampoAnagrafe.COGNOME_SOGGETTO_2:
                    if (anagrafe && anagrafe?.anagrafe2 && (getAtto() instanceof ISoggettoAtto2) ){
                        ISoggettoAtto2 sa2 = (ISoggettoAtto2) getAtto()
                        if ( (anagrafe.anagrafe2?.cognome?:"").toLowerCase() != (sa2.cognome2?.trim()?:"").toLowerCase() ) {
                            params = [anagrafe: "2", soggetto: "SOGGETTO_2"]
                            anag = anagrafe.anagrafe2
                        }
                    }
                    break
                case ETipoCampoAnagrafe.NOME_SOGGETTO_2:
                    if (anagrafe && anagrafe?.anagrafe2 && (getAtto() instanceof ISoggettoAtto2) ){
                        ISoggettoAtto2 sa2 = (ISoggettoAtto2) getAtto()
                        if ( (anagrafe.anagrafe2?.nome?:"").toLowerCase() != (sa2.nome2?.trim()?:"").toLowerCase() ) {
                            params = [anagrafe: "2", soggetto: "SOGGETTO_2"]
                            anag = anagrafe.anagrafe2
                        }
                    }
                    break
                case ETipoCampoAnagrafe.SESSO_SOGGETTO_2:
                    if (anagrafe && anagrafe?.anagrafe2 && (getAtto() instanceof ISoggettoAtto1) ){
                        ISoggettoAtto2 sa2 = (ISoggettoAtto2) getAtto()
                        if ( (anagrafe.anagrafe2?.sesso?.name()?:"") != (sa2.sesso2?.name()?:"")) {
                            params = [anagrafe: "2", soggetto: "SOGGETTO_2"]
                            anag = anagrafe.anagrafe2
                        }
                    }
                    break
                case ETipoCampoAnagrafe.COGNOME_PADRE:
                    if (anagrafe && anagrafe?.anagrafe1 && (getAtto() instanceof CivNascita) ){
                        CivNascita n = (CivNascita) getAtto()
                        if ( (anagrafe.anagrafe1?.cognome?:"").toLowerCase() != (n.cognomePadre?.trim()?:"").toLowerCase() ) {
                            params = [anagrafe: "1", soggetto: "PADRE"]
                            anag = anagrafe.anagrafe1
                        }
                    }
                    break
                case ETipoCampoAnagrafe.NOME_PADRE:
                    if (anagrafe && anagrafe?.anagrafe1 && (getAtto() instanceof CivNascita) ){
                        CivNascita n = (CivNascita) getAtto()
                        if ( (anagrafe.anagrafe1?.nome?:"").toLowerCase() != (n.nomePadre?.trim()?:"").toLowerCase() ) {
                            params = [anagrafe: "1", soggetto: "PADRE"]
                            anag = anagrafe.anagrafe1
                        }
                    }
                    break
                case ETipoCampoAnagrafe.COGNOME_MADRE:
                    if (anagrafe && anagrafe?.anagrafe2 && (getAtto() instanceof CivNascita) ){
                        CivNascita n = (CivNascita) getAtto()
                        if ( (anagrafe.anagrafe2?.cognome?:"").toLowerCase() != (n.cognomeMadre?.trim()?:"").toLowerCase() ) {
                            params = [anagrafe: "2", soggetto: "MADRE"]
                            anag = anagrafe.anagrafe2
                        }
                    }
                    break
                case ETipoCampoAnagrafe.NOME_MADRE:
                    if (anagrafe && anagrafe?.anagrafe2 && (getAtto() instanceof CivNascita) ){
                        CivNascita n = (CivNascita) getAtto()
                        if ( (anagrafe.anagrafe2?.nome?:"").toLowerCase() != (n.nomeMadre?.trim()?:"").toLowerCase() ) {
                            params = [anagrafe: "2", soggetto: "MADRE"]
                            anag = anagrafe.anagrafe2
                        }
                    }
                    break
                case ETipoCampoAnagrafe.DATA_NASCITA_1:
                    if (anagrafe && anagrafe?.anagrafe1 && (getAtto() instanceof ISoggettoAtto1) ){
                        ISoggettoAtto1 sa1 = (ISoggettoAtto1) getAtto()
                        if ( anagrafe.anagrafe1?.dataNascita != sa1.dataNascita1 ) {
                            params = [anagrafe: "1", soggetto: "SOGGETTO_1"]
                            anag = anagrafe.anagrafe1

                        }
                    }
                    break
                case ETipoCampoAnagrafe.DATA_NASCITA_2:
                    if (anagrafe && anagrafe?.anagrafe2 && (getAtto() instanceof ISoggettoAtto2) ){
                        ISoggettoAtto2 sa2 = (ISoggettoAtto2) getAtto()
                        if ( anagrafe.anagrafe2?.dataNascita != sa2.dataNascita2 ) {
                            params = [anagrafe: "2", soggetto: "SOGGETTO_2"]
                            anag = anagrafe.anagrafe2
                        }
                    }
                    break
                case ETipoCampoAnagrafe.DATA_NASCITA_PADRE:
                    if (anagrafe && anagrafe?.anagrafe1 && (getAtto() instanceof CivNascita) ){
                        CivNascita n = (CivNascita) getAtto()
                        if ( anagrafe.anagrafe1?.dataNascita != n.dataNascitaPadre ) {
                            params = [anagrafe: "1", soggetto: "PADRE"]
                            anag = anagrafe.anagrafe1
                        }
                    }
                    break
                case ETipoCampoAnagrafe.DATA_NASCITA_MADRE:
                    if (anagrafe && anagrafe?.anagrafe2 && (getAtto() instanceof CivNascita) ){
                        CivNascita n = (CivNascita) getAtto()
                        if ( anagrafe.anagrafe2?.dataNascita != n.dataNascitaMadre ) {
                            params = [anagrafe: "2", soggetto: "MADRE"]
                            anag = anagrafe.anagrafe2
                        }
                    }
                    break
            }
            if (params && params.anagrafe && anag){
                String datiSoggetto = "(${anag.cognome} ${anag.nome} - ${anag.sesso.name()} - ${anag.dataNascita.format('dd/MM/yyyy')} - matr. ${anag.matricola})?"
                Messagebox.show(getEtichetta(EtichetteMessaggi.Ask_Collegamento_Anagrafe)+"\n "+datiSoggetto, msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event ev) {
                            if (Messagebox.ON_YES.equals(ev.getName())) {
                                log.info("Si è scelto di mantenere il collegamento con l'anagrafe")
                            }
                            if (Messagebox.ON_NO.equals(ev.getName())) {
                                if (params.anagrafe == "1"){
                                    anagrafe.anagrafe1 = null
                                }
                                if (params.anagrafe == "2"){
                                    anagrafe.anagrafe2 = null
                                }
                                Messagebox.show(getEtichetta(EtichetteMessaggi.Ask_Nuova_Ricerca_Anagrafe), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                                        new org.zkoss.zk.ui.event.EventListener() {
                                            void onEvent(Event ev2) {
                                                if (Messagebox.ON_YES.equals(ev2.getName())) {
                                                    onCaricaSoggetti(params.soggetto)
                                                }
                                                if (Messagebox.ON_NO.equals(ev2.getName())) {
                                                    log.info("Si è scelto dinon effettuare ricerca")
                                                    refreshUi()
                                                }
                                            }
                                        }
                                )

                            }
                        }
                    }
                )
            }
        }
    }

    @Command void onCalcolaCf(@BindingParam("tipoSoggetto") String tipoSoggetto) {
        calcolaCf(ETipoSoggetto.valueOf(tipoSoggetto))
    }

    protected void calcolaCf(ETipoSoggetto ts){
        String cf = null
        switch (ts) {
            case ETipoSoggetto.SOGGETTO_1: // NAS - CIT - DEC - PUBB - DIV - MAT - UCI - PVU - SCIO
                if (getAtto() instanceof ISoggettoAtto1) {
                    ISoggettoAtto1 sa = (ISoggettoAtto1) getAtto()
                    cf = calcolaCf(sa.cognome1, sa.nome1, sa.sesso1, sa.dataNascita1, sa.codiceProvinciaNascita1, sa.codiceComuneNascita1)
                }
                break
            case ETipoSoggetto.SOGGETTO_2: // PUBB - DIV - MAT - UCI - PVU - SCIO
                if (getAtto() instanceof ISoggettoAtto2){
                    ISoggettoAtto2 sa = (ISoggettoAtto2) getAtto()
                    cf = calcolaCf(sa.cognome2, sa.nome2, sa.sesso2, sa.dataNascita2, sa.codiceProvinciaNascita2, sa.codiceComuneNascita2)
                }
                break
        }
        if ( (cf?:StatoCivileService.ERRORE_CAMPI_CF) == StatoCivileService.ERRORE_CAMPI_CF ){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_campi_cf), getEtichetta(Etichette.Calcolo_Codice_Fiscale), Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            switch (ts) {
                case ETipoSoggetto.SOGGETTO_1: // NAS - CIT - DEC - PUBB - DIV - MAT - UCI - PVU - SCIO
                    if (getAtto() instanceof ISoggettoAtto1) {
                        ISoggettoAtto1 sa = (ISoggettoAtto1) getAtto()
                        sa.codiceFiscale1 = cf
                        sa.setCfCalcolato1(Boolean.TRUE)
                    }
                    break
                case ETipoSoggetto.SOGGETTO_2: // PUBB - DIV - MAT - UCI - PVU - SCIO
                    if (getAtto() instanceof ISoggettoAtto2){
                        ISoggettoAtto2 sa = (ISoggettoAtto2) getAtto()
                        sa.codiceFiscale2 = cf
                        sa.setCfCalcolato2(Boolean.TRUE)
                    }
                    break
            }
            refreshUi()
        }
    }

}
