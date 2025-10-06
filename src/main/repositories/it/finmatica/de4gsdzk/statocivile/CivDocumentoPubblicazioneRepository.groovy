package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivDocumentoPubblicazione
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivDocumentoPubblicazioneRepository extends JpaRepository<CivDocumentoPubblicazione, Long> {

    @Query("""SELECT c FROM CivDocumentoPubblicazione c WHERE c.idAtto = :identificativoAtto and c.tipoAtto = :tipoAtto """)
    CivDocumentoPubblicazione findByUkAttoAndTipoAtto(@Param("identificativoAtto") String identificativoAtto, @Param("tipoAtto") Integer tipoAtto)

}