package it.finmatica.de4gsdzk.certificazione.emissione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdAnagrafeBaseDomain
import it.finmatica.de4gsdzk.GsdMenuDittaService
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.*
import it.finmatica.de4gsdzk.certificazione.embed.Beneficiario
import it.finmatica.de4gsdzk.certificazione.embed.Richiedente
import it.finmatica.de4gsdzk.certificazione.generazione.*
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAttoService
import it.finmatica.de4gsdzk.statocivile.CivAttoService
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.FileUtils
import it.finmatica.smartdoc.api.DocumentaleRuntimeException
import org.springframework.stereotype.Service

@Slf4j
@Service
class EmissioneCertificatoService {

    private final GenerazioneCertificatoServiceFactory generazioneCertificatoServiceFactory
    private final GenerazioneCertificatoParamsFactory generazioneCertificatoParamsFactory
    private final CerCertificatoEmessoService cerCertificatoEmessoService
    private final CerTipoCertificatoService cerTipoCertificatoService
    private final CerStatoCivileFiltroService cerStatoCivileFiltroService
    private final CerIndividuoCertificatoService cerIndividuoCertificatoService
    private final CerTerminalistaService cerTerminalistaService
    private final CerTipoRichiedenteService cerTipoRichiedenteService
    private final CivAttoService civAttoService
    private final CivAnnotazioneAttoService civAnnotazioneAttoService
    private final AnaAnagrafeService anaAnagrafeService
    private final AnaTipoDocumentoService anaTipoDocumentoService
    private final AnaDocumentoService anaDocumentoService
    private final AnaDocumentoAllegatoService anaDocumentoAllegatoService
    private final ArcParametroService arcParametroService
    private final GsdMenuDittaService gsdMenuDittaService
    private final StatoCivileService statoCivileService
    private final UtenteCustomService utenteCustomService

    EmissioneCertificatoService(GenerazioneCertificatoServiceFactory generazioneCertificatoServiceFactory,
                                GenerazioneCertificatoParamsFactory generazioneCertificatoParamsFactory,
                                CerCertificatoEmessoService cerCertificatoEmessoService,
                                CerTipoCertificatoService cerTipoCertificatoService,
                                CerStatoCivileFiltroService cerStatoCivileFiltroService,
                                CerIndividuoCertificatoService cerIndividuoCertificatoService,
                                CerTerminalistaService cerTerminalistaService,
                                CerTipoRichiedenteService cerTipoRichiedenteService,
                                CivAttoService civAttoService,
                                CivAnnotazioneAttoService civAnnotazioneAttoService,
                                AnaAnagrafeService anaAnagrafeService,
                                AnaTipoDocumentoService anaTipoDocumentoService,
                                AnaDocumentoService anaDocumentoService,
                                AnaDocumentoAllegatoService anaDocumentoAllegatoService,
                                ArcParametroService arcParametroService,
                                GsdMenuDittaService gsdMenuDittaService,
                                StatoCivileService statoCivileService,
                                UtenteCustomService utenteCustomService) {
        this.generazioneCertificatoServiceFactory = generazioneCertificatoServiceFactory
        this.generazioneCertificatoParamsFactory = generazioneCertificatoParamsFactory
        this.cerCertificatoEmessoService = cerCertificatoEmessoService
        this.cerTipoCertificatoService = cerTipoCertificatoService
        this.cerStatoCivileFiltroService = cerStatoCivileFiltroService
        this.cerIndividuoCertificatoService = cerIndividuoCertificatoService
        this.cerTerminalistaService = cerTerminalistaService
        this.cerTipoRichiedenteService = cerTipoRichiedenteService
        this.civAttoService = civAttoService
        this.civAnnotazioneAttoService = civAnnotazioneAttoService
        this.anaAnagrafeService = anaAnagrafeService
        this.anaTipoDocumentoService = anaTipoDocumentoService
        this.anaDocumentoService = anaDocumentoService
        this.anaDocumentoAllegatoService = anaDocumentoAllegatoService
        this.arcParametroService = arcParametroService
        this.gsdMenuDittaService = gsdMenuDittaService
        this.statoCivileService = statoCivileService
        this.utenteCustomService = utenteCustomService
    }

    List<CerTipoRichiedente> listAllTipoRichiedenteOptions() {
        return cerTipoRichiedenteService.listAll()
    }

    CerTipoRichiedente getDefaultTipoRichiedenteOption() {
        return cerTipoRichiedenteService.get(CerTipoRichiedente.ISTANZA_DI_PARTE)
    }

    Beneficiario createBeneficiario(GsdAnagrafeBaseDomain ana) {
        Beneficiario beneficiario = new Beneficiario()
        beneficiario.nome = ana.nome
        beneficiario.cognome = ana.cognome
        beneficiario.codiceFiscale = ana.codiceFiscale
        beneficiario.sesso = ana.sesso
        beneficiario.dataNascita = ana.dataNascita
        beneficiario.comuneNascita = new Comune()
        beneficiario.comuneNascita.codice = ana.codiceComuneNascita
        beneficiario.comuneNascita.descrizione = ana.descrizioneComuneNascita
        beneficiario.comuneNascita.codiceProvincia = ana.codiceProvinciaNascita
        beneficiario.comuneNascita.siglaProvincia = ana.siglaProvinciaNascita
        return beneficiario
    }

    Richiedente createRichiedente(GsdAnagrafeBaseDomain ana) {
        Richiedente richiedente = new Richiedente()
        richiedente.nome = ana.nome
        richiedente.cognome = ana.cognome
        richiedente.codiceFiscale = ana.codiceFiscale
        richiedente.sesso = ana.sesso
        richiedente.dataNascita = ana.dataNascita
        richiedente.nazionalita = ana.nazionalita
        richiedente.comuneNascita = new Comune()
        richiedente.comuneNascita.codice = ana.codiceComuneNascita
        richiedente.comuneNascita.descrizione = ana.descrizioneComuneNascita
        richiedente.comuneNascita.codiceProvincia = ana.codiceProvinciaNascita
        richiedente.comuneNascita.siglaProvincia = ana.siglaProvinciaNascita
        richiedente.note = ""
        richiedente.tipoDocumento = null
        richiedente.numeroDocumento = ""
        richiedente.dataRilascioDocumento = null
        return richiedente
    }

    CerCertificatoEmesso createCertificatoEmesso(EmissioneCertificatoViewState emissioneCertificatoState) {
        CerCertificatoEmesso certificato = cerCertificatoEmessoService.create()
        certificato.beneficiario = emissioneCertificatoState.beneficiarioState.beneficiario

        if (emissioneCertificatoState.tipoRichiedente.isAltroRichiedente()) {
            certificato.richiedente = emissioneCertificatoState.richiedenteState.richiedente
        } else {
            certificato.richiedente = createRichiedente(emissioneCertificatoState.beneficiarioState.anagrafe)
        }

        certificato.tipoRichiedente = emissioneCertificatoState.tipoRichiedente
        certificato.tipoCertificato = emissioneCertificatoState.tipoCertificato
        certificato.dataStorico = emissioneCertificatoState.dataStorico
        certificato.modalitaRilascio = emissioneCertificatoState.modalitaRilascio
        certificato.descrizioneModalitaStampaLibera = emissioneCertificatoState.descrizioneModalitaStampaLibera
        certificato.tipoPagamento = emissioneCertificatoState.tipoPagamento
        certificato.terminalista = emissioneCertificatoState.terminalista
        certificato.cognomeNomeTerminalista = emissioneCertificatoState.cognomeNomeTerminalista
        certificato.qualificaTerminalista = emissioneCertificatoState.qualificaTerminalista
        certificato.flagInStampaTerminalista = emissioneCertificatoState.flagInStampaTerminalista
        certificato.segreteria = emissioneCertificatoState.diritti.segreteria.importo
        certificato.statoCivile = emissioneCertificatoState.diritti.statoCivile.importo
        certificato.cartaIdentita = emissioneCertificatoState.diritti.cartaIdentita.importo
        certificato.rimborsoStampati = emissioneCertificatoState.diritti.rimborsoStampati.importo
        certificato.bollo = emissioneCertificatoState.diritti.bollo.importo

        return certificato
    }

    boolean isDocumentoRichiedenteMandatory(ETipoGenerazioneCertificato tipoGenerazioneCertificato, GsdAnagrafeBaseDomain anagrafe) {
        if (tipoGenerazioneCertificato == ETipoGenerazioneCertificato.ANPR &&
                !(anagrafe instanceof AnpAnagrafe)) {
            return true
        }

        return false
    }

    boolean isDatiAnagraficiAggiuntiviRichiedenteMandatory(ETipoGenerazioneCertificato tipoGenerazioneCertificato) {
        if (tipoGenerazioneCertificato == ETipoGenerazioneCertificato.ANSC) {
            return true
        }

        return false
    }

    boolean isDataStoricoMandatory(CerTipoCertificato tipoCertificato) {
        if(tipoCertificato == null) {
            return false
        }

        if (tipoCertificato.isStorico()) {
            return true
        }

        return false
    }

    IGenerazioneCertificatoParams getGenerazioneCertificatoParams(ETipoGenerazioneCertificato tipoGenerazioneCertificato) {
        generazioneCertificatoParamsFactory.getObject(tipoGenerazioneCertificato)
    }

    IGenerazioneCertificatoService getGenerazioneCertificatoService(ETipoGenerazioneCertificato tipoGenerazioneCertificato) {
        generazioneCertificatoServiceFactory.getObject(tipoGenerazioneCertificato)
    }

    void saveAllegato(CerCertificatoEmesso certificatoEmesso, CertificatoGenerato certificatoGenerato) {
        certificatoEmesso.nomeAllegato = certificatoGenerato.generateNomeFile(certificatoEmesso.idEmissione)

        try {
            cerCertificatoEmessoService.saveAllegatoDocumentale(certificatoEmesso, certificatoGenerato.bytes)

            CerCertificatoEmesso c = cerCertificatoEmessoService.get(certificatoEmesso.id)
            cerCertificatoEmessoService.downloadAllegato(c)
        } catch (DocumentaleRuntimeException dre) {
            log.error(dre.message, dre)

            cerCertificatoEmessoService.saveAllegatoLocale(certificatoEmesso, certificatoGenerato.bytes)

            CerCertificatoEmesso c = cerCertificatoEmessoService.get(certificatoEmesso.id)
            cerCertificatoEmessoService.downloadAllegato(c)

            throw dre
        }
    }

    Boolean isEmissioneCertificatoBloccatoDaMessaggiAnagrafeBloccanti(CerModalitaRilascio modalitaRilascio, List<AnaMessaggio> messaggiAnagrafe) {
        if (modalitaRilascio.flagUsoInterno) {
            return Boolean.FALSE
        }
        Boolean existBloccante = messaggiAnagrafe.any { it.bloccante }
        return existBloccante
    }

    EDocumentoAnagraficoSource getDocumentoAnagraficoSource(CerTipoCertificato tipoCertificato) {
        if (tipoCertificato.shouldGenerateDocumentoAnagrafico()) {
            return EDocumentoAnagraficoSource.CREATE_NEW
        }

        if (tipoCertificato.shouldRecoverDocumentoAnagrafico()) {
            return EDocumentoAnagraficoSource.EXISTING
        }

        return null
    }

    AnaDocumento getDocumentoAnagrafico(Integer matricola, AnaTipoDocumento tipoDocumentoAnagrafe, EDocumentoAnagraficoSource source) {
        if (source == null) {
            return null
        }
        if (tipoDocumentoAnagrafe == null) {
            return null
        }
        if (matricola == null) {
            return null
        }

        AnaAnagrafe anagrafe = anaAnagrafeService.get(matricola)

        switch (source) {
            case EDocumentoAnagraficoSource.CREATE_NEW:
                return anaDocumentoService.create(anagrafe, tipoDocumentoAnagrafe)
                break
            case EDocumentoAnagraficoSource.EXISTING:
                return anaDocumentoService.getLastByAnagrafeAndTipoDocumento(anagrafe, tipoDocumentoAnagrafe)
                break
        }

        return null
    }

    String calculateNumeroDocumentoAnagrafico(CerTipoCertificato tipoCertificato) {
        anaDocumentoService.calculateNumero(tipoCertificato.tipoDocumentoAnagrafe)
    }

    void saveDocumentoAnagrafico(AnaDocumento documento) {
        anaDocumentoService.save(documento)
    }

    void saveDocumentoAnagraficoAllegato(AnaDocumento documento, CerCertificatoEmesso certificato, CertificatoGenerato certificatoGenerato) {
        String identificativoCertificato = certificato.idEmissione

        String nome = "${documento.anagrafe.cognome}${documento.anagrafe.nome ? "_${documento.anagrafe.nome}" : ""}_${documento.tipoDocumento.id}${documento.numero ? "_${documento.numero}" : ""}_CER_${identificativoCertificato}"
        nome = FileUtils.sanitizeFilename(nome)
        nome = nome + (certificatoGenerato.formato ? "." + certificatoGenerato.formato : "")

        AnaDocumentoAllegato allegato = anaDocumentoAllegatoService.create(documento, nome)
        anaDocumentoAllegatoService.save(allegato)

        try {
            EModelloGdm modello = anaTipoDocumentoService.getModelloGdm(documento.tipoDocumento)
            boolean checkCompetenza = anaTipoDocumentoService.shouldCheckCompetenza(documento.tipoDocumento)
            anaDocumentoAllegatoService.saveAllegatoDocumentale(modello, checkCompetenza, allegato, certificatoGenerato.bytes)
        } catch (DocumentaleRuntimeException dre) {
            log.error(dre.message, dre)

            anaDocumentoAllegatoService.saveAllegatoLocale(allegato, certificatoGenerato.bytes)

            throw dre
        } catch (Exception ex) {
            log.error(ex.message, ex)

            anaDocumentoAllegatoService.delete(allegato)

            throw ex
        }
    }

    static boolean shouldAlertEmissioneCertificato(CerCertificatoEmesso emesso, CerCertificatoEmesso daEmettere) {
        return (!emesso.isAnnullato()) &&
                emesso.tipoCertificato.id == daEmettere.tipoCertificato.id &&
                emesso.dataEmissione == daEmettere.dataEmissione &&
                emesso.beneficiario.cognome == daEmettere.beneficiario.cognome &&
                emesso.beneficiario.nome == daEmettere.beneficiario.nome &&
                emesso.richiedente.cognome == daEmettere.richiedente.cognome &&
                emesso.richiedente.nome == daEmettere.richiedente.nome
    }
}
