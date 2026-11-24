package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.competenze.CompetenzeRuntimeException
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreDatiFascicoloRuntimeException
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.smartdoc.api.DocumentaleRuntimeException
import it.finmatica.smartdoc.api.struct.Campo
import it.finmatica.smartdoc.api.struct.Documento
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

import javax.persistence.criteria.JoinType

@Slf4j
@Transactional
@Service
class CivArchivioComunicazioneService implements IArchivioComunicazioneService, TraitArchivioComunicazioneService {

    private final ArcParametroService arcParametroService

    private final CivMargineService civMargineService

    private final CivSposiAttoService civSposiAttoService

    private final GsdService gsdService

    private final CompetenzaService competenzaService

    private final CivFascicoloAttoService civFascicoloAttoService

    private final CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService

    private final IntegrazioneDocumentaleService integrazioneDocumentaleService

    private final CivArchivioComunicazioneRepository civArchivioComunicazioneRepository

    CivArchivioComunicazioneService(ArcParametroService arcParametroService,
                                    CivArchivioComunicazioneRepository civArchivioComunicazioneRepository, GsdService gsdService,
                                    CivSposiAttoService civSposiAttoService, CivMargineService civMargineService, CompetenzaService competenzaService,
                                    CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService,
                                    CivFascicoloAttoService civFascicoloAttoService, IntegrazioneDocumentaleService integrazioneDocumentaleService) {

        this.arcParametroService = arcParametroService
        this.civArchivioComunicazioneRepository = civArchivioComunicazioneRepository
        this.gsdService = gsdService
        this.civSposiAttoService = civSposiAttoService
        this.civMargineService = civMargineService
        this.competenzaService = competenzaService
        this.civFascicoloAttoService = civFascicoloAttoService
        this.civFascicoloAttoAllegatoService = civFascicoloAttoAllegatoService
        this.integrazioneDocumentaleService = integrazioneDocumentaleService
    }

    @Override
    IArchivioComunicazioneRepository getArchivioComunicazioneRepository() {
        return civArchivioComunicazioneRepository
    }

    @Override
    GsdService getGsdService() {
        return gsdService
    }

    CivArchivioComunicazione create() {
        return new CivArchivioComunicazione(versione: new Integer(1), stampaEseguita: Boolean.FALSE)
    }

    Page<CivArchivioComunicazione> list(Map params) {
        return civArchivioComunicazioneRepository.listByParams(params)
    }

    List<CivArchivioComunicazione> listAllByUkAttoAndTipoAtto(Integer tipoAtto, Integer ufficio, Integer anno, Integer atto, Integer parte, String serie, Map params) {
        return civArchivioComunicazioneRepository.findAllByUkAttoAndTipoAtto(tipoAtto, ufficio, anno, atto, parte, serie, params)
    }

    List<CivArchivioComunicazione> listAllComunicazioniDaAnnotazioneByAnnotazione(CivAnnotazioneAtto ann) {
        // Gestisco eventuali valori di default e vado su tutti i campi per compatibilità la gestione pre-zk
        Integer tipoAtto = ann.tipoAtto
        Integer ufficio = ann.ufficio
        Integer anno = ann.anno
        Integer atto = ann.atto
        String serie = (ann.serie ?: "XXXXXXXXXXX")
        // Le citt non hanno né parte né serie
        Integer parte = (ann.parte ?: new Integer(-101))
        String formula = ann.formula
        Date dataRegistrazione = ann.dataRegistrazione
        Integer sequenza = ann.sequenza ?: new Integer(-1)
        if (ufficio && anno && atto && parte && serie && tipoAtto && formula) {
            return civArchivioComunicazioneRepository.findAllComunicazioniDaAnnotazione(ufficio, anno, atto, parte, serie, tipoAtto, formula, dataRegistrazione, sequenza)
        } else {
            return []
        }
    }

    List<CivArchivioComunicazione> listAllComunicazioniDaAnnotazioneByUkAtto(CivAttoBaseDomain atto, CivDatiProvenienzaAtto datiProvenienza, Boolean priorita) {
        List<CivArchivioComunicazione> l = []
        switch (atto.getTipoAttoEnum()) {
            case ETipoAtto.MAT:
            case ETipoAtto.UCI:
                Integer tipoAttoAnnotazioneSuAttoNascitaAltroComune
                if (atto.getTipoAttoEnum() == ETipoAtto.MAT) {
                    tipoAttoAnnotazioneSuAttoNascitaAltroComune = new Integer(CivMatrimonio.tipoAttoAnnotazioneSuAttoNascitaAltroComune)
                } else {
                    tipoAttoAnnotazioneSuAttoNascitaAltroComune = new Integer(CivUnioneCivile.tipoAttoAnnotazioneSuAttoNascitaAltroComune)
                }
                List<CivArchivioComunicazione> lAltroComuneNas = listAllByUkAttoAndTipoAtto(tipoAttoAnnotazioneSuAttoNascitaAltroComune, atto.ufficio, atto.anno, atto.atto, atto.parte, atto.serie,
                        [priorita: priorita, fetch: [[campo: 'comunicazione', tipo: JoinType.INNER], [campo: 'formulaDfa', tipo: JoinType.INNER]],
                         order   : SortUtils.dataRegistrazioneAsc]) ?: []
                l.addAll(lAltroComuneNas)

                if (((IAttoMatUci) atto).divorzio) {
                    Integer tipoAttoAnnotazioneSuAttoMatUciAltroComune
                    if (atto.getTipoAttoEnum() == ETipoAtto.MAT) {
                        tipoAttoAnnotazioneSuAttoMatUciAltroComune = new Integer(CivMatrimonio.tipoAttoAnnotazioneSuAttoMatrimonioAltroComune)
                    } else {
                        tipoAttoAnnotazioneSuAttoMatUciAltroComune = new Integer(CivUnioneCivile.tipoAttoAnnotazioneSuAttoUnioneCivileAltroComune)
                    }
                    List<CivArchivioComunicazione> lAltroComuneMat = listAllByUkAttoAndTipoAtto(tipoAttoAnnotazioneSuAttoMatUciAltroComune, atto.ufficio, atto.anno, atto.atto, atto.parte, atto.serie,
                            [priorita: priorita, fetch: [[campo: 'comunicazione', tipo: JoinType.INNER], [campo: 'formulaDfa', tipo: JoinType.INNER]],
                             order   : SortUtils.dataRegistrazioneAsc]) ?: []
                    l.addAll(lAltroComuneMat)
                }
                CivSposiAtto sposi = civSposiAttoService.getByUkAttoAndTipoAtto(atto.idAtto, atto.tipoAtto)
                if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
                    List<CivArchivioComunicazione> lNasSposo = listByScenarioAndPrimarioDomainAndAttoSecondarioAndPriorita(EScenarioEstremiAttoPrimario.Nascita1,
                            sposi,
                            datiProvenienza,
                            atto,
                            priorita)
                    l.addAll(lNasSposo)
                    List<CivArchivioComunicazione> lNasSposa = listByScenarioAndPrimarioDomainAndAttoSecondarioAndPriorita(EScenarioEstremiAttoPrimario.Nascita2,
                            sposi,
                            datiProvenienza,
                            atto,
                            priorita)
                    l.addAll(lNasSposa)
                    List<CivArchivioComunicazione> lMat = listByScenarioAndPrimarioDomainAndAttoSecondarioAndPriorita(EScenarioEstremiAttoPrimario.Matrimonio,
                            sposi,
                            datiProvenienza,
                            atto,
                            priorita)
                    l.addAll(lMat)
                } else {
                    if ((sposi?.ufficioAttoNascita1 != null) && (sposi?.attoAttoNascita1 != null) && (sposi?.getParteAttoNascita1() != null) && (sposi?.annoAttoNascita1 != null)
                            && (datiProvenienza?.formulaDfaAnnotazioneNascita1) && sposi?.comuneAttoNascita1Utente) {
                        // atto di nascita del comune utente
                        List<CivArchivioComunicazione> lNasSposo = listAllByUkAttoAndTipoAtto(new Integer(ETipoAtto.NAS.valore), sposi.ufficioAttoNascita1, sposi.annoAttoNascita1,
                                sposi.attoAttoNascita1, sposi.getParteAttoNascita1(), sposi.serieAttoNascita1,
                                [idAttoRif: atto.idAtto, formulaDfa: datiProvenienza.formulaDfaAnnotazioneNascita1, priorita: priorita, fetch: [[campo: 'comunicazione', tipo: JoinType.INNER], [campo: 'formulaDfa', tipo: JoinType.INNER]],
                                 order    : SortUtils.dataRegistrazioneAsc]) ?: []
                        l.addAll(lNasSposo)
                    }
                    if ((sposi?.ufficioAttoNascita2 != null) && (sposi?.attoAttoNascita2 != null) && (sposi?.getParteAttoNascita2() != null) && (sposi?.annoAttoNascita2 != null)
                            && (datiProvenienza?.formulaDfaAnnotazioneNascita2) && sposi?.comuneAttoNascita2Utente) {
                        // atto di nascita del comune utente
                        List<CivArchivioComunicazione> lNasSposa = listAllByUkAttoAndTipoAtto(new Integer(ETipoAtto.NAS.valore), sposi.ufficioAttoNascita2, sposi.annoAttoNascita2,
                                sposi.attoAttoNascita2, sposi.getParteAttoNascita2(), sposi.serieAttoNascita2,
                                [idAttoRif: atto.idAtto, formulaDfa: datiProvenienza.formulaDfaAnnotazioneNascita2, priorita: priorita, fetch: [[campo: 'comunicazione', tipo: JoinType.INNER], [campo: 'formulaDfa', tipo: JoinType.INNER]],
                                 order    : SortUtils.dataRegistrazioneAsc]) ?: []
                        l.addAll(lNasSposa)
                    }
                    // Controllo se l'atto di matrimonio/unione civile è un divorzio
                    // Escludo, quindi, l'ottenimento delle comunicazioni sulle unioni civili (NON separazioni),
                    // nonostante esse generino comunicazioni sull'eventuale atto di matrimonio dei contraenti
                    if (((IAttoMatUci) atto).divorzio && (sposi?.ufficioAttoMatrimonio != null) && (sposi?.attoAttoMatrimonio != null) && (sposi?.getParteAttoMatrimonio() != null) && (sposi?.annoAttoMatrimonio != null)
                            && (datiProvenienza?.formulaDfaAnnotazioneMatrimonio) && sposi?.comuneAttoMatrimonioUtente) {
                        // atto di matrimonio del comune utente
                        List<CivArchivioComunicazione> lMat = listAllByUkAttoAndTipoAtto(new Integer(atto.getTipoAttoEnum().valore), sposi.ufficioAttoMatrimonio, sposi.annoAttoMatrimonio,
                                sposi.attoAttoMatrimonio, sposi.getParteAttoMatrimonio(), sposi.serieAttoMatrimonio,
                                [idAttoRif: atto.idAtto, formulaDfa: datiProvenienza.formulaDfaAnnotazioneMatrimonio, priorita: priorita, fetch: [[campo: 'comunicazione', tipo: JoinType.INNER], [campo: 'formulaDfa', tipo: JoinType.INNER]],
                                 order    : SortUtils.dataRegistrazioneAsc]) ?: []
                        l.addAll(lMat)
                    }
                }
                break
            case ETipoAtto.MOR:
            case ETipoAtto.CIT:
                Integer tipoAttoAnnotazioneSuAttoNascitaAltroComune
                if (atto.getTipoAttoEnum() == ETipoAtto.MOR) {
                    tipoAttoAnnotazioneSuAttoNascitaAltroComune = new Integer(CivMorte.tipoAttoAnnotazioneSuAttoNascitaAltroComune)
                } else {
                    tipoAttoAnnotazioneSuAttoNascitaAltroComune = new Integer(CivCittadinanza.tipoAttoAnnotazioneSuAttoNascitaAltroComune)
                }
                List<CivArchivioComunicazione> lAltroComuneNas = listAllByUkAttoAndTipoAtto(tipoAttoAnnotazioneSuAttoNascitaAltroComune, atto.ufficio, atto.anno, atto.atto, atto.parte, atto.serie,
                        [priorita: priorita, fetch: [[campo: 'comunicazione', tipo: JoinType.INNER], [campo: 'formulaDfa', tipo: JoinType.INNER]],
                         order   : SortUtils.dataRegistrazioneAsc]) ?: []
                l.addAll(lAltroComuneNas)
                CivMargine margine = civMargineService.getByUkAtto(atto.idAtto)
                if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
                    List<CivArchivioComunicazione> lNasComuneUte = listByScenarioAndPrimarioDomainAndAttoSecondarioAndPriorita(EScenarioEstremiAttoPrimario.Nascita1,
                            margine,
                            datiProvenienza,
                            atto,
                            priorita)
                    l.addAll(lNasComuneUte)
                } else {
                    if ((margine?.ufficioAttoNascita1 != null) && (margine?.attoAttoNascita1 != null) && (margine?.getParteAttoNascita1() != null) && (margine?.annoAttoNascita1 != null)
                            && (datiProvenienza?.formulaDfaAnnotazioneNascita1) && margine?.comuneAttoNascita1Utente) {
                        // atto di nascita del comune utente
                        List<CivArchivioComunicazione> lNasComuneUte = listAllByUkAttoAndTipoAtto(new Integer(ETipoAtto.NAS.valore), margine.ufficioAttoNascita1, margine.annoAttoNascita1,
                                margine.attoAttoNascita1, margine.getParteAttoNascita1(), margine.serieAttoNascita,
                                [idAttoRif: atto.idAtto, formulaDfa: datiProvenienza.formulaDfaAnnotazioneNascita1, priorita: priorita, fetch: [[campo: 'comunicazione', tipo: JoinType.INNER], [campo: 'formulaDfa', tipo: JoinType.INNER]],
                                 order    : SortUtils.dataRegistrazioneAsc]) ?: []
                        l.addAll(lNasComuneUte)
                    }
                }
                break
        }
        return l
    }

    private List<CivArchivioComunicazione> listByScenarioAndPrimarioDomainAndAttoSecondarioAndPriorita(EScenarioEstremiAttoPrimario scenario,
                                                                                                       def estremiAttoPrimarioDomain,
                                                                                                       CivDatiProvenienzaAtto datiProvenienza,
                                                                                                       CivAttoBaseDomain attoSecondario,
                                                                                                       Boolean priorita) {
        String idAttoAnscPrimario, formulaDfa, seriePrimario
        Integer ufficioPrimario, numeroAttoPrimario, annoPrimario, partePrimario
        ETipoAtto tipoAttoPrimario
        boolean shouldSearchComunicazioni

        switch (scenario) {
            case EScenarioEstremiAttoPrimario.Nascita1:
                IEstremiAttoNascitaSoggetto1Domain domain = (IEstremiAttoNascitaSoggetto1Domain) estremiAttoPrimarioDomain

                idAttoAnscPrimario = domain?.idAttoAnscNascita1
                ufficioPrimario = domain?.ufficioAttoNascita1
                numeroAttoPrimario = domain?.attoAttoNascita1
                annoPrimario = domain?.annoAttoNascita1
                partePrimario = domain?.getParteAttoNascita1()
                seriePrimario = domain?.serieAttoNascita1

                formulaDfa = datiProvenienza?.formulaDfaAnnotazioneNascita1

                tipoAttoPrimario = ETipoAtto.NAS

                boolean domainContainsAtto = idAttoAnscPrimario || (ufficioPrimario != null && numeroAttoPrimario != null && partePrimario != null && annoPrimario != null)
                shouldSearchComunicazioni = domainContainsAtto &&
                        formulaDfa &&
                        estremiAttoPrimarioDomain?.getComuneAttoNascita1Utente()
                break
            case EScenarioEstremiAttoPrimario.Nascita2:
                IEstremiAttoNascitaSoggetto2Domain domain = (IEstremiAttoNascitaSoggetto2Domain) estremiAttoPrimarioDomain

                idAttoAnscPrimario = domain?.idAttoAnscNascita2
                ufficioPrimario = domain?.ufficioAttoNascita2
                numeroAttoPrimario = domain?.attoAttoNascita2
                annoPrimario = domain?.annoAttoNascita2
                partePrimario = domain?.getParteAttoNascita2()
                seriePrimario = domain?.serieAttoNascita2

                formulaDfa = datiProvenienza?.formulaDfaAnnotazioneNascita2

                tipoAttoPrimario = ETipoAtto.NAS

                boolean domainContainsAtto = idAttoAnscPrimario || (ufficioPrimario != null && numeroAttoPrimario != null && partePrimario != null && annoPrimario != null)
                shouldSearchComunicazioni = domainContainsAtto &&
                        formulaDfa &&
                        estremiAttoPrimarioDomain?.getComuneAttoNascita2Utente()
                break
            case EScenarioEstremiAttoPrimario.Matrimonio:
                IEstremiAttoMatrimonioDomain domain = (IEstremiAttoMatrimonioDomain) estremiAttoPrimarioDomain

                idAttoAnscPrimario = domain?.idAttoAnscMatrimonio
                ufficioPrimario = domain?.ufficioAttoMatrimonio
                numeroAttoPrimario = domain?.attoAttoMatrimonio
                annoPrimario = domain?.annoAttoMatrimonio
                partePrimario = domain?.getParteAttoMatrimonio()
                seriePrimario = domain?.serieAttoMatrimonio

                formulaDfa = datiProvenienza?.formulaDfaAnnotazioneMatrimonio

                tipoAttoPrimario = attoSecondario.tipoAttoEnum

                boolean domainContainsAtto = idAttoAnscPrimario || (ufficioPrimario != null && numeroAttoPrimario != null && partePrimario != null && annoPrimario != null)

                // Controllo se l'atto di matrimonio/unione civile è un divorzio
                // Escludo, quindi, l'ottenimento delle comunicazioni sulle unioni civili (NON separazioni),
                // nonostante esse generino comunicazioni sull'eventuale atto di matrimonio dei contraenti
                shouldSearchComunicazioni = (attoSecondario as IAttoMatUci).divorzio &&
                        domainContainsAtto &&
                        formulaDfa &&
                        estremiAttoPrimarioDomain?.getComuneAttoMatrimonioUtente()
                break
            default:
                throw new De4gsdzkRuntimeException("Impossibile estrarre i dati per lo scenario $scenario")
        }

        if (!shouldSearchComunicazioni) {
            return []
        }

        EstremiAtto estremiAnalogiciPrimario
        if (idAttoAnscPrimario != null) {
            CivAttoBaseDomain primario
            switch (scenario) {
                case EScenarioEstremiAttoPrimario.Nascita1:
                case EScenarioEstremiAttoPrimario.Nascita2:
                    CivNascitaService civNascitaService = Holders.getApplicationContext().getBean(CivNascitaService.class)
                    primario = civNascitaService.getByIdAttoAnsc(idAttoAnscPrimario)
                    break
                case EScenarioEstremiAttoPrimario.Matrimonio:
                    if (attoSecondario.tipoAttoEnum == ETipoAtto.MAT) {
                        CivMatrimonioService civMatrimonioService = Holders.getApplicationContext().getBean(CivMatrimonioService.class)
                        primario = civMatrimonioService.getByIdAttoAnsc(idAttoAnscPrimario)
                    } else {
                        CivUnioneCivileService civUnioneCivileService = Holders.getApplicationContext().getBean(CivUnioneCivileService.class)
                        primario = civUnioneCivileService.getByIdAttoAnsc(idAttoAnscPrimario)
                    }
                    break
            }
            estremiAnalogiciPrimario = new EstremiAtto(ufficio: primario.ufficio, anno: primario.anno, atto: primario.atto, parte: primario.parte, serie: primario.serie)
        } else {
            estremiAnalogiciPrimario = new EstremiAtto(ufficio: ufficioPrimario, anno: annoPrimario, atto: numeroAttoPrimario, parte: partePrimario, serie: seriePrimario)
        }

        List<CivArchivioComunicazione> lComunicazioni = listAllByUkAttoAndTipoAtto(
                tipoAttoPrimario.valore,
                estremiAnalogiciPrimario.ufficio,
                estremiAnalogiciPrimario.anno,
                estremiAnalogiciPrimario.atto,
                estremiAnalogiciPrimario.parte,
                estremiAnalogiciPrimario.serie,
                [idAttoRif : attoSecondario.idAtto,
                 formulaDfa: formulaDfa,
                 priorita  : priorita,
                 fetch     : [[campo: 'comunicazione', tipo: JoinType.INNER],
                              [campo: 'formulaDfa', tipo: JoinType.INNER]],
                 order     : SortUtils.dataRegistrazioneAsc]) ?: []
        return lComunicazioni
    }

    Page<CivArchivioComunicazione> listAllByTipoAttoAndEnteDestinatarioAndStampaEseguita(ETipoAtto tipoAttoEnum, Integer idEnte, Boolean stampaEseguita, PageRequest p) {
        return civArchivioComunicazioneRepository.findAllByTipoAttoAndEnteDestinatarioAndStampaEseguita(new Integer(tipoAttoEnum.valore), idEnte, stampaEseguita, p)
    }

    Page<CivArchivioComunicazione> listAllByTipoAttoAndComuneDestinatarioAndStampaEseguita(ETipoAtto tipoAttoEnum, Integer codiceComune, Integer codiceProvincia, Boolean stampaEseguita, PageRequest p) {
        return civArchivioComunicazioneRepository.findAllByTipoAttoAndComuneAndStampaEseguita(new Integer(tipoAttoEnum.valore), codiceComune, codiceProvincia, stampaEseguita, p)
    }

    @Override
    void validaDati(IArchivioComunicazione _obj, Boolean ignoreStampaEseguita, Boolean ignoreStato) {
        CivArchivioComunicazione obj = _obj as CivArchivioComunicazione
        if ((obj.tipoAtto == null) || (obj.comunicazione?.id == null)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_comunicazione"))
        }

        Boolean emptyMandatoryFields = Boolean.TRUE
        switch (obj.getTipoAttoRifEnum()) {
            case ETipoAtto.NAS:
            case ETipoAtto.MAT:
            case ETipoAtto.PUB:
            case ETipoAtto.MOR:
                //FIXME: check su obbligatorietà serie per atti "normali" e atti pregressi
                emptyMandatoryFields = ((obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) || (obj.parte == null))
                break
            case ETipoAtto.UCI:
                //FIXME: Bisognerebbe discriminare fra processi verbali e unioni civili
                emptyMandatoryFields = ((obj.ufficio == null) || (obj.anno == null) || (obj.atto == null))
                break
            case ETipoAtto.CIT:
                emptyMandatoryFields = ((obj.ufficio == null) || (obj.anno == null) || (obj.atto == null))
                break
        }

        if (emptyMandatoryFields) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_comunicazione"))
        }

        if (!(competenzaService.isCivSuperUser())) {
            throw new CompetenzeRuntimeException(Etichette.getEtichetta("Errore_Competenze_Comunicazioni"))
        }

        if (!(ignoreStato)) {
            bloccaSeProtocollata(obj)

            bloccaSeInviataAlbo(obj)
        }

        //Caso rigenerazione del testo
        if (!(ignoreStampaEseguita)) {
            bloccaSeStampaEseguita(obj)
        }
    }

    CivArchivioComunicazione save(CivArchivioComunicazione obj, Boolean ignoreStampaEseguita = Boolean.FALSE, Boolean ignoreStato = Boolean.FALSE, Boolean salvaSuDocumentale = Boolean.FALSE) {
        validaDati(obj, ignoreStampaEseguita, ignoreStato)

        if (salvaSuDocumentale) {
            if (obj.idDocumentoEsterno == null) {
                // Devo salvare su gdm
                String identificativo = (obj.idAtto ?: gsdService.getIdentificativoAtto(obj.tipoAtto, obj.ufficio, obj.anno, obj.parte, obj.serie, obj.atto))
                List<Campo> metadati = MetadatiGdmUtils.listMetadatiAtto(obj, identificativo)
                Documento smartDoc = integrazioneDocumentaleService.salva(obj, metadati, EModelloGdm.FascicoliStatoCivile)
                if (smartDoc.id != null) {
                    obj.idDocumentoEsterno = Long.parseLong(smartDoc.id)
                } else {
                    throw new DocumentaleRuntimeException("Errore in fase di salvataggio: impossibile registrare il documento su sistema documentale")
                }
            }
        }

        if (obj.id == null) {
            // solo in caso di inserimento
            obj.id = gsdService.getIdFromSequence(obj)
        }
        log.info("Lancio salvataggio su CIVCOM per id " + obj.id)
        CivArchivioComunicazione savedCom = civArchivioComunicazioneRepository.save(obj)
        return savedCom
    }

    CivFascicoloAtto fascicolaComunicazione(CivArchivioComunicazione obj, IDaFascicolare df, Boolean salvaPregressoSuDocumentale = Boolean.FALSE) {
        if (salvaPregressoSuDocumentale) {
            save(obj, Boolean.TRUE, Boolean.TRUE, Boolean.TRUE)
        }
        //Posso leggere id_atto da arcCom perchè arcCom è già su db
        CivFascicoloAtto fa = civFascicoloAttoService.getByUkAttoAndTipoAttoAndArchivioComunicazione(obj.idAtto, obj.tipoAtto, obj)
        if (fa == null) {
            CivTipoDocumentoFascicolo tdf = df.tipoDocumentoFascicolo
            if (obj.isAttoDiAltroComune() && (df instanceof CivComunicazioneFormula)) {
                tdf = (df.tipoDocumentoFascicoloRif ?: df.tipoDocumentoFascicolo)
            }
            if (tdf == null) {
                throw new ErroreDatiFascicoloRuntimeException(Etichette.getEtichetta("Errore_no_tipo_documento_x_fascicolazione"))
            }
            CivFascicoloAtto newFa = civFascicoloAttoService.createXComunicazione(obj, tdf)
            fa = civFascicoloAttoService.save(newFa, Boolean.FALSE)
        }
        return fa
    }

    //ATTENZIONE: cancella solo la comunicazione: occorre prima essere sicuri di aver cancellato gli allegati collegati in civcom_alle
    void deleteComunicazione(IArchivioComunicazione _obj) {
        CivArchivioComunicazione obj = _obj as CivArchivioComunicazione
        validaDati(obj, Boolean.FALSE, Boolean.FALSE)
        // Cancello dal documentale
        if (obj.idDocumentoEsterno != null) {
            integrazioneDocumentaleService.eliminaDocumento(obj, true)
        }
        // Cancello dal fascicolo
        CivFascicoloAtto fa = civFascicoloAttoService.getByUkAttoAndTipoAttoAndArchivioComunicazione(obj.idAtto, obj.tipoAtto, obj)
        if (fa != null) {
            civFascicoloAttoAllegatoService.deleteFascicoloEAllegati(fa)
        }
        //Cancello da civcom
        log.info("Tento cancellazione su CIVCOM per id " + obj.id)
        civArchivioComunicazioneRepository.delete(obj)
    }

    String protocollaComunicazione(Long id){
        return gsdService.protocollaComunicazioneCiv(id)
    }

    String inviaAlboComunicazione(IArchivioComunicazione obj) {
        return gsdService.inviaAlboComunicazioneCiv(obj as CivArchivioComunicazione)
    }

}
