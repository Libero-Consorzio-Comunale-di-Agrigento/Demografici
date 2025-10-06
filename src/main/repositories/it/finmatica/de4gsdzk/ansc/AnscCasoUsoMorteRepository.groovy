package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscCasoUsoMorte
import it.finmatica.de4gsdzk.utils.ETipoAttoAnsc
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnscCasoUsoMorteRepository extends JpaRepository<AnscCasoUsoMorte, Long> {

    AnscCasoUsoMorte findById(Long id)

    AnscCasoUsoMorte findByTipoAttoAnscAndFlagServizioIsTrue(ETipoAttoAnsc tipoAttoAnsc)

    @Query("""SELECT c FROM AnscCasoUsoMorte c 
            WHERE COALESCE(c.codiceCategoria, :siglaCategoria) = :siglaCategoria
              AND c.tipoAttoAnsc = :tipoAttoAnsc
              AND c.flagVisibile = java.lang.Boolean.TRUE
              AND (:filtro IS NULL OR UPPER(c.descrizione) LIKE UPPER(:filtro) ) """)
    Page<AnscCasoUsoMorte> findAllByCategoriaAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLike(@Param("filtro") String filtro,
                                                                                                    @Param("siglaCategoria") String siglaCategoria,
                                                                                                    @Param("tipoAttoAnsc") ETipoAttoAnsc tipoAttoAnsc,
                                                                                                    Pageable pageable)

    List<AnscCasoUsoMorte> findAllByCodiceCategoriaLikeAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLikeIgnoreCase(String categoria, ETipoAttoAnsc tipoAttoAnsc, String filtro)

    @Query("""SELECT c.id FROM AnscCasoUsoMorte c 
               WHERE (:siglaCategoria IS NULL OR UPPER(c.codiceCategoria) = UPPER(:siglaCategoria) )
                 AND (:parte IS NULL OR c.parte = :parte ) 
                 AND (:serie IS NULL OR c.serie = :serie ) 
                 AND c.flagVisibile = java.lang.Boolean.TRUE
                 AND (:estremiDecessoNoti IS NULL OR COALESCE(c.estremiDecessoNoti, :estremiDecessoNoti ) = :estremiDecessoNoti ) 
                 AND (:morteViolenta IS NULL OR COALESCE(c.morteViolenta, :morteViolenta ) = :morteViolenta )  
                 AND (COALESCE(c.flagExArt19, :flagExArt19) IS NULL OR c.flagExArt19 = :flagExArt19) 
                 AND (COALESCE(c.flagInViaggio, :flagInViaggio) IS NULL OR c.flagInViaggio = :flagInViaggio)""")
    List<Long> findAllByAllFiltri(@Param("siglaCategoria") String siglaCategoria,
                                  @Param("parte") Integer parte,
                                  @Param("serie") String serie,
                                  @Param("estremiDecessoNoti") ETipoSiNo estremiDecessoNoti,
                                  @Param("morteViolenta") ETipoSiNo morteViolenta,
                                  @Param("flagExArt19") Boolean flagExArt19,
                                  @Param("flagInViaggio") Boolean flagInViaggio)

}