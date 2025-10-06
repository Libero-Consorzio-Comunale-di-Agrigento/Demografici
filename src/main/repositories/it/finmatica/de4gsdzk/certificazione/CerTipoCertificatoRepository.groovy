package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerCategoriaTipoCertificato
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerTipoCertificatoRepository extends JpaRepository<CerTipoCertificato, String>, CerTipoCertificatoCustomRepository {

    @Query("""SELECT c FROM CerTipoCertificato c 
                LEFT JOIN FETCH c.categoriaTipoCertificato
                LEFT JOIN FETCH c.tipoCertificatoTariffaDirittoList
                LEFT JOIN FETCH c.firma
                LEFT JOIN FETCH c.filtro
                LEFT JOIN FETCH c.validita
                LEFT JOIN FETCH c.codiceControllo
                LEFT JOIN FETCH c.tipoDocumentoAnagrafe
               WHERE c.id = :id """)
    CerTipoCertificato findById(@Param("id") String id)

    @Query(value = """SELECT c FROM CerTipoCertificato c """,
            countQuery = """SELECT count(c) FROM CerTipoCertificato c """)
    Page<CerTipoCertificato> findAll(Pageable pageable)

    @Query(value = """SELECT c FROM CerTipoCertificato c
                       WHERE UPPER(c.descrizioneEstesa) LIKE UPPER(:filtro) """,
            countQuery = """SELECT count(c) FROM CerTipoCertificato c
                             WHERE UPPER(c.descrizioneEstesa) LIKE UPPER(:filtro) """)
    Page<CerTipoCertificato> findAllByDescrizioneEstesaLikeIgnoreCase(@Param("filtro") String filtro, Pageable pageable)

    @Query(value = """SELECT c FROM CerTipoCertificato c
                       WHERE UPPER(c.descrizione) LIKE UPPER(:filtro) """,
            countQuery = """SELECT count(c) FROM CerTipoCertificato c
                             WHERE UPPER(c.descrizione) LIKE UPPER(:filtro) """)
    Page<CerTipoCertificato> findAllByDescrizioneLikeIgnoreCase(@Param("filtro") String filtro, Pageable pageable)

    @Query(value = """SELECT c FROM CerTipoCertificato c
                       WHERE UPPER(c.descrizione) LIKE UPPER(:filtro)
                       AND (
                        (:categoriaTipoCertificato IS NULL AND c.categoriaTipoCertificato IS NULL)
                        OR
                        (:categoriaTipoCertificato IS NOT NULL AND c.categoriaTipoCertificato = :categoriaTipoCertificato)
                       ) """,
            countQuery = """SELECT count(c) FROM CerTipoCertificato c
                             WHERE UPPER(c.descrizione) LIKE UPPER(:filtro)
                             AND (
                              (:categoriaTipoCertificato IS NULL AND c.categoriaTipoCertificato IS NULL)
                              OR
                              (:categoriaTipoCertificato IS NOT NULL AND c.categoriaTipoCertificato = :categoriaTipoCertificato)
                             ) """)
    Page<CerTipoCertificato> findAllByCategoriaAndDescrizioneLikeIgnoreCase(@Param("categoriaTipoCertificato") CerCategoriaTipoCertificato categoriaTipoCertificato,
                                                                            @Param("filtro") String filtro,
                                                                            Pageable pageable)

    long countById(String idTipoCertificato)

    long countByCategoriaTipoCertificatoIsNull()

}