package it.finmatica.de4gsdzk.archivi

import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.GsdMenuDitta
import it.finmatica.de4gsdzk.GsdMenuDittaService
import it.finmatica.de4gsdzk.archivi.ArcComuneRepository
import it.finmatica.de4gsdzk.archivi.ArcComuneStoricoRepository
import it.finmatica.de4gsdzk.utils.RicercaComune
import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class ArcComuneBaseService {

	private final GsdMenuDittaService gsdMenuDittaService

	private final ArcComuneRepository arcComuneRepository

	private final ArcComuneStoricoRepository arcComuneStoricoRepository

	ArcComuneBaseService(ArcComuneRepository arcComuneRepository,
						 ArcComuneStoricoRepository arcComuneStoricoRepository, GsdMenuDittaService gsdMenuDittaService) {

		this.arcComuneRepository = arcComuneRepository
		this.arcComuneStoricoRepository = arcComuneStoricoRepository
		this.gsdMenuDittaService = gsdMenuDittaService
	}

	ArcComune getByCodiceComuneAndCodiceProvincia(Integer codiceComune, Integer codiceProvincia){
		ArcComune c = arcComuneRepository.findByCodiceComuneAndCodiceProvincia(codiceComune, codiceProvincia)
		return c
	}

	//Ricerca su ARCCOM (non sullo storico)
	Boolean existsByCodiceComuneAndCodiceProvincia(Integer codiceComune, Integer codiceProvincia){
		return (arcComuneRepository.countByCodiceComuneAndCodiceProvincia(codiceComune, codiceProvincia) >= 1)
	}

	List<ArcComune> listByComuneFusione(Integer codiceComune, Integer codiceProvincia){
		List<ArcComune> l = arcComuneRepository.findAllByCodiceComuneFusioneAndCodiceProvinciaFusione(codiceComune, codiceProvincia)
		return l
	}

	ArcComune getComuneCliente(){
		ArcComune c = null
		GsdMenuDitta m = gsdMenuDittaService.getUniqueRecord()
		if (m) {
			c = getByCodiceComuneAndCodiceProvincia(m.comuneCliente, m.provinciaCliente)
		}
		return c
	}

	Boolean isComuneClienteOggi(Integer codiceComune, Integer codiceProvincia, ArcComune comuneCliente=null){
		if ( (codiceComune != null) && (codiceProvincia != null) ){
			ArcComuneBaseDomain c = (comuneCliente?:getComuneCliente())
			if (c){
				return ( (c.codiceComune.compareTo(codiceComune) == 0) && (c.codiceProvincia.compareTo(codiceProvincia) == 0) )
			} else {
				return false
			}
		}
		return false
	}

	Boolean isComuneClienteAnnotazione(Integer codiceComune, Integer codiceProvincia){
		if (codiceComune && codiceProvincia){
			GsdMenuDitta m = gsdMenuDittaService.getUniqueRecord()
			if (m) {
				ArcComune c = getByCodiceComuneAndCodiceProvincia(m.comuneCliente, m.provinciaCliente)
				if (c){
					if ( (c.codiceComune.compareTo(codiceComune) == 0) && (c.codiceProvincia.compareTo(codiceProvincia) == 0) ){
						return true
					}
				}
				List<ArcComune> l = listByComuneFusione(m.comuneCliente, m.provinciaCliente)
				for (ArcComune lc:l){
					if ( (lc.codiceComune.compareTo(codiceComune) == 0) && (lc.codiceProvincia.compareTo(codiceProvincia) == 0)){
						return true
					}
				}
			}
		}
		return false
	}

	Page<ArcComuneBaseDomain> list (RicercaComune r, PageRequest p){
		String filtro = null
		if (r?.descrizioneComune) {
			filtro = ((r?.searchEqual) ? r.descrizioneComune : SqlUtils.endsLike(r.descrizioneComune))
		}
		List<String> ids = null
		if (r?.idNotIn?.size() > 0) {
			ids = r?.idNotIn
		}
		Date d = null
		if (r?.dataRiferimento){
			d = r.dataRiferimento
		}
        Boolean escludiSoppressi = false
        if (r?.escludiSoppressi){
            escludiSoppressi = r.escludiSoppressi
        }
		if (d != null){
			// ARCCOM_STORICO
			if (ids) {
				if (filtro) {
					return arcComuneStoricoRepository.findAllByIdNotInAndDescrizioneComuneLikeIgnoreCaseAndDataRif(ids, filtro, d, p)
				} else {
					return arcComuneStoricoRepository.findAllByIdNotInAndDataRif(ids, d, p)
				}
			} else {
				if (filtro) {
					return arcComuneStoricoRepository.findAllByDescrizioneComuneLikeIgnoreCaseAndDataRif(filtro, d, p)
				} else {
					return arcComuneStoricoRepository.findAllByDataRif(d, p)
				}
			}
		} else {
			//ARCCOM
			if (ids) {
				if (filtro) {
                    if(escludiSoppressi) {
                        return arcComuneRepository.findAllByIdNotInAndDescrizioneComuneLikeIgnoreCaseAndSoppressoIsNull(ids, filtro, p)
                    } else {
                        return arcComuneRepository.findAllByIdNotInAndDescrizioneComuneLikeIgnoreCase(ids, filtro, p)
                    }
				} else {
                    if(escludiSoppressi) {
                        return arcComuneRepository.findAllByIdNotInAndSoppressoIsNull(ids, p)
                    } else {
                        return arcComuneRepository.findAllByIdNotIn(ids, p)
                    }
				}
			} else {
				if (filtro) {
                    if(escludiSoppressi) {
                        return arcComuneRepository.findAllByDescrizioneComuneLikeIgnoreCaseAndSoppressoIsNull(filtro, p)
                    } else {
                        return arcComuneRepository.findAllByDescrizioneComuneLikeIgnoreCase(filtro, p)
                    }
				} else {
                    if(escludiSoppressi) {
                        return arcComuneRepository.findAllBySoppressoIsNull(p)
                    } else {
                        return arcComuneRepository.findAll(p)
                    }

				}
			}
		}
	}

	List<ArcComune> getStatiEsteri(){
		return arcComuneRepository.findAllByCodiceComuneAndCodiceProvinciaGreaterThanOrderByDescrizioneComune(0, 199)
	}

}
