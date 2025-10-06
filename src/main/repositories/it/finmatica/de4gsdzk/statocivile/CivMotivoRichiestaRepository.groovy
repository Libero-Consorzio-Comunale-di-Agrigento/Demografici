package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoAtto
import it.finmatica.de4gsdzk.statocivile.CivMotivoRichiesta
import it.finmatica.de4gsdzk.utils.ETipoRichiesta
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivMotivoRichiestaRepository extends JpaRepository<CivMotivoRichiesta, Long> {

    CivMotivoRichiesta findById(Long id)

    @Query("""SELECT c FROM CivMotivoRichiesta c 
               WHERE LOWER(c.descrizione) LIKE LOWER(CONCAT('%',:filtro,'%')) 
                AND (:tipoAtto IS NULL OR c.tipoAtto = :tipoAtto)""")
    Page<CivMotivoRichiesta> findAllByDescrizioneLikeIgnoreCaseAndTipoAtto(@Param("filtro") String filtro,
                                                                           @Param("tipoAtto") Integer tipoAtto,
                                                                           Pageable pageable)

    @Query(value = """SELECT c FROM CivMotivoRichiesta c
                       WHERE c.tipoAtto = :tipoAtto 
                         AND COALESCE(c.categoriaDomain, :categoriaDomain) = :categoriaDomain
                         AND (:tipoRichiesta IS NULL OR c.tipoRichiesta = :tipoRichiesta) 
                         AND (:filtro IS NULL OR UPPER(COALESCE(c.descrizione, '%')) LIKE UPPER(:filtro)) 
                       ORDER BY c.descrizione """)
    List<CivMotivoRichiesta> findAllByTipoAttoAndCategoriaDomainAndTipoRichiestaAndDescrizioneLikeIgnoreCaseOrderByDescrizione(@Param("tipoAtto") Integer tipoAtto,
                                                                                                                               @Param("categoriaDomain") CivCategoriaTipoAtto categoriaDomain,
                                                                                                                               @Param("tipoRichiesta") ETipoRichiesta tipoRichiesta,
                                                                                                                               @Param("filtro") String filtro)

    @Query(value = """SELECT c FROM CivMotivoRichiesta c
                       WHERE c.tipoAtto = :tipoAtto 
                         AND COALESCE(c.categoriaDomain, :categoriaDomain) = :categoriaDomain
                         AND (:tipoRichiesta IS NULL OR c.tipoRichiesta = :tipoRichiesta) 
                         AND (:filtro IS NULL OR UPPER(COALESCE(c.descrizione, '%')) LIKE UPPER(:filtro)) 
                         AND ( (:ricorrente IS NULL AND c.flagRicorrente IS NULL) OR (:ricorrente IS NOT NULL AND c.flagRicorrente = :ricorrente) ) 
                       ORDER BY c.descrizione """)
    List<CivMotivoRichiesta> findAllByCategoriaDomainAndTipoRichiestaAndDescrizioneLikeIgnoreCaseAndRicorrenteOrderByDescrizione(@Param("tipoAtto") Integer tipoAtto,
                                                                                                                                 @Param("categoriaDomain") CivCategoriaTipoAtto categoriaDomain,
                                                                                                                                 @Param("tipoRichiesta") ETipoRichiesta tipoRichiesta,
                                                                                                                                 @Param("filtro") String filtro,
                                                                                                                                 @Param("ricorrente") Boolean ricorrente)
    long countById(Long idMotivo)
}