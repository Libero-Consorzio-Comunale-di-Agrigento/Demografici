package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscCodificaErrore
import org.springframework.data.jpa.repository.JpaRepository

interface AnscEndCodificaErroreRepository extends JpaRepository<AnscCodificaErrore, String> {

    AnscCodificaErrore findById(String id)

    AnscCodificaErrore findByIdAndFlagGestitoIsNull(String id)
}