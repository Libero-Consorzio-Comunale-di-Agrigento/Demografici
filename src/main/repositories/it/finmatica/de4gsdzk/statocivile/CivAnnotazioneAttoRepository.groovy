package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAtto
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.utils.EStatoAnnotazione
import it.finmatica.de4gsdzk.utils.ETipoAnnotazione
import it.finmatica.de4gsdzk.utils.ETipoSN
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivAnnotazioneAttoRepository extends JpaRepository<CivAnnotazioneAtto, Long>, CivAnnotazioneAttoCustomRepository {

    @Query("""SELECT c FROM CivAnnotazioneAtto c JOIN FETCH c.formulaDfa WHERE c.id = :id """)
    CivAnnotazioneAtto findById(@Param("id") Long id)

    @Query(value = """SELECT c 
                        FROM CivAnnotazioneAtto c JOIN FETCH c.formulaDfa 
                       WHERE c.idAtto = :identificativoAtto 
                         AND c.tipoAtto = :tipoAtto
                         AND c.formulaDfa.tipoAnnotazione IN (:listaTipi) """,
            countQuery = """SELECT COUNT(c) 
                              FROM CivAnnotazioneAtto c JOIN c.formulaDfa 
                             WHERE c.idAtto = :identificativoAtto 
                               AND c.tipoAtto = :tipoAtto
                               AND c.formulaDfa.tipoAnnotazione IN (:listaTipi) """)
    Page<CivAnnotazioneAtto> findAllByUkAttoAndTipoAttoAndTipoIn(@Param("identificativoAtto") String identificativoAtto,
                                                                 @Param("tipoAtto") Integer tipoAtto,
                                                                 @Param("listaTipi") List<ETipoAnnotazione> listaTipi, Pageable pageable)

    @Query("""SELECT COUNT(c) 
                              FROM CivAnnotazioneAtto c JOIN c.formulaDfa 
                             WHERE c.idAtto = :identificativoAtto 
                               AND c.tipoAtto = :tipoAtto
                               AND c.formulaDfa.tipoAnnotazione IN (:listaTipi)""")
    int countByUkAttoAndTipoAttoAndTipoIn(@Param("identificativoAtto") String identificativoAtto,
                                          @Param("tipoAtto") Integer tipoAtto,
                                          @Param("listaTipi") List<ETipoAnnotazione> listaTipi)

    CivAnnotazioneAtto findFirstByIdAttoOrderBySequenzaDesc(String identificativoAtto)

    @Query("""SELECT COUNT(c) FROM CivAnnotazioneAtto c INNER JOIN c.formulaDfa WHERE c.formulaDfa.id = :idFormula """)
    Integer checkAnnotazioneInUso(@Param("idFormula") String idFormula)

    @Query("""SELECT c FROM CivAnnotazioneAtto c 
               WHERE c.idAtto = :identificativoAtto 
                 AND c.stato = :stato 
                 AND c.stampaSuAtto = :stampaSuAtto
               ORDER BY c.dataRegistrazione, c.sequenza""")
    List<CivAnnotazioneAtto> findAllByUkAttoAndStatoAndStampaSuAtto(@Param("identificativoAtto") String identificativoAtto, @Param("stato") EStatoAnnotazione stato, @Param("stampaSuAtto") Boolean stampaSuAtto)

    @Query(value = """SELECT DISTINCT(c.formulaDfa) 
                FROM CivAnnotazioneAtto c INNER JOIN c.formulaDfa
               WHERE TRUNC(COALESCE(c.dataRegistrazione, :dal)) >= :dal
                 AND TRUNC(COALESCE(c.dataRegistrazione, :al)) <= :al
                 AND c.formulaDfa.id like :idFormulaDfa
                 AND c.stato IN (:listaStati) 
                 AND c.tipoAtto IN (:listaTipiatto) """,
            countQuery = """SELECT COUNT(DISTINCT c.formulaDfa ) 
                FROM CivAnnotazioneAtto c INNER JOIN c.formulaDfa
               WHERE TRUNC(COALESCE(c.dataRegistrazione, :dal)) >= :dal
                 AND TRUNC(COALESCE(c.dataRegistrazione, :al)) <= :al
                 AND c.formulaDfa.id like :idFormulaDfa
                 AND c.stato IN (:listaStati)  
                 AND c.tipoAtto IN (:listaTipiatto) """)
    Page<CivFormulaAnnotazione> findAllDistinctFormulaDfa(@Param("dal") Date dal, @Param("al") Date al, @Param("idFormulaDfa") String idFormulaDfa,
                                                          @Param("listaStati") List<EStatoAnnotazione> listaStati,
                                                          @Param("listaTipiatto") List<Integer> listaTipiatto, Pageable pageable)

    @Query(value = """SELECT c 
                        FROM CivAnnotazioneAtto c INNER JOIN c.formulaDfa
                       WHERE TRUNC(COALESCE(c.dataRegistrazione, :dal)) >= :dal
                         AND TRUNC(COALESCE(c.dataRegistrazione, :al)) <= :al
                         AND c.formulaDfa.id = :idFormulaDfa
                         AND c.stato IN (:listaStati) 
                         AND c.tipoAtto IN (:listaTipiatto) 
                       ORDER BY c.dataRegistrazione DESC """)
    List<CivAnnotazioneAtto> findAllByFormulaDfaAndDataRegistrazioneAndStatoAndTipoAttoIn(@Param("dal") Date dal, @Param("al") Date al, @Param("idFormulaDfa") String idFormulaDfa,
                                                                                          @Param("listaStati") List<EStatoAnnotazione> listaStati,
                                                                                          @Param("listaTipiatto") List<Integer> listaTipiatto)

    @Modifying
    @Query("UPDATE CivAnnotazioneAtto c SET c.idAnscUseCase = :idAnscUseCase WHERE c.id = :id")
    void updateIdAnscUseCase(@Param(value = "id") Long id, @Param(value = "idAnscUseCase") Long idAnscUseCase)

    @Modifying
    @Query("UPDATE CivAnnotazioneAtto c SET c.idAttoAnsc = :idAttoAnsc WHERE c.id = :id")
    void updateIdAttoAnsc(@Param(value = "id") Long id, @Param(value = "idAttoAnsc") String idAttoAnsc)

    @Modifying
    @Query("UPDATE CivAnnotazioneAtto c SET c.annoAnnotazione = :annoAnnotazione, c.numeroUnico = :numeroUnico WHERE c.id = :id")
    void updateAnnoAnnotazioneAndNumeroUnico(@Param(value = "id") Long id,
                                             @Param(value = "annoAnnotazione") Integer annoAnnotazione,
                                             @Param(value = "numeroUnico") Long numeroUnico)

    @Modifying
    @Query("UPDATE CivAnnotazioneAtto c SET c.stampaSuEstrattoDb = :stampaSuEstrattoDb WHERE c.id = :id")
    void updateStampaSuEstratto(@Param(value = "id") Long id, @Param(value = "stampaSuEstrattoDb") ETipoSN stampaSuEstrattoDb)

    @Query("SELECT n.idAttoAnsc FROM CivAnnotazioneAtto n WHERE n.id = :id ")
    String findIdAttoAnsc(@Param("id") Long id)

    long countByIdAttoAnsc(String idAttoAnsc)

}