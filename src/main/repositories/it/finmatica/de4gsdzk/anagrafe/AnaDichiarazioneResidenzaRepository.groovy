package it.finmatica.de4gsdzk.anagrafe

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface AnaDichiarazioneResidenzaRepository extends JpaRepository<AnaDichiarazioneResidenza, String> {

    AnaDichiarazioneResidenza findByAnnoPraticaAndPraticaAndTipoEvento(Integer annoPratica, Integer pratica, String tipoEvento)

}
