package it.finmatica.de4gsdzk.anagrafe

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface AnaSoggettoDichiarazioneResidenzaRepository extends JpaRepository<AnaSoggettoDichiarazioneResidenza, String> {

    List<AnaSoggettoDichiarazioneResidenza> findByAnnoPraticaAndPraticaAndTipoEventoOrderByWord1AscWord2Asc(Integer annoPratica, Integer pratica, String tipoEvento)

}
