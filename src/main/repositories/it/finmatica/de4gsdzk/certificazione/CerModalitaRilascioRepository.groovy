package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerCategoriaTipoCertificato
import it.finmatica.de4gsdzk.certificazione.CerModalitaRilascio
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerModalitaRilascioRepository extends JpaRepository<CerModalitaRilascio, Integer> {

    @Query("""SELECT c FROM CerModalitaRilascio c 
                       LEFT OUTER JOIN FETCH c.categoriaTipoCertificato
                       LEFT OUTER JOIN FETCH c.motivoEsenzioneBollo WHERE c.id = :id """)
    CerModalitaRilascio findById(@Param("id") Integer id)

    @Query(value = """SELECT c FROM CerModalitaRilascio c LEFT OUTER JOIN FETCH c.motivoEsenzioneBollo """,
            countQuery = """SELECT count(c) FROM CerModalitaRilascio c
                              LEFT OUTER JOIN c.motivoEsenzioneBollo """)
    Page<CerModalitaRilascio> findAll(Pageable pageable)

    @Query(value = """SELECT c FROM CerModalitaRilascio c
                        LEFT OUTER JOIN FETCH c.motivoEsenzioneBollo
                       WHERE UPPER(c.descrizioneEstesa) LIKE UPPER(:filtro)""",
            countQuery = """SELECT count(c) FROM CerModalitaRilascio c
                              LEFT OUTER JOIN c.motivoEsenzioneBollo 
                             WHERE UPPER(c.descrizioneEstesa) LIKE UPPER(:filtro) """)
    Page<CerModalitaRilascio> findAllByDescrizioneLikeIgnoreCase(@Param("filtro") String filtro,
                                                                 Pageable pageable)

    @Query(value = """SELECT c FROM CerModalitaRilascio c
                        LEFT OUTER JOIN FETCH c.motivoEsenzioneBollo
                       WHERE (c.categoriaTipoCertificato in (:ctc) OR c.categoriaTipoCertificato IS NULL)
                         AND UPPER(c.descrizioneEstesa) LIKE UPPER(:filtro)
                         AND (c.flagDismesso IS NULL OR c.flagDismesso = java.lang.Boolean.FALSE)""",
            countQuery = """SELECT count(c) FROM CerModalitaRilascio c
                              LEFT OUTER JOIN c.motivoEsenzioneBollo 
                             WHERE (c.categoriaTipoCertificato in (:ctc) OR c.categoriaTipoCertificato IS NULL)
                               AND UPPER(c.descrizioneEstesa) LIKE UPPER(:filtro) 
                               AND (c.flagDismesso IS NULL OR c.flagDismesso = java.lang.Boolean.FALSE)""")
    Page<CerModalitaRilascio> findAllByCategoriaTipoCertificatoInListAndDescrizioneEstesaLikeIgnoreCaseAndFlagDismessoFalse(@Param("ctc") List<CerCategoriaTipoCertificato> categoriaTipoCertificatoList,
                                                                                                                            @Param("filtro") String filtro,
                                                                                                                            Pageable pageable)

    @Query(value = """SELECT c FROM CerModalitaRilascio c
                        LEFT OUTER JOIN FETCH c.motivoEsenzioneBollo
                       WHERE UPPER(c.descrizioneEstesa) LIKE UPPER(:filtro)
                         AND (c.flagDismesso IS NULL OR c.flagDismesso = java.lang.Boolean.FALSE)""",
            countQuery = """SELECT count(c) FROM CerModalitaRilascio c
                              LEFT OUTER JOIN c.motivoEsenzioneBollo 
                             WHERE UPPER(c.descrizioneEstesa) LIKE UPPER(:filtro) 
                               AND (c.flagDismesso IS NULL OR c.flagDismesso = java.lang.Boolean.FALSE)""")
    Page<CerModalitaRilascio> findAllByDescrizioneEstesaLikeIgnoreCaseAndFlagDismessoFalse(@Param("filtro") String filtro,
                                                                                           Pageable pageable)

    @Query(value = """SELECT c FROM CerModalitaRilascio c
                        LEFT OUTER JOIN FETCH c.motivoEsenzioneBollo
                       WHERE UPPER(c.descrizioneStampa) LIKE UPPER(:filtro)
                         AND (c.flagDismesso IS NULL OR c.flagDismesso = java.lang.Boolean.FALSE)""",
            countQuery = """SELECT count(c) FROM CerModalitaRilascio c
                              LEFT OUTER JOIN c.motivoEsenzioneBollo 
                             WHERE UPPER(c.descrizioneStampa) LIKE UPPER(:filtro) 
                               AND (c.flagDismesso IS NULL OR c.flagDismesso = java.lang.Boolean.FALSE)""")
    Page<CerModalitaRilascio> findAllByDescrizioneStampaLikeIgnoreCaseAndFlagDismessoFalse(@Param("filtro") String filtro,
                                                                                           Pageable pageable)

    long countById(Integer idModalita)

}