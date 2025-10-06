package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.anagrafe.AnaNazionalitaRepository
import it.finmatica.de4gsdzk.utils.SortUtils
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaNazionalitaService {

	private final AnaNazionalitaRepository anaNazionalitaRepository

	AnaNazionalitaService(AnaNazionalitaRepository anaNazionalitaRepository) {
		this.anaNazionalitaRepository = anaNazionalitaRepository
	}

	AnaNazionalita get (String id){
		return anaNazionalitaRepository.findById(id)
	}

	List<AnaNazionalita> listAll () {
		return anaNazionalitaRepository.findAll(new Sort(SortUtils.descrizioneAsc))
	}

}
