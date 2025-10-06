package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.IstMsuScioglimentoRepository
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class IstMsuScioglimentoService {

	private final StatoCivileService statoCivileService

	private final CivUnioneCivileService civUnioneCivileService

	private final CivValidazioneModelloIstatService civValidazioneModelloIstatService

	private final IstMsuScioglimentoRepository istMsuScioglimentoRepository

    IstMsuScioglimentoService(IstMsuScioglimentoRepository istMsuScioglimentoRepository, StatoCivileService statoCivileService,
							  CivUnioneCivileService civUnioneCivileService, CivValidazioneModelloIstatService civValidazioneModelloIstatService) {

		this.istMsuScioglimentoRepository = istMsuScioglimentoRepository
		this.statoCivileService = statoCivileService
		this.civUnioneCivileService = civUnioneCivileService
		this.civValidazioneModelloIstatService = civValidazioneModelloIstatService
	}

	IstMsuScioglimento get(Long id){
		return istMsuScioglimentoRepository.findById(id)
	}

	IstMsuScioglimento getByUkAtto(String identificativoAtto) {
		return istMsuScioglimentoRepository.findByUkAtto(identificativoAtto)
	}

	List<Long> listAllIdByIdAnnotazione(Long idAnnotazione) {
		return istMsuScioglimentoRepository.findAllIdByIdAnnotazione(idAnnotazione)
	}

	private void validaDati(IstMsuScioglimento obj, Long pkAtto){
		civValidazioneModelloIstatService.checkEstremiAtto(obj)

		civValidazioneModelloIstatService.checkChiusuraProvvisorio(obj)

		CivUnioneCivile uci = civUnioneCivileService.get(pkAtto, [:])
		if (uci.hasModelloSDSU && (obj.is6su() || obj.is12su()) ){
			if (obj.tipoAccordo == null){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_modello_istat)
			}
		}
		civValidazioneModelloIstatService.checkDatiProvvedimento(obj)
		// Dati matrimonio
        if ( (obj.comuneMatUci?.codice == null) || (obj.comuneMatUci?.codiceProvincia == null) || (obj.dataMatUci == null) ) {
            throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_modello_istat)
        }
	}

	IstMsuScioglimento save (IstMsuScioglimento obj, Long pkAtto){
		validaDati(obj, pkAtto)

		if (obj.id == null){
			obj.id = statoCivileService.getIdFromSequence(obj)
		}
		return  istMsuScioglimentoRepository.save(obj)
	}

}
