package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivRegistroDocumentiUscita
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivRegistroDocumentiUscitaRepository extends JpaRepository<CivRegistroDocumentiUscita, Integer> {

    @Query(value = """SELECT c FROM CivRegistroDocumentiUscita c LEFT JOIN FETCH c.tipoRegistro WHERE c.id = :id """)
    CivRegistroDocumentiUscita findById(@Param("id") Integer id)

    @Query(value = """SELECT c FROM CivRegistroDocumentiUscita c LEFT JOIN FETCH c.tipoRegistro ORDER BY c.descrizione """)
    List<CivRegistroDocumentiUscita> findAll()

    @Query(value = """SELECT c FROM CivRegistroDocumentiUscita c LEFT JOIN FETCH c.tipoRegistro
                       WHERE UPPER(c.descrizione) LIKE UPPER(:filtro) """,
            countQuery = """SELECT count(c) FROM CivRegistroDocumentiUscita c LEFT JOIN c.tipoRegistro  
                             WHERE UPPER(c.descrizione) LIKE UPPER(:filtro) """)
    Page<CivRegistroDocumentiUscita> findAllByDescrizioneLike(@Param("filtro") String filtro, Pageable pageable)

    @Query(value = """SELECT c FROM CivRegistroDocumentiUscita c LEFT JOIN FETCH c.tipoRegistro """,
            countQuery = """SELECT count(c) FROM CivRegistroDocumentiUscita c LEFT JOIN c.tipoRegistro  """)
    Page<CivRegistroDocumentiUscita> findAllOrderedById(Pageable pageable)

    @Query("""SELECT (COALESCE(MAX(c.id), 0) + 1) AS ID FROM CivRegistroDocumentiUscita c """)
    Object[] findMaxId()

    long countById(Integer idRdu)
}