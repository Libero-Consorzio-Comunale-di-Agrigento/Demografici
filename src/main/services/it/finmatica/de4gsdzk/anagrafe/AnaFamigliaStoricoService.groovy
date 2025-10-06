package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.ETipoSiNo
import it.finmatica.de4gsdzk.utils.DataUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaFamigliaStoricoService {

    private final AnaFamigliaStoricoRepository anaFamigliaStoricoRepository

    AnaFamigliaStoricoService(AnaFamigliaStoricoRepository anaFamigliaStoricoRepository) {

        this.anaFamigliaStoricoRepository = anaFamigliaStoricoRepository
    }

    Page<AnaFamigliaStorico> listAllByRicercaFamiglia(RicercaFamiglia r, Pageable pageable) {
        r.validaDati()

        return anaFamigliaStoricoRepository.findAllByRicercaFamiglia(
                r.via,
                r.numeroCivico,
                r.suffisso,
                r.interno,
                r.subInterno,
                r.scala,
                r.piano,
                r.tipoFamiglia == null ? null : r.tipoFamiglia == ETipoFamiglia.CONVIVENZA ? Boolean.TRUE : Boolean.FALSE,
                r.iscrittoInAPR == null ? null : r.iscrittoInAPR == ETipoSiNo.SI ? EFascia.ISCRITTO_APR : EFascia.CANCELLATO_APR,
                r.data == null ? DataUtils.getDataCorrente() : r.data,
                pageable)
    }
}
