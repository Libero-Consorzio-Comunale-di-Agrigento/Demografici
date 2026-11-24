package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anagrafe.AnaTipoDocumento
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaTipoDocumentoRepository extends JpaRepository<AnaTipoDocumento, String> {

    AnaTipoDocumento findById(@Param("id") String id)

    Page<AnaTipoDocumento> findAllByDescrizioneEstesaLikeIgnoreCaseAndFlagIdentitaIsTrue(String filtro, Pageable pageable)

    Page<AnaTipoDocumento> findAllByDescrizioneEstesaLikeIgnoreCaseAndFlagRiconoscimentoIsTrue(String filtro, Pageable pageable)

    Page<AnaTipoDocumento> findAllByDescrizioneEstesaLikeIgnoreCaseAndIdIn(String filtro, List<String> ids, Pageable pageable)

    List<AnaTipoDocumento> findAllByFlagConvivenzaDiFattoNotNullOrderByDescrizioneAsc()

    List<AnaTipoDocumento> findAllByFlagConvivenzaDiFattoNullOrderByDescrizioneAsc()

    @Query(
            value = """
        SELECT DISTINCT a FROM AnaTipoDocumento a
        LEFT JOIN FETCH a.codiceAnpr
        WHERE UPPER(a.id) LIKE UPPER(:filtro)
           OR UPPER(a.descrizione) LIKE UPPER(:filtro)
    """,
            countQuery = """
        SELECT COUNT(a) FROM AnaTipoDocumento a
        WHERE UPPER(a.id) LIKE UPPER(:filtro)
           OR UPPER(a.descrizione) LIKE UPPER(:filtro)
    """
    )
    Page<AnaTipoDocumento> findAllByFiltroLike(@Param("filtro") String filtro, Pageable pageable)

    @Query("""
        SELECT a FROM AnaTipoDocumento a
        LEFT JOIN FETCH a.codiceAnpr
        WHERE a.id = :id
    """)
    AnaTipoDocumento findByIdWithFetch(@Param("id") String id)

    long countById(String id)

}