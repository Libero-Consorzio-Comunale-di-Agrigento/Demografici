package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.SortUtils
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaEventoAnagrafeFamigliaService {

    private final AnaEventoAnagrafeFamigliaRepository anaEventoAnagrafeFamigliaRepository

    AnaEventoAnagrafeFamigliaService(AnaEventoAnagrafeFamigliaRepository anaEventoAnagrafeFamigliaRepository) {
        this.anaEventoAnagrafeFamigliaRepository = anaEventoAnagrafeFamigliaRepository
    }

    List<AnaEventoAnagrafeFamiglia> findAllByFamigliaAndDataEvento(AnaFamiglia famiglia, Date dataEvento) {
        Sort sort = new Sort(SortUtils.anagrafeSoggettoFamiliareStoricoAsc)
        return anaEventoAnagrafeFamigliaRepository.findAllByFamigliaAndDataEvento(famiglia, dataEvento, sort)
    }

}
