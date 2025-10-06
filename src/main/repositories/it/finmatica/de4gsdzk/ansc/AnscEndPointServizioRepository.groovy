package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscEndPointServizio
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository

interface AnscEndPointServizioRepository extends JpaRepository<AnscEndPointServizio, String> {

    AnscEndPointServizio findById(String id)

    Page<AnscEndPointServizio> findAllByServizioLikeIgnoreCaseOrDescrizioneLikeIgnoreCase(String filtroSer, String filtroDes, Pageable pageable)

    List<AnscEndPointServizio> findAllByFlagNotificaRicercaIsTrue()

    List<AnscEndPointServizio> findAllByFlagNotificaConfermaIsTrue()
    
    List<AnscEndPointServizio> findAllByFlagConsultazioneEventoIsTrue()

    List<AnscEndPointServizio> findAllByFlagCertificatoSempliceIsTrue()

    List<AnscEndPointServizio> findAllByFlagCertificazioneIsTrueAndFlagDefaultIsTrue()

    List<AnscEndPointServizio> findAllByFlagConsultazioneSoggettoIsTrueAndFlagDefaultIsTrue()

    List<AnscEndPointServizio> findAllByFlagConsultazioneEventoIsTrueAndFlagDefaultIsTrue()
}