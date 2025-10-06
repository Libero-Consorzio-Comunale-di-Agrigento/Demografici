package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivPubblicazione
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivPubblicazioneRepository extends JpaRepository<CivPubblicazione, Long>, CivPubblicazioneCustomRepository {

    @Query("SELECT n.codiceRecord FROM CivPubblicazione n WHERE n.id = :id ")
    Integer findCodiceRecord(@Param("id") Long id)

    @Query("SELECT n.bloccato FROM CivPubblicazione n WHERE n.id = :id ")
    Boolean findBloccato(@Param("id") Long id)

    long countByUfficioAndAnnoAndAttoAndParteAndSerie(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie)
}