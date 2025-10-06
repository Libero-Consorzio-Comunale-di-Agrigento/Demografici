package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerValiditaCertificato
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerValiditaCertificatoRepository extends JpaRepository<CerValiditaCertificato, Integer> {

    CerValiditaCertificato findById(Integer id)

    Page<CerValiditaCertificato> findAllByDescrizioneLikeIgnoreCase(String filtro, Pageable pageable)

    @Query("""SELECT COUNT(c) AS NUM_VAL FROM CerValiditaCertificato c WHERE c.id = :idValidita """)
    Integer checkValiditaCertificato(@Param("idValidita") Integer idValidita)

}