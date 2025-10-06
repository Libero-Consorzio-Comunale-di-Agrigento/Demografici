package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.GsdEtichettaRepository
import it.finmatica.de4gsdzk.utils.SqlUtils
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class GsdEtichettaService {

	public static final String ITA = "I"
	public static final String DEU = "D"
	public static final String LAD = "L"

	private final UtenteCustomService utenteCustomService

	private final ArcParametroService arcParametroService

	private final GsdEtichettaRepository gsdEtichettaRepository

    GsdEtichettaService(GsdEtichettaRepository gsdEtichettaRepository,
						UtenteCustomService utenteCustomService, ArcParametroService arcParametroService){

		this.gsdEtichettaRepository = gsdEtichettaRepository
		this.utenteCustomService = utenteCustomService
		this.arcParametroService = arcParametroService
	}

	GsdEtichetta get (String id){
		return gsdEtichettaRepository.findById(id)
	}

	Page<GsdEtichetta> listAllByIdLike (String filtro, PageRequest p){
		if (TestoUtils.isVuoto(filtro?.trim())) {
			return gsdEtichettaRepository.findAll(p)
		} else {
			return gsdEtichettaRepository.findAllByIdLikeIgnoreCase(SqlUtils.beginsAndEndsLike(filtro), p)
		}
	}

	Map<String, String> listAndInsertWhereIdIn(List<Map> eMapList, Boolean save = Boolean.TRUE) {
		Boolean multiLinguismoOn = Boolean.FALSE //arcParametroService.isGestioneMultilingueAttiva()

		Map etichetteMap = [:]

		if (multiLinguismoOn){
			String lingua = utenteCustomService.getLinguaByUtente(utenteCustomService.loggedUserId)
			List<String> listaCodici = []
			for (Map m : eMapList){
				listaCodici.add((String) m["codice"])
			}
			List<GsdEtichetta> dbValues = gsdEtichettaRepository.findAllByIdIn(listaCodici.unique())
			for (Map m : eMapList.unique()){
				GsdEtichetta e
				for (GsdEtichetta dbValue: dbValues){
					if (dbValue.id == m["codice"]){
						e = dbValue
						break
					}
				}
				if (e == null){
					e = new GsdEtichetta(id: m["codice"], valoreIta: m["defaultValue"])
					if (save){
						gsdEtichettaRepository.save(e)
					}
				}
				switch (lingua) {
					case DEU:
						etichetteMap[m["codice"]] = (e.valoreDeu?:m["defaultValue"])
						break
					case LAD:
						etichetteMap[m["codice"]] = (e.valoreLad?:m["defaultValue"])
						break
					default:
						etichetteMap[m["codice"]] = (e.valoreIta?:m["defaultValue"])
						break
				}
			}
		} else {
			for (Map m : eMapList){
				etichetteMap[m["codice"]] = (m["defaultValue"])
			}
		}

		return etichetteMap
	}

	GsdEtichetta save(GsdEtichetta obj) {
		return gsdEtichettaRepository.save(obj)
	}

}
