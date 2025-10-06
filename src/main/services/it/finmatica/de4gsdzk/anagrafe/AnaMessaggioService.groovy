package it.finmatica.de4gsdzk.anagrafe


import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaMessaggioService {

    private final AnaMessaggioRepository anaMessaggioRepository
    private final AnaAnagrafeService anaAnagrafeService

    AnaMessaggioService(AnaMessaggioRepository anaMessaggioRepository, AnaAnagrafeService anaAnagrafeService) {
        this.anaMessaggioRepository = anaMessaggioRepository
        this.anaAnagrafeService = anaAnagrafeService
    }

    List<AnaMessaggio> listAllForCertificazioneByMatricola(Integer matricola) {
        if (matricola == null) {
            throw new IllegalArgumentException("La matricola non puè essere nulla")
        }
        AnaAnagrafe anagrafe = anaAnagrafeService.get(matricola)
        return anaMessaggioRepository.findAllByIdAnagrafeAndFlagCertificazioneTrueOrderByFlagAvvisoDescIdSequenzaAsc(anagrafe)
    }

    List<AnaMessaggio> listAllForAnagrafeByAnagrafe(AnaAnagrafe anagrafe) {
        return anaMessaggioRepository.findAllByIdAnagrafeAndFlagAnagrafeTrueOrderByFlagAvvisoDescIdSequenzaAsc(anagrafe)
    }
}
