package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.ETipoPratica
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

/**
 * Repository per l'entity AnaTestataModelloApr4
 * Accesso ai dati della tabella ANAWP4_SAP4_ZK
 */
@Repository
interface AnaTestataModelloApr4Repository extends JpaRepository<AnaTestataModelloApr4, String> {

    AnaTestataModelloApr4 findByNumeroDicAndAnnoDicAndTipoEvento(Integer numeroDic, Integer annoDic, ETipoPratica tipoPratica)

}
