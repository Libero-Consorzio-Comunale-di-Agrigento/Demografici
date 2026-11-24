package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoPratica
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaVariazioneRepository extends JpaRepository< AnaVariazione, Integer> {

    @Query("""
        SELECT v
        FROM AnaVariazione v
        LEFT OUTER JOIN FETCH v.evento
        WHERE v.anagrafe = :anagrafe
          AND v.tipoPratica = :tipoPratica
          AND v.flagTpr = true
          AND v.descrizioneTpr IS NOT NULL
        ORDER BY v.sequenzaEventoTpr ASC, v.descrizioneTpr ASC
    """)
    List<AnaVariazione> findByAnagrafeAndTipoPraticaAndFlagTprTrueAndDescrizioneTprIsNotNullOrderBySequenzaEventoTprAscDescrizioneTprAsc(@Param("anagrafe") ETipoAnagrafe anagrafe, @Param("tipoPratica") ETipoPratica tipoPratica)

    AnaVariazione findByAnagrafeAndTipoPraticaAndCodiceVariazioneTprAndFlagTprTrue(ETipoAnagrafe tipoArchivioAnagrafe, ETipoPratica tipoPratica, String tipoEventoTpr)

    AnaVariazione findByFlagReimmigrazioneAireIsTrue()

}