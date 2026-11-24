package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.utils.EAmbito
import it.finmatica.de4gsdzk.utils.EGruppo
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.ValidationUtils
import it.finmatica.de4gsdzk.utils.ZipUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class GestioneTestiGsdModelloService {

    private final GestioneTestiGsdModelloRepository gestioneTestiGsdModelloRepository

    private final UtenteCustomService utenteCustomService

    private final AmbienteService ambienteService

    GestioneTestiGsdModelloService(GestioneTestiGsdModelloRepository gestioneTestiGsdModelloRepository,
                                   UtenteCustomService utenteCustomService, AmbienteService ambienteService) {
        this.gestioneTestiGsdModelloRepository = gestioneTestiGsdModelloRepository
        this.utenteCustomService = utenteCustomService
        this.ambienteService = ambienteService
    }

    GestioneTestiGsdModello get(Long id) {
        return gestioneTestiGsdModelloRepository.findById(id)
    }

    GestioneTestiGsdModello getByAmbitoEtichetta() {
        return gestioneTestiGsdModelloRepository.findByAmbitoEtichetta()
    }

    Page<GestioneTestiGsdProjection> listByGruppoAndAmbito(EGruppo gruppo, EAmbito ambito, PageRequest pr) {
        return gestioneTestiGsdModelloRepository.findByGruppoAndAmbito(gruppo, ambito, pr)
    }

    private void validaDati(GestioneTestiGsdModello obj) {
        ValidationUtils.validaDatiObbligatori(obj, [validoDal: false, utenteIns: false, utenteUpd:false])
    }

    GestioneTestiGsdModello customSave (GestioneTestiGsdModello obj){
        if (!(obj.descrizione?.trim())){
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori"))
        }
        return save(obj)
    }

    GestioneTestiGsdModello save (GestioneTestiGsdModello obj){
        validaDati(obj)

        if (obj.utenteIns == null){
            obj.utenteIns = utenteCustomService.getLoggedUserId()
        }
        obj.utenteUpd = utenteCustomService.getLoggedUserId()

        log.info("Lancio salvataggio su GTE_GSDDMO per id " + (obj.id?:"") )
        return  gestioneTestiGsdModelloRepository.save(obj)
    }

    void delete(GestioneTestiGsdModello obj) {
        if (obj.id != null) {
            gestioneTestiGsdModelloRepository.delete(obj)
        }
    }


    byte[] generateZipFromServer(String location) {
        File[] files = ambienteService.getFilesFromServer(location)

        List<ZipUtils.VirtualFile> virtualFiles = files
            .findAll { it.isFile() }
            .collect { new ZipUtils.VirtualFile(it.getName(), new FileInputStream(it)) }

        return ZipUtils.zipFiles(virtualFiles)
    }
}
