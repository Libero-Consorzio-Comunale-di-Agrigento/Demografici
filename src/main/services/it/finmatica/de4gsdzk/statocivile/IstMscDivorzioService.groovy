package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.Etichette
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class IstMscDivorzioService {

	private final GsdService gsdService

	private final CivMatrimonioService civMatrimonioService

	private final CivValidazioneModelloIstatService civValidazioneModelloIstatService

	private final IstMscDivorzioRepository istMscDivorzioRepository

    IstMscDivorzioService(IstMscDivorzioRepository istMscDivorzioRepository, GsdService gsdService,
                          CivMatrimonioService civMatrimonioService, CivValidazioneModelloIstatService civValidazioneModelloIstatService) {

		this.istMscDivorzioRepository = istMscDivorzioRepository
		this.gsdService = gsdService
		this.civMatrimonioService = civMatrimonioService
		this.civValidazioneModelloIstatService = civValidazioneModelloIstatService
	}

	IstMscDivorzio get(Long id){
		return istMscDivorzioRepository.findById(id)
	}

	IstMscDivorzio getByUkAtto(String identificativoAtto) {
		return istMscDivorzioRepository.findByUkAtto(identificativoAtto)
	}

	List<Long> listAllIdByIdAnnotazione(Long idAnnotazione) {
		return istMscDivorzioRepository.findAllIdByIdAnnotazione(idAnnotazione)
	}

	private void validaDati(IstMscDivorzio obj, Long pkAtto){
		civValidazioneModelloIstatService.checkEstremiAtto(obj)

		civValidazioneModelloIstatService.checkChiusuraProvvisorio(obj)

		CivMatrimonio mat = civMatrimonioService.get(pkAtto, [:])
		if (mat.hasModelloSDSU && (obj.is6sd() || obj.is12sd()) ){
			if (obj.tipoAccordo == null){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_modello_istat"))
			}
			if (obj.tipoAccordo.intValue() == 2){
				if (obj.causaScioglimento == null){
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_modello_istat"))
				}
			}
		}
		civValidazioneModelloIstatService.checkDatiProvvedimento(obj)
		if (obj.isProvvedimento()){
			if ( (obj.tipoProvvedimentoTribCda.intValue() == 3) ||(obj.tipoProvvedimentoTribCda.intValue() == 4) ){
				if (obj.causaScioglimento == null){
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_modello_istat"))
				}
			}
		}
        // Dati matrimonio
        if ( (obj.comuneMatUci?.codice == null) || (obj.comuneMatUci?.codiceProvincia == null) || (obj.rito == null) || (obj.dataMatUci == null) ) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_modello_istat"))
        }
	}

	IstMscDivorzio save (IstMscDivorzio obj, Long pkAtto){
		validaDati(obj, pkAtto)

		if (obj.id == null){
			obj.id = gsdService.getIdFromSequence(obj)
		}
		return  istMscDivorzioRepository.save(obj)
	}

}
