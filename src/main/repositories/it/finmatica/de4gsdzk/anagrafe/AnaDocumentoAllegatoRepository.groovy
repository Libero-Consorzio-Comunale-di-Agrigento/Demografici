package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anagrafe.AnaDocumentoAllegato
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaDocumentoAllegatoRepository extends JpaRepository<AnaDocumentoAllegato, Integer> {

    @Query(value = """SELECT a
                      FROM AnaDocumentoAllegato a 
                      LEFT JOIN FETCH a.documento
                      WHERE a.documento = :documento """)
    List<AnaDocumentoAllegato> findAllByDocumento(@Param("documento") AnaDocumento documento)
}