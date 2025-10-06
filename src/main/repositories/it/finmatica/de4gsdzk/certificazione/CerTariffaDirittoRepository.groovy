package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerCategoriaTipoCertificato
import it.finmatica.de4gsdzk.certificazione.CerTariffaDiritto
import it.finmatica.de4gsdzk.certificazione.EDiritto
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerTariffaDirittoRepository extends JpaRepository<CerTariffaDiritto, Long> {

    CerTariffaDiritto findById(Long id)

    CerTariffaDiritto findByDirittoAndFasciaTariffaria(EDiritto diritto, Integer fasciaTariffaria)

    @Query(value = """SELECT c FROM CerTariffaDiritto c 
                        LEFT JOIN FETCH c.categoriaTipiCertificatoList ctc
                       WHERE UPPER(c.descrizione) LIKE UPPER( :descrizione) 
                              AND (:categoria IS NULL OR :categoria MEMBER OF c.categoriaTipiCertificatoList)""",
            countQuery = """SELECT count(c) FROM CerTariffaDiritto c
                         LEFT JOIN c.categoriaTipiCertificatoList ctc
                       WHERE UPPER(c.descrizione) LIKE UPPER( :descrizione)
                        AND (:categoria IS NULL OR :categoria MEMBER OF c.categoriaTipiCertificatoList)""")
    Page<CerTariffaDiritto> findAllByDescrizioneLikeIgnoreCaseAndCategoriaTipoCertificatoInList(@Param("descrizione") String filtro,
                                                                                                @Param("categoria") CerCategoriaTipoCertificato categoria,
                                                                                                Pageable pageable)

    List<CerTariffaDiritto> findAllByDirittoOrderByFasciaTariffaria(EDiritto diritto)

    @Query("""SELECT ctc FROM CerTariffaDiritto c 
               JOIN c.categoriaTipiCertificatoList ctc 
               WHERE c.id = :id
               ORDER BY ctc.sequenza ASC""")
    List<CerCategoriaTipoCertificato> findCategoriaTipoCertificatoListById(@Param("id") Long id)

    @Query("""SELECT CASE WHEN COUNT(ctd) > 0 THEN true ELSE false END
                FROM CerTariffaDiritto ctd 
                JOIN ctd.categoriaTipiCertificatoList ctc
                WHERE (:id IS NULL OR ctd.id <> :id)
                AND ctc = :categoriaTipoCertificato
                AND ctd.diritto = :diritto""")
    boolean existsByIdAndCategoriaTipoCertificatoAndDiritto(@Param("id") Long id,
                                                            @Param("categoriaTipoCertificato") CerCategoriaTipoCertificato categoriaTipoCertificato,
                                                            @Param("diritto") EDiritto diritto)

}