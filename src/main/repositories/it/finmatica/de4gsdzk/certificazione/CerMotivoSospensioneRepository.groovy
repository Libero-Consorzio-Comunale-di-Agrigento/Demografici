package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerMotivoSospensione
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerMotivoSospensioneRepository extends JpaRepository<CerMotivoSospensione, Integer> {

    @Query("""SELECT c FROM CerMotivoSospensione c
                LEFT JOIN FETCH c.certificabilita
                LEFT JOIN FETCH c.tutela
                    WHERE c.id = :id""")
    CerMotivoSospensione findById(@Param("id") Integer id)

    Page<CerMotivoSospensione> findAllByDescrizioneLikeIgnoreCase(String filtro, Pageable pageable)

    long countById(Integer idMotivo)

}