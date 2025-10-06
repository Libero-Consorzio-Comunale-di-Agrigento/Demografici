package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivDisposizioniAnticipateTrattamento
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface CivDisposizioniAnticipateTrattamentoRepository extends JpaRepository<CivDisposizioniAnticipateTrattamento, Integer> {

    @Query(value = """SELECT c FROM CivDisposizioniAnticipateTrattamento c 
                               LEFT JOIN FETCH c.disponente.tipoDocumento 
                               LEFT JOIN FETCH c.fiduciario1.tipoDocumento 
                               LEFT JOIN FETCH c.fiduciario2.tipoDocumento 
                               LEFT JOIN FETCH c.disponente.ente 
                               LEFT JOIN FETCH c.fiduciario1.ente 
                               LEFT JOIN FETCH c.fiduciario2.ente 
                              WHERE c.id = :id """)
    CivDisposizioniAnticipateTrattamento findById(@Param("id") Integer id)

    @Query(value = """SELECT c FROM CivDisposizioniAnticipateTrattamento c
                              WHERE c.protocollo.anno = :annoProtocollo 
                                AND c.protocollo.numero = :numeroProtocollo
                                AND (:id IS NULL OR c.id <> :id)""")
    List<CivDisposizioniAnticipateTrattamento> findAllByIdNotAndProtocollo(@Param("id") Integer id, @Param("annoProtocollo") Integer annoProtocollo,
                                                                           @Param("numeroProtocollo") Integer numeroProtocollo)

}