package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivRegistroDocumentiUscita
import it.finmatica.de4gsdzk.statocivile.CivTrasportoESeppellimento
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivTrasportoESeppellimentoRepository extends JpaRepository<CivTrasportoESeppellimento, Long> {

    @Query("""SELECT c FROM CivTrasportoESeppellimento c LEFT OUTER JOIN FETCH c.registroTrasporto 
                                                         LEFT OUTER JOIN FETCH c.registroSeppellimento 
                                                         LEFT OUTER JOIN FETCH c.registroCremazione
                       WHERE c.id = :id """)
    CivTrasportoESeppellimento findById(@Param("id") Long id)

    @Query("""SELECT c FROM CivTrasportoESeppellimento c LEFT OUTER JOIN FETCH c.registroTrasporto 
                                                         LEFT OUTER JOIN FETCH c.registroSeppellimento 
                                                         LEFT OUTER JOIN FETCH c.registroCremazione
                       WHERE c.idAtto = :identificativoAtto """)
    CivTrasportoESeppellimento findByUkAtto(@Param("identificativoAtto") String identificativoAtto)

    @Query("""SELECT DISTINCT(c.cimiteroDestinazione) FROM CivTrasportoESeppellimento c 
                                                      WHERE UPPER(c.cimiteroDestinazione) LIKE UPPER(:filtro) 
                                                        AND c.cimiteroDestinazione IS NOT NULL """)
    List<String> findAllDistinctCimiteroByCimiteroLike(@Param("filtro") String filtro)

    @Query("""SELECT DISTINCT(c.dittaOnoranze) FROM CivTrasportoESeppellimento c 
                                               WHERE UPPER(c.dittaOnoranze) LIKE UPPER(:filtro) 
                                                 AND c.dittaOnoranze IS NOT NULL """)
    List<String> findAllDistinctDittaOnoranzeByDittaOnoranzeLike(@Param("filtro") String filtro)

    //-------------------------------------------------------------------------------------
    // trova tutti i CIVDTS che hanno lo stesso numero di protocollo nei vari registri (per controllo)
    //
    List<CivTrasportoESeppellimento> findAllByIdNotAndRegistroTrasportoAndAnnoProtocolloTrasportoAndNumeroProtocolloTrasporto(
            @Param("id") Long id,
            @Param("registroTrasporto") CivRegistroDocumentiUscita registro,
            @Param("annoProtocolloTrasporto") Integer anno,
            @Param("numeroProtocolloTrasporto") Integer numero)
    List<CivTrasportoESeppellimento> findAllByIdNotAndRegistroSeppellimentoAndAnnoProtocolloSeppellimentoAndNumeroProtocolloSeppellimento(
            @Param("id") Long id,
            @Param("registroSeppellimento") CivRegistroDocumentiUscita registro,
            @Param("annoProtocolloSeppellimento") Integer anno,
            @Param("numeroProtocolloSeppellimento") Integer numero)
    List<CivTrasportoESeppellimento> findAllByIdNotAndRegistroCremazioneAndAnnoProtocolloCremazioneAndNumeroProtocolloCremazione(
            @Param("id") Long id,
            @Param("registroCremazione") CivRegistroDocumentiUscita registro,
            @Param("annoProtocolloCremazione") Integer anno,
            @Param("numeroProtocolloCremazione") Integer numero)
    //
    //----------------------------------------------------------------------------------------

}