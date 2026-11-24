package it.finmatica.de4gsdzk.anagrafe


import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaStatoService {

    private final AnaStatoRepository anaStatoRepository
    private static final Integer IN_ATTESA_DI_ISCRIZIONE_ID = 70
    private static final Integer IMMIGRAZIONE_ANNULLATA_ID = 71
    private static final Integer RESIDENTE_ESTERO_ID = 10
    private static final Integer REIMMIGRAZIONE_ID = 3

    AnaStatoService(AnaStatoRepository anaStatoRepository) {
        this.anaStatoRepository = anaStatoRepository
    }

    AnaStato findById(Integer id){
        return anaStatoRepository.findById(id)
    }

    AnaStato getStatoInAttesa(){
        return anaStatoRepository.findById(IN_ATTESA_DI_ISCRIZIONE_ID)
    }

    AnaStato getStatoImmigrazioneAnnullata(){
        return anaStatoRepository.findById(IMMIGRAZIONE_ANNULLATA_ID)
    }

    AnaStato getStatoResidenteEstero(){
        return anaStatoRepository.findById(RESIDENTE_ESTERO_ID)
    }

    AnaStato getStatoReimmigrazione(){
        return anaStatoRepository.findById(REIMMIGRAZIONE_ID)
    }
}
