package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscCasoUsoMatrimonio
import it.finmatica.de4gsdzk.utils.ETipoAttoAnsc
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnscCasoUsoMatrimonioRepository extends JpaRepository<AnscCasoUsoMatrimonio, Long> {

    AnscCasoUsoMatrimonio findById(Long id)

    @Query("""SELECT c FROM AnscCasoUsoMatrimonio c 
            WHERE c.tipoAttoAnsc = :tipoAttoAnsc
              AND COALESCE(c.codiceCategoria, :siglaCategoria) = :siglaCategoria
              AND c.flagServizio = java.lang.Boolean.TRUE """)
    AnscCasoUsoMatrimonio findByTipoAttoAnscAndCategoriaAndFlagServizioIsTrue(@Param("tipoAttoAnsc") ETipoAttoAnsc tipoAttoAnsc,
                                                                              @Param("siglaCategoria") String siglaCategoria)

    @Query("""SELECT c FROM AnscCasoUsoMatrimonio c 
            WHERE COALESCE(c.codiceCategoria, :siglaCategoria) = :siglaCategoria
              AND c.tipoAttoAnsc = :tipoAttoAnsc
              AND c.flagVisibile = java.lang.Boolean.TRUE
              AND (:filtro IS NULL OR UPPER(c.descrizione) LIKE UPPER(:filtro) ) """)
    Page<AnscCasoUsoMatrimonio> findAllByCategoriaAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLike(@Param("filtro") String filtro,
                                                                                                         @Param("siglaCategoria") String siglaCategoria,
                                                                                                         @Param("tipoAttoAnsc") ETipoAttoAnsc tipoAttoAnsc,
                                                                                                         Pageable pageable)

    List<AnscCasoUsoMatrimonio> findAllByCodiceCategoriaLikeAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLikeIgnoreCase(String categoria, ETipoAttoAnsc tipoAttoAnsc, String filtro)

    @Query("""SELECT c.id FROM AnscCasoUsoMatrimonio c 
               WHERE (:siglaCategoria IS NULL OR UPPER(c.codiceCategoria) LIKE UPPER(:siglaCategoria) )
                 AND (:parte IS NULL OR c.parte = :parte ) 
                 AND (:serie IS NULL OR c.serie = :serie ) 
                 AND c.flagVisibile = java.lang.Boolean.TRUE
                 AND (:tipoAttoAnsc IS NULL OR c.tipoAttoAnsc = :tipoAttoAnsc )  
                 AND (COALESCE(c.flagRitoCattolico, :flagRitoCattolico) IS NULL OR c.flagRitoCattolico = :flagRitoCattolico)
                 AND (COALESCE(c.flagCasaComunale, :flagCasaComunale) IS NULL OR c.flagCasaComunale = :flagCasaComunale)
                 AND (COALESCE(c.flagExArt19, :flagExArt19) IS NULL OR c.flagExArt19 = :flagExArt19)
                 AND (COALESCE(c.riconoscimentoFigli, :riconoscimentoFigli) = :riconoscimentoFigli )
                 AND (COALESCE(c.tipoDivorzio, :tipoDivorzio) LIKE :tipoDivorzio )
                 AND (:tipoDivorzioAltro IS NULL OR c.tipoDivorzioAltro LIKE :tipoDivorzioAltro ) 
                 AND (COALESCE(c.flagStranieriNonResidenti, :flagStranieriNonResidenti) IS NULL OR c.flagStranieriNonResidenti = :flagStranieriNonResidenti)
                 AND (COALESCE(c.flagInViaggio, :flagInViaggio) IS NULL OR c.flagInViaggio = :flagInViaggio) """)
    List<Long> findAllByAllFiltri(@Param("siglaCategoria") String siglaCategoria,
                                  @Param("parte") Integer parte,
                                  @Param("serie") String serie,
                                  @Param("tipoAttoAnsc") ETipoAttoAnsc tipoAttoAnsc,
                                  @Param("flagRitoCattolico") Boolean flagRitoCattolico,
                                  @Param("flagCasaComunale") Boolean flagCasaComunale,
                                  @Param("flagExArt19") Boolean flagExArt19,
                                  @Param("riconoscimentoFigli") ETipoSiNo riconoscimentoFigli,
                                  @Param("tipoDivorzio") String tipoDivorzio,
                                  @Param("tipoDivorzioAltro") String tipoDivorzioAltro,
                                  @Param("flagStranieriNonResidenti") Boolean flagStranieriNonResidenti,
                                  @Param("flagInViaggio") Boolean flagInViaggio)

}