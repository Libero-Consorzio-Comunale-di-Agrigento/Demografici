package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.utils.ETipoLista
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface EleTimbroRepository extends JpaRepository<EleTimbro, Long> {

    List<EleTimbro> findAllByTipoListaAndTipoAndProgressivo(ETipoLista tipoLista, Integer tipo, Integer progressivo)

    EleTimbro findByTipoListaAndTipoAndProgressivo(ETipoLista tipoLista, Integer tipo, Integer progressivo)

    List<EleTimbro> findAllByTipoListaAndTipoAndFlagDefaultEstrattoIsTrue(ETipoLista tipoLista, Integer tipo)

    EleTimbro findById(Long id)

    @Query(
        value = """
            SELECT a FROM EleTimbro a
            WHERE UPPER(a.descrizione) LIKE UPPER(:filtro)
               OR UPPER(a.descrizioneProgressivo) LIKE UPPER(:filtro)
        """,
        countQuery = """
            SELECT COUNT(a) FROM EleTimbro a
            WHERE UPPER(a.descrizione) LIKE UPPER(:filtro)
               OR UPPER(a.descrizioneProgressivo) LIKE UPPER(:filtro)
        """
    )
    Page<EleTimbro> findAllByFiltroLike(@Param("filtro") String filtro, Pageable pageable)
}