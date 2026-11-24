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
interface AnaEventoPraticaRepository extends JpaRepository<AnaEventoPratica, Integer> {

    @Query(value = """
    SELECT e
    FROM AnaEventoPratica e
    JOIN AnaDizionarioEventoPratica d ON e.codEp = d.codEp
    WHERE d.archivioAnagrafe = :anagrafe
    AND d.tipoPratica =  :tipoEvento
    ORDER BY d.sequenza ASC
    """)
    List<AnaEventoPratica> findEventiValidi(
            @Param("anagrafe") ETipoAnagrafe anagrafe,
            @Param("tipoEvento") ETipoPratica tipoEvento
    )

    @Query(value = """
    SELECT DISTINCT e 
    FROM AnaEventoPratica e
    WHERE e.codEp IN (
        SELECT d.codEp
        FROM AnaDizionarioEventoPratica d 
        WHERE (:anagrafe IS NULL OR d.archivioAnagrafe = :anagrafe)
        AND (:tipoEvento IS NULL OR d.tipoPratica = :tipoEvento)
    )
    ORDER BY e.descrizione ASC
    """)
    List<AnaEventoPratica> findStatiValidi(
            @Param("anagrafe") ETipoAnagrafe anagrafe,
            @Param("tipoEvento") ETipoPratica tipoEvento
    )

    @Query(value = """
    SELECT e
    FROM AnaEventoPratica e
    WHERE e.codEp = (
        SELECT d.codEpNextP
        FROM AnaDizionarioEventoPratica d 
        WHERE d.archivioAnagrafe = :anagrafe
        AND d.tipoPratica =  :tipoEvento
        AND d.codEp = :codEp
    )
    """)
    AnaEventoPratica findNextEventoPositivo(
            @Param("codEp") Integer codEp,
            @Param("anagrafe") ETipoAnagrafe anagrafe,
            @Param("tipoEvento") ETipoPratica tipoEvento)

    @Query(value = """
    SELECT e
    FROM AnaEventoPratica e
    WHERE e.codEp = (
        SELECT d.codEpNextN
        FROM AnaDizionarioEventoPratica d 
        WHERE d.archivioAnagrafe = :anagrafe
        AND d.tipoPratica =  :tipoEvento
        AND d.codEp = :codEp
    )
    """)
    AnaEventoPratica findNextEventoNegativo(
            @Param("codEp") Integer codEp,
            @Param("anagrafe") ETipoAnagrafe anagrafe,
            @Param("tipoEvento") ETipoPratica tipoEvento)

    AnaEventoPratica findByFlagAnnullamentoIsTrue()

    AnaEventoPratica findByFlagPerfezionamentoIsTrue()

    @Query(value = """
    SELECT e
    FROM AnaEventoPratica e
    JOIN AnaDizionarioEventoPratica d ON e.codEp = d.codEp
    WHERE d.archivioAnagrafe = :anagrafe
    AND d.tipoPratica =  :tipoEvento
    AND (e.flagAnnullamento IS NULL OR e.flagAnnullamento = java.lang.Boolean.FALSE)
    AND (e.flagPerfezionamento IS NULL OR e.flagPerfezionamento = java.lang.Boolean.FALSE)
    ORDER BY d.sequenza ASC
    """)
    List<AnaEventoPratica> findAllByArchivioAnagrafeAndTipoPraticaAndFlagFalse(
            @Param("anagrafe") ETipoAnagrafe anagrafe,
            @Param("tipoEvento") ETipoPratica tipoEvento
    )


}