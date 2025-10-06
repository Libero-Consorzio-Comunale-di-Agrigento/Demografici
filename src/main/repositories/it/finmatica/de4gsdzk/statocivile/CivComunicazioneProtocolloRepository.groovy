package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneProtocollo
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivComunicazioneProtocolloRepository extends JpaRepository<CivComunicazioneProtocollo, Long> {

    @Query("""SELECT c FROM CivComunicazioneProtocollo c JOIN FETCH c.comunicazione WHERE c.id = :id """)
    CivComunicazioneProtocollo findById(@Param("id") Long id)

}