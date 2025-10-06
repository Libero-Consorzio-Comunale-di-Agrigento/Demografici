package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscCampo
import it.finmatica.de4gsdzk.ansc.AnscSezione
import org.springframework.data.jpa.repository.JpaRepository

interface AnscCampoRepository extends JpaRepository<AnscCampo, Long> {

    List<AnscCampo> findAllBySezioneOrderBySequenzaAsc(AnscSezione sezione)

}