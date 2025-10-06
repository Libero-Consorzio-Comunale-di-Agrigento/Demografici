package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscCasoUsoUnioneCivile
import it.finmatica.de4gsdzk.utils.ETipoAttoAnsc
import it.finmatica.de4gsdzk.utils.ETipoDivorzioAltro
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnscCasoUsoUnioneCivileRepository extends JpaRepository<AnscCasoUsoUnioneCivile, Long> {

    AnscCasoUsoUnioneCivile findById(Long id)

    AnscCasoUsoUnioneCivile findByTipoAttoAnscAndFlagServizioIsTrue(ETipoAttoAnsc tipoAttoAnsc)

    @Query("""SELECT c FROM AnscCasoUsoUnioneCivile c 
            WHERE COALESCE(c.codiceCategoria, :siglaCategoria) = :siglaCategoria
              AND c.tipoAttoAnsc = :tipoAttoAnsc
              AND c.flagVisibile = java.lang.Boolean.TRUE
              AND (:filtro IS NULL OR UPPER(c.descrizione) LIKE UPPER(:filtro) ) """)
    Page<AnscCasoUsoUnioneCivile> findAllByCategoriaAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLike(@Param("filtro") String filtro,
                                                                                                           @Param("siglaCategoria") String siglaCategoria,
                                                                                                           @Param("tipoAttoAnsc") ETipoAttoAnsc tipoAttoAnsc,
                                                                                                           Pageable pageable)

    List<AnscCasoUsoUnioneCivile> findAllByCodiceCategoriaLikeAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLikeIgnoreCase(String categoria, ETipoAttoAnsc tipoAttoAnsc, String filtro)

    @Query("""SELECT c.id FROM AnscCasoUsoUnioneCivile c 
               WHERE (:siglaCategoria IS NULL OR UPPER(c.codiceCategoria) = UPPER(:siglaCategoria) )
                 AND (:parte IS NULL OR c.parte = :parte ) 
                 AND c.flagVisibile = java.lang.Boolean.TRUE
                 AND (COALESCE(c.flagCasaComunale, :flagCasaComunale) IS NULL OR c.flagCasaComunale = :flagCasaComunale)
                 AND (:tipoDichiarante IS NULL OR COALESCE(c.tipoDichiarante, :tipoDichiarante ) LIKE :tipoDichiarante ) 
                 AND (:tipoDivorzioAltro IS NULL OR c.tipoDivorzioAltro = :tipoDivorzioAltro ) 
                 AND (COALESCE(c.flagExArt19, :flagExArt19) IS NULL OR c.flagExArt19 = :flagExArt19) """)
    List<Long> findAllByAllFiltri(@Param("siglaCategoria") String siglaCategoria,
                                  @Param("parte") Integer parte,
                                  @Param("flagCasaComunale") Boolean flagCasaComunale,
                                  @Param("tipoDichiarante") String tipoDichiarante,
                                  @Param("tipoDivorzioAltro") ETipoDivorzioAltro tipoDivorzioAltro,
                                  @Param("flagExArt19") Boolean flagExArt19)
}