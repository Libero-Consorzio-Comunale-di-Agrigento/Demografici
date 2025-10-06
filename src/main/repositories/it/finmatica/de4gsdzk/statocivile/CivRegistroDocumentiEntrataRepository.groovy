package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivRegistroDocumentiEntrata
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivRegistroDocumentiEntrataRepository extends JpaRepository<CivRegistroDocumentiEntrata, Integer> {

    CivRegistroDocumentiEntrata findById(Integer id)

    Page<CivRegistroDocumentiEntrata> findAllByDescrizioneLikeIgnoreCase(String filtro, Pageable pageable)

    @Query("""SELECT (COALESCE(MAX(c.id), 0) + 1) AS ID FROM CivRegistroDocumentiEntrata c """)
    Object[] findMaxId()

    long countById(Integer idRde)

}