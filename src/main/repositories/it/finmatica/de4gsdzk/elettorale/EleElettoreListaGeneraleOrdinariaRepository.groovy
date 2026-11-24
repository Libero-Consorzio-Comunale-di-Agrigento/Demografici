package it.finmatica.de4gsdzk.elettorale


import it.finmatica.de4gsdzk.utils.EStatoElettore
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface EleElettoreListaGeneraleOrdinariaRepository extends JpaRepository<EleElettoreListaGeneraleOrdinaria, Long> {

    @Query("""
        SELECT e FROM EleElettoreListaGeneraleOrdinaria e
        WHERE e.progressivo IS NOT NULL
        ORDER BY e.progressivo
    """)
    List<EleElettoreListaGeneraleOrdinaria> findAllOrderByProgressivo()

    @Query("""
        SELECT e FROM EleElettoreListaGeneraleOrdinaria e
        WHERE e.progressivo BETWEEN :progressivoDa AND :progressivoA
        ORDER BY e.progressivo
    """)
    List<EleElettoreListaGeneraleOrdinaria> findAllByProgressivoOrderByProgressivo(@Param("progressivoDa") Long progressivoDa,
                                                                                   @Param("progressivoA") Long progressivoA)

}