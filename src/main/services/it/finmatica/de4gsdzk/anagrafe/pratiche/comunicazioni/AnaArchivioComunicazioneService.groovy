package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaPratica
import it.finmatica.de4gsdzk.competenze.CompetenzeRuntimeException
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.MetadatiGdmUtils
import it.finmatica.smartdoc.api.DocumentaleRuntimeException
import it.finmatica.smartdoc.api.struct.Campo
import it.finmatica.smartdoc.api.struct.Documento
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnaArchivioComunicazioneService implements IArchivioComunicazioneService, TraitArchivioComunicazioneService {

    private final GsdService gsdService

    private final CompetenzaService competenzaService

    private final IntegrazioneDocumentaleService integrazioneDocumentaleService

    private final AnaArchivioComunicazioneRepository anaArchivioComunicazioneRepository

    AnaArchivioComunicazioneService(AnaArchivioComunicazioneRepository anaArchivioComunicazioneRepository,
                                    GsdService gsdService, CompetenzaService competenzaService,
                                    IntegrazioneDocumentaleService integrazioneDocumentaleService) {

        this.anaArchivioComunicazioneRepository = anaArchivioComunicazioneRepository
        this.gsdService = gsdService
        this.competenzaService = competenzaService
        this.integrazioneDocumentaleService = integrazioneDocumentaleService
    }

    @Override
    IArchivioComunicazioneRepository getArchivioComunicazioneRepository() {
        return anaArchivioComunicazioneRepository
    }

    @Override
    GsdService getGsdService() {
        return gsdService
    }

    AnaArchivioComunicazione create() {
        return new AnaArchivioComunicazione(stampaEseguita: Boolean.FALSE)
    }

    List<AnaArchivioComunicazione> listAllByUkPratica(ETipoAnagrafe archivioAnagrafe, ETipoPratica tipoPratica, Integer numeroPratica, Integer annoPratica, Map params) {
        return anaArchivioComunicazioneRepository.listAllByUkPratica(archivioAnagrafe, tipoPratica, numeroPratica, annoPratica, params)
    }

    /*Page<AnaArchivioComunicazione> list (Map params) {
		return anaArchivioComunicazioneRepository.listByParams(params)
	}
	
	Page<AnaArchivioComunicazione> listAllByTipoAttoAndEnteDestinatarioAndStampaEseguita (ETipoAtto tipoAttoEnum, Integer idEnte, Boolean stampaEseguita, PageRequest p) {
		return anaArchivioComunicazioneRepository.findAllByTipoAttoAndEnteDestinatarioAndStampaEseguita(new Integer(tipoAttoEnum.valore), idEnte, stampaEseguita, p)
	}

	Page<AnaArchivioComunicazione> listAllByTipoAttoAndComuneDestinatarioAndStampaEseguita (ETipoAtto tipoAttoEnum, Integer codiceComune, Integer codiceProvincia, Boolean stampaEseguita, PageRequest p) {
		return anaArchivioComunicazioneRepository.findAllByTipoAttoAndComuneAndStampaEseguita(new Integer(tipoAttoEnum.valore), codiceComune, codiceProvincia, stampaEseguita, p)
	}*/


    @Override
    void validaDati(IArchivioComunicazione _obj, Boolean ignoreStampaEseguita, Boolean ignoreStato) {
        AnaArchivioComunicazione obj = _obj as AnaArchivioComunicazione
        if ((obj.archivioAnagrafe == null) || (obj.tipoPratica == null) ||
                (obj.numeroPratica == null) || (obj.annoPratica == null) ||
                (obj.comunicazione?.id == null)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_comunicazione"))
        }

        if (!(competenzaService.isAnaSuperUser())) {
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

    AnaArchivioComunicazione save(AnaArchivioComunicazione obj, AnaPratica pratica, Boolean ignoreStampaEseguita = Boolean.FALSE, Boolean ignoreStato = Boolean.FALSE, Boolean salvaSuDocumentale = Boolean.FALSE) {
        validaDati(obj, ignoreStampaEseguita, ignoreStato)

        if (salvaSuDocumentale) {
            if (obj.idDocumentoEsterno == null) {
                // Devo salvare su gdm
                EModelloGdm modello = EModelloGdm.Pratica
                List<Campo> metadati = MetadatiGdmUtils.listMetadatiPratica(pratica)
                Documento smartDoc = integrazioneDocumentaleService.salva(obj, metadati, modello)
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
        log.info("Lancio salvataggio su ANACOM per id " + obj.id)
        AnaArchivioComunicazione savedCom = anaArchivioComunicazioneRepository.save(obj)
        return savedCom
    }

    void deleteComunicazione(IArchivioComunicazione _obj) {
        AnaArchivioComunicazione obj = _obj as AnaArchivioComunicazione
        validaDati(obj, Boolean.FALSE, Boolean.FALSE)
        // Cancello dal documentale
        if (obj.idDocumentoEsterno != null) {
            integrazioneDocumentaleService.eliminaDocumento(obj, true)
        }

        //Cancello da anacom
        log.info("Tento cancellazione su ANACOM per id " + obj.id)
        anaArchivioComunicazioneRepository.delete(obj)
    }

    String protocollaComunicazione(Long id){
        return gsdService.protocollaComunicazioneAna(id)
    }

    String inviaAlboComunicazione(IArchivioComunicazione obj) {
        return gsdService.inviaAlboComunicazioneAna(obj as AnaArchivioComunicazione)
    }
}
