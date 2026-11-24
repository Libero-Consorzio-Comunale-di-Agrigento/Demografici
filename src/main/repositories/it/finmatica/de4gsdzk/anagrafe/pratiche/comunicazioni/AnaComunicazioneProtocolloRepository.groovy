package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import groovy.transform.CompileStatic
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaComunicazioneProtocolloRepository extends JpaRepository<AnaComunicazioneProtocollo, Long> {

    @Query("""SELECT c FROM AnaComunicazioneProtocollo c JOIN FETCH c.comunicazione WHERE c.id = :id """)
    AnaComunicazioneProtocollo findById(@Param("id") Long id)

}