package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GestioneTestiGsdModelloService
import it.finmatica.de4gsdzk.GestioneTestiModelloRelazioneService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.ErroreDatiComunicazioneRuntimeException
import it.finmatica.de4gsdzk.errors.FileNameNonAttesoRuntimeException
import it.finmatica.de4gsdzk.errors.FileNonValidoRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.statocivile.GestioneTestiModelloRelazione
import it.finmatica.de4gsdzk.utils.*
import org.apache.commons.io.FilenameUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnaModelloService {

    private final AnaModelloRepository anaModelloRepository

    private final GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService

    private final GestioneTestiGsdModelloService gestioneTestiGsdModelloService

    private final UtenteCustomService utenteCustomService

    private final GsdService gsdService

    AnaModelloService(AnaModelloRepository anaModelloRepository,
                      GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService,
                      GestioneTestiGsdModelloService gestioneTestiGsdModelloService,
                      UtenteCustomService utenteCustomService, GsdService gsdService) {
        this.anaModelloRepository = anaModelloRepository
        this.gestioneTestiModelloRelazioneService = gestioneTestiModelloRelazioneService
        this.gestioneTestiGsdModelloService = gestioneTestiGsdModelloService
        this.utenteCustomService = utenteCustomService
        this.gsdService = gsdService
    }

    List<AnaModello> findAll() {
        return anaModelloRepository.findAll(new Sort(SortUtils.descrizioneAsc))
    }

    AnaModello get(String id) {
        return anaModelloRepository.findById(id)
    }

    Page<AnaModello> listAllByTipoModelloAndFiltroLike(ETipoModello tipoModello, String filtro, PageRequest p) {
        if ((filtro?.trim() ?: "") != "") {
            return anaModelloRepository.findAllByTipoModelloAndFiltroLike(tipoModello, SqlUtils.beginsAndEndsLike(filtro), p)
        } else {
            return anaModelloRepository.findAllByTipoModelloAndFiltroLike(tipoModello, "%", p)
        }
    }

    void validaDati(ETipoOperazione tipoOperazione, AnaModello obj, GestioneTestiModelloRelazione modelloRelazione, boolean force) {

        if (TestoUtils.isVuoto(obj?.codModello) || TestoUtils.isVuoto(obj?.descrizione)) {
            throw new ErroreDatiComunicazioneRuntimeException(Etichette.getEtichetta("Errore_modifica_comunicazione"))
        }

        if (tipoOperazione.isInsert()) {
            long n = anaModelloRepository.countById(obj.id)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }

        String nomeModelloCaricato = FilenameUtils.removeExtension(modelloRelazione.modello.nome)
        String nomeModelloStandard = FileUtils.getNomeModelloComunicazioneAnagrafeStandard(obj.tipoModello, obj.codModello)
        if ((nomeModelloCaricato != nomeModelloStandard) && (!(force))) {
            throw new FileNameNonAttesoRuntimeException("(Nome file atteso: ${nomeModelloStandard})")
        }
        ValidationUtils.validaDatiObbligatori(obj)
    }

    AnaModello findById(String id) {
        return anaModelloRepository.findById(id)
    }

    List<AnaModello> findAllByTipoModello(ETipoModello tipoModello) {
        return anaModelloRepository.findAllByTipoModello(tipoModello)
    }

    /**
     * Salva un record
     * @param obj il record
     * @param modelloRelazione la relazione (eventuale) col modello
     * @return il record (aggiornato)
     */
    AnaModello save(ETipoOperazione tipoOperazione, AnaModello obj, GestioneTestiModelloRelazione modelloRelazione, boolean force = false) {
        validaDati(tipoOperazione, obj, modelloRelazione, force)

        if(tipoOperazione == ETipoOperazione.INS) {
            obj.id = gsdService.getIdModelloAnagrafe(obj)
        }

        obj.terminalista = utenteCustomService.getLoggedUser()
        AnaModello m = anaModelloRepository.save(obj)

        // modello
        if (modelloRelazione.modello.fileTemplate != null) {
            modelloRelazione.modello.codice = FileUtils.getCodiceModelloComunicazioneAnagrafeStandard(obj.tipoModello, obj.codModello)
            modelloRelazione.modello = gestioneTestiGsdModelloService.save(modelloRelazione.modello)
            modelloRelazione.modelloAnagrafe = m
            // relazione
            gestioneTestiModelloRelazioneService.save(modelloRelazione)
        }

        return m
    }

    /**
     * Cancella un record (incluso il modello collegato)
     * @see GestioneTestiModelloRelazione* @param obj il record
     */
    void delete(AnaModello obj) {
        GestioneTestiModelloRelazione r = gestioneTestiModelloRelazioneService.getByIdModelloAnagrafe(obj.id)
        if (r) {
            gestioneTestiModelloRelazioneService.delete(r)//cascade su modelloAnagrafe
            gestioneTestiGsdModelloService.delete(r.modello)//non c'è cascade sul modello
        }
        log.info("Tento cancellazione su ANAMOD per id " + obj.id)
        anaModelloRepository.delete(obj)
    }

}
