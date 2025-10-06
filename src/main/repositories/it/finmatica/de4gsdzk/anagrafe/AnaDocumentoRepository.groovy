package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaDocumentoRepository extends JpaRepository<AnaDocumento, Long>, AnaDocumentoCustomRepository {

    @Query("""SELECT d FROM AnaDocumento d 
                  JOIN FETCH d.anagrafe
                  JOIN FETCH d.tipoDocumento
                  LEFT JOIN FETCH d.allegati
                  LEFT JOIN FETCH d.ente
                WHERE d.id = :id""")
    AnaDocumento findById(@Param("id") Long id)

    @Query("""SELECT d FROM AnaDocumento d
                 JOIN FETCH d.anagrafe
                 JOIN FETCH d.tipoDocumento
                 LEFT JOIN FETCH d.allegati
                WHERE d.anagrafe = :anagrafe
                  AND d.tipoDocumento = :tipoDocumento
                ORDER BY d.progressivo DESC""")
    List<AnaDocumento> findAllByAnagrafeAndTipoDocumentoOrderByProgressivoDesc(@Param("anagrafe") AnaAnagrafe anagrafe,
                                                                               @Param("tipoDocumento") AnaTipoDocumento tipoDocumento)

    @Modifying
    @Query("""UPDATE AnaDocumento d SET d.progressivo = d.progressivo + 1
                WHERE d.anagrafe = :anagrafe AND d.tipoDocumento = :tipoDocumento""")
    void incrementProgressivoByAnagrafeAndTipoDocumento(@Param("anagrafe") AnaAnagrafe anagrafe,
                                                        @Param("tipoDocumento") AnaTipoDocumento tipoDocumento)
}