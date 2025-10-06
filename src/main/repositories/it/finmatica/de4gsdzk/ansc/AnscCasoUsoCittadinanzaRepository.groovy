package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscCasoUsoCittadinanza
import it.finmatica.de4gsdzk.utils.ETipoAttoAnsc
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnscCasoUsoCittadinanzaRepository extends JpaRepository<AnscCasoUsoCittadinanza, Long> {

    AnscCasoUsoCittadinanza findById(Long id)

    AnscCasoUsoCittadinanza findByTipoAttoAnscAndFlagServizioIsTrue(ETipoAttoAnsc tipoAttoAnsc)

    @Query("""SELECT c FROM AnscCasoUsoCittadinanza c 
            WHERE COALESCE(c.codiceCategoria, :siglaCategoria) = :siglaCategoria
              AND c.tipoAttoAnsc = :tipoAttoAnsc
              AND c.flagVisibile = java.lang.Boolean.TRUE
              AND (:filtro IS NULL OR UPPER(c.descrizione) LIKE UPPER(:filtro) ) """)
    Page<AnscCasoUsoCittadinanza> findAllByCategoriaAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLike(@Param("filtro") String filtro,
                                                                                                           @Param("siglaCategoria") String siglaCategoria,
                                                                                                           @Param("tipoAttoAnsc") ETipoAttoAnsc tipoAttoAnsc,
                                                                                                           Pageable pageable)

    List<AnscCasoUsoCittadinanza> findAllByCodiceCategoriaLikeAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLikeIgnoreCase(String categoria, ETipoAttoAnsc tipoAttoAnsc, String filtro)

    @Query("""SELECT c.id FROM AnscCasoUsoCittadinanza c 
               WHERE (:siglaCategoria IS NULL OR UPPER(c.codiceCategoria) = UPPER(:siglaCategoria) )
                 AND c.flagVisibile = java.lang.Boolean.TRUE
                 AND (:idMotivoCittadinanza IS NULL OR c.idMotivoCittadinanza = :idMotivoCittadinanza ) """)
    List<Long> findAllByAllFiltri(@Param("siglaCategoria") String siglaCategoria,
                                  @Param("idMotivoCittadinanza") Long idMotivoCittadinanza)

}