package it.finmatica.de4gsdzk.pagamento.depag

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.pagamento.depag.DepagDocumento
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface DepagDocumentoRepository extends JpaRepository<DepagDocumento, Long> {

    @Query("""SELECT a FROM DepagDocumento a
                JOIN FETCH a.tipoCertificato b
                JOIN FETCH b.categoriaTipoCertificato
               WHERE a.id = :id """)
    DepagDocumento findById(@Param("id") Long id)

    @Query(value = """SELECT a FROM DepagDocumento a
                JOIN FETCH a.tipoCertificato b
                JOIN FETCH b.categoriaTipoCertificato
               WHERE UPPER(b.descrizione) LIKE UPPER(:filtro) """,
            countQuery = """SELECT count(a) FROM DepagDocumento a
                JOIN a.tipoCertificato b
                JOIN b.categoriaTipoCertificato
               WHERE UPPER(b.descrizione) LIKE UPPER(:filtro) """)
    Page<DepagDocumento> findAllByTipoCertificatoDescrizioneLikeIgnoreCase(@Param("filtro") String filtro, Pageable pageable)

}
