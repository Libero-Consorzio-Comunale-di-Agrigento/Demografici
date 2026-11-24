package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.de4gsdzk.utils.ETipoComunicazioneAnagrafe
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param


interface AnaCondizioneSqlRepository extends JpaRepository<AnaCondizioneSql, Integer> {


    @Query("""SELECT c FROM AnaCondizioneSql c
                WHERE c.tipoComunicazione = :tipoComunicazione 
                AND c.id NOT IN (:codiciPresenti)""")
    List<AnaCondizioneSql> findAllByTipoComunicazioneAndIdNotIn(@Param("tipoComunicazione") ETipoComunicazioneAnagrafe tipoComunicazione,
                                                                @Param("codiciPresenti") List<Integer> codiciPresenti)

    List<AnaCondizioneSql> findAllByTipoComunicazione(ETipoComunicazioneAnagrafe tipoComunicazione)

}