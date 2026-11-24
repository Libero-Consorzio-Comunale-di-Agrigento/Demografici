package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.GsdFirmaService
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnte
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnteService
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.DataUtils
import it.finmatica.de4gsdzk.utils.ENaturaDocumento
import it.finmatica.de4gsdzk.utils.Funzioni
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaDocumentoService {
    private final AnaDocumentoRepository anaDocumentoRepository
    private final AnaDocumentoAllegatoService anaDocumentoAllegatoService
    private final AnaEnteService anaEnteService
    private final ArcComuneBaseService arcComuneBaseService
    private final GsdFirmaService gsdFirmaService
    private final IntegrazioneDocumentaleService integrazioneDocumentaleService
    private final GsdService gsdService

    AnaDocumentoService(AnaDocumentoRepository anaDocumentoRepository,
                        AnaDocumentoAllegatoService anaDocumentoAllegatoService,
                        AnaEnteService anaEnteService,
                        ArcComuneBaseService arcComuneBaseService,
                        GsdFirmaService gsdFirmaService,
                        IntegrazioneDocumentaleService integrazioneDocumentaleService,
                        GsdService gsdService) {
        this.anaDocumentoRepository = anaDocumentoRepository
        this.anaDocumentoAllegatoService = anaDocumentoAllegatoService
        this.anaEnteService = anaEnteService
        this.arcComuneBaseService = arcComuneBaseService
        this.gsdFirmaService = gsdFirmaService
        this.integrazioneDocumentaleService = integrazioneDocumentaleService
        this.gsdService = gsdService
    }

    AnaDocumento create(AnaAnagrafe anagrafe, AnaTipoDocumento tipoDocumento) {
        if (anagrafe == null || tipoDocumento == null) {
            throw new IllegalArgumentException()
        }
        AnaDocumento documento = new AnaDocumento()
        documento.tipoDocumento = tipoDocumento
        documento.natura = ENaturaDocumento.O
        documento.dataEmissione = DataUtils.getDataCorrente()
        documento.ente = anaEnteService.get(AnaEnte.COMUNE)
        documento.anagrafe = anagrafe
        ArcComuneBaseDomain comuneCliente = arcComuneBaseService.comuneCliente
        documento.comuneEnte = new Comune()
        documento.comuneEnte.codice = comuneCliente.codiceComune
        documento.comuneEnte.descrizione = comuneCliente.descrizioneComune
        documento.comuneEnte.codiceProvincia = comuneCliente.codiceProvincia
        documento.comuneEnte.siglaProvincia = comuneCliente.siglaProvincia

        return documento
    }

    AnaDocumento get(Long id) {
        return anaDocumentoRepository.findById(id)
    }

    AnaDocumento getLastByAnagrafeAndTipoDocumento(AnaAnagrafe anagrafe, AnaTipoDocumento tipoDocumento) {
        List<AnaDocumento> list = anaDocumentoRepository.findAllByAnagrafeAndTipoDocumentoOrderByProgressivoDesc(anagrafe, tipoDocumento)
        if (list.size() > 0) {
            // Ritorno quello con progressivo 1 (cioè l'ultimo)
            return list.last()
        }
        return null
    }

    String calculateNumero(AnaTipoDocumento tipoDocumento) {
        return gsdService.getNumeroDocumentoAnagrafico(tipoDocumento)
    }

    Page<AnaDocumento> listRecentiByAnagrafe(AnaAnagrafe anagrafe, Pageable pageable) {
        RicercaDocumento r = new RicercaDocumento()
        r.anagrafe = anagrafe
        r.storico = false
        return anaDocumentoRepository.findAllByAnagrafe(r, pageable)
    }

    boolean existsRecentiByAnagrafe(AnaAnagrafe anagrafe) {
        RicercaDocumento r = new RicercaDocumento()
        r.anagrafe = anagrafe
        r.storico = false
        return anaDocumentoRepository.countByAnagrafe(r) > 0
    }

    Page<AnaDocumento> listStoriciByAnagrafe(AnaAnagrafe anagrafe, Pageable pageable) {
        RicercaDocumento r = new RicercaDocumento()
        r.anagrafe = anagrafe
        r.storico = true
        return anaDocumentoRepository.findAllByAnagrafe(r, pageable)
    }

    boolean existsStoriciByAnagrafe(AnaAnagrafe anagrafe) {
        RicercaDocumento r = new RicercaDocumento()
        r.anagrafe = anagrafe
        r.storico = true
        return anaDocumentoRepository.countByAnagrafe(r) > 0
    }

    Page<AnaDocumento> listConvivenzaDiFattoByAnagrafe(AnaAnagrafe anagrafe, Pageable pageable) {
        RicercaDocumento r = new RicercaDocumento()
        r.anagrafe = anagrafe
        r.convivenzaDiFatto = true
        return anaDocumentoRepository.findAllByAnagrafe(r, pageable)
    }

    boolean existsConvivenzaDiFattoByAnagrafe(AnaAnagrafe anagrafe) {
        RicercaDocumento r = new RicercaDocumento()
        r.anagrafe = anagrafe
        r.convivenzaDiFatto = true
        return anaDocumentoRepository.countByAnagrafe(r) > 0
    }

    Funzioni<EFunzioneDocumento> getFunzioniDocumento(AnaDocumento documento) {
        Funzioni<EFunzioneDocumento> funzioni = new Funzioni<EFunzioneDocumento>()
        funzioni.set(EFunzioneDocumento.ADD_ALLEGATO, true, true)
        if (documento.canDownload()) {
            funzioni.set(EFunzioneDocumento.DOWNLOAD, true, true)
        }
        return funzioni
    }

    void validaDati(AnaDocumento obj) {
        if (obj.tipoDocumento.id in [AnaTipoDocumento.CE, AnaTipoDocumento.U1, AnaTipoDocumento.U2] &&
                TestoUtils.isVuoto(obj.numero)) {
            throw new CampoMandatoryRuntimeException()
        }
    }

    AnaDocumento save(AnaDocumento obj) {
        validaDati(obj)

        if (obj.id == null) {
            // solo in caso di inserimento
            obj.id = gsdService.getIdFromSequence(obj)
        }

        if (obj.progressivo == null) {
            obj.progressivo = 1

            // Storicizzo esistenti
            anaDocumentoRepository.incrementProgressivoByAnagrafeAndTipoDocumento(obj.anagrafe, obj.tipoDocumento)
        }

        return anaDocumentoRepository.save(obj)
    }

    void downloadAllegati(AnaDocumento obj) {
        String name = "${obj.anagrafe.cognome}${obj.anagrafe.nome ? "_${obj.anagrafe.nome}" : ""}_${obj.tipoDocumento.id}${obj.numero ? "_${obj.numero}" : ""}"
        List<AnaDocumentoAllegato> allegati = obj.allegati.findAll { it.canDownload() }
        gsdFirmaService.scaricaAllegati(name, obj, allegati)
    }

    List<AnaDocumento> listDocumentiSoggettoByAnagrafe(AnaAnagrafe anagrafe) {
        RicercaDocumento r = new RicercaDocumento()
        r.anagrafe = anagrafe
        r.storico = false
        return anaDocumentoRepository.listAllByAnagrafe(r)
    }

    List<AnaDocumento> listDocumentiCDFByAnagrafe(AnaAnagrafe anagrafe) {
        RicercaDocumento r = new RicercaDocumento()
        r.anagrafe = anagrafe
        r.convivenzaDiFatto = true
        return anaDocumentoRepository.listAllByAnagrafe(r)
    }

    void delete(AnaDocumento documento){
        /*for(AnaDocumentoAllegato a : documento.allegati){
            anaDocumentoAllegatoService.delete(a)
        }*/
        //Al momento non esiste una cancellazione fisica del documento perciò elimino solo il collegamento al documentale
        //integrazioneDocumentaleService.eliminaDocumento(documento, true)
        anaDocumentoRepository.delete(documento.id)
    }


}
