package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.ETipoSiNo
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaIndirizzoStradarioService {

    private final AnaIndirizzoStradarioRepository anaIndirizzoStradarioRepository

    AnaIndirizzoStradarioService(AnaIndirizzoStradarioRepository anaIndirizzoStradarioRepository) {

        this.anaIndirizzoStradarioRepository = anaIndirizzoStradarioRepository
    }

    Page<AnaIndirizzoStradario> listAllByRicercaFamiglia(RicercaFamiglia r, Pageable pageable) {
        r.validaDati()
        EFascia fascia
        if(r.iscrittoInAPR) {
            fascia = r.iscrittoInAPR == null ? null : r.iscrittoInAPR == ETipoSiNo.SI ? EFascia.ISCRITTO_APR : EFascia.CANCELLATO_APR
        } else {
            fascia = r.fascia
        }


        return anaIndirizzoStradarioRepository.findAllByRicercaFamiglia(
                r.via,
                r.numeroCivico,
                r.suffisso,
                r.interno,
                r.subInterno,
                r.scala,
                r.piano,
                r.tipoFamiglia,
                //fascia,
                pageable)
    }
}
