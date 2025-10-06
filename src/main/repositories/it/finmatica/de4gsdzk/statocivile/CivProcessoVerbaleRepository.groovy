package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivProcessoVerbale
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivProcessoVerbaleRepository extends JpaRepository<CivProcessoVerbale, Long>, CivProcessoVerbaleCustomRepository {

    @Query("SELECT n.codiceRecord FROM CivProcessoVerbale n WHERE n.id = :id ")
    Integer findCodiceRecord(@Param("id") Long id)

    @Query("SELECT n.bloccato FROM CivProcessoVerbale n WHERE n.id = :id ")
    Boolean findBloccato(@Param("id") Long id)

}