package it.finmatica.de4gsdzk.ansc

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.ansc.AnscEntita
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnscEntitaRepository extends JpaRepository<AnscEntita, String> {

    AnscEntita findById(String id)

    @Query("""SELECT c
                FROM AnscEntita c 
               WHERE (:idAttoAnsc IS NULL OR idAttoAnsc LIKE :idAttoAnsc)
                 AND (:anno IS NULL OR anno = :anno)
                 AND (:numeroUnico IS NULL OR numeroUnico = :numeroUnico)
                 AND (:archivioRif IS NULL OR archivioRif = :archivioRif)
                 AND (:cognome IS NULL OR UPPER(cognome1) LIKE :cognome OR UPPER(cognome2) LIKE :cognome)  
                 AND (:nome IS NULL OR UPPER(nome1) LIKE :nome OR UPPER(nome2) LIKE :nome) """)
    Page<AnscEntita> findAll(@Param("idAttoAnsc") String idAttoAnsc,
                             @Param("numeroUnico") Long numeroUnico,
                             @Param("anno") Integer anno,
                             @Param("cognome") String cognome,
                             @Param("nome") String nome,
                             @Param("archivioRif") ETipoArchivioAnsc archivioRif,
                             Pageable pageable)

}