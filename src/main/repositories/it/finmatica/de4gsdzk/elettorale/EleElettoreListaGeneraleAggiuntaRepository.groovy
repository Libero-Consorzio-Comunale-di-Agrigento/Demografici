package it.finmatica.de4gsdzk.elettorale

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.de4gsdzk.utils.EStatoElettore
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface EleElettoreListaGeneraleAggiuntaRepository extends JpaRepository<EleElettoreListaGeneraleAggiunta, Long> {

    @Query("""
        SELECT e FROM EleElettoreListaGeneraleAggiunta e
        JOIN FETCH e.tipoLista t 
        WHERE e.progressivo IS NOT NULL
        AND e.tipoLista = :tipoLista
        ORDER BY e.progressivo
    """)
    List<EleElettoreListaGeneraleAggiunta> findAllOrderByProgressivo(@Param("tipoLista") EleTipoLista tipoLista)

    @Query("""
        SELECT e FROM EleElettoreListaGeneraleAggiunta e
        JOIN FETCH e.tipoLista t
        WHERE e.progressivo BETWEEN :progressivoDa AND :progressivoA
        AND e.tipoLista = :tipoLista
        ORDER BY e.progressivo
    """)
    List<EleElettoreListaGeneraleAggiunta> findAllByProgressivoOrderByProgressivo(@Param("progressivoDa") Long progressivoDa,
                                                                                  @Param("progressivoA") Long progressivoA,
                                                                                  @Param("tipoLista") EleTipoLista tipoLista)


}