package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivMessaggio
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class CivMessaggioService {

    private final CivMessaggioRepository civMessaggioRepository

    CivMessaggioService(CivMessaggioRepository civMessaggioRepository) {
        this.civMessaggioRepository = civMessaggioRepository
    }

    List<CivMessaggio> listAllForCertificazioneByAtto(CivAttoBaseDomain atto) {
        if (atto == null) {
            throw new IllegalArgumentException("L'atto non puè essere nullo")
        }
        return civMessaggioRepository.findAllByIdTipoAttoAndIdIdAndFlagCertificazioneTrueOrderByFlagAvvisoDescIdSequenzaAsc(atto.tipoAtto, atto.id)
    }
}
