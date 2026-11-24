package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.EStatoInvioAlbo
import it.finmatica.de4gsdzk.utils.EStatoProtocollazione
import org.springframework.data.domain.Page

interface IArchivioComunicazioneRepository {

    IArchivioComunicazione findById(Long id)

    EStatoProtocollazione findStatoProtocollazione(Long id)

    EStatoInvioAlbo findStatoInvioAlbo(Long id)

    Boolean findStampaEseguita(Long id)

    Integer checkAllegatoPrincipale(Long idArcCom)

}
