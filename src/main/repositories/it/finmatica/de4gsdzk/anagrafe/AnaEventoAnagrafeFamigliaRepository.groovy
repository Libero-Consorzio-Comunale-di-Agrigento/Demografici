package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaEventoAnagrafeFamigliaRepository extends JpaRepository<AnaEventoAnagrafeFamiglia, Integer> {
    @Query("""SELECT e FROM AnaEventoAnagrafeFamiglia e
              JOIN FETCH e.anagrafe
              WHERE e.famiglia = :famiglia
                AND e.dataEvento = (select max(b.dataEvento) 
                                      from AnaEventoAnagrafeFamiglia b 
                                     where b.famiglia    = :famiglia
                                       and b.dataEvento <= :dataEvento)
            """)
    List<AnaEventoAnagrafeFamiglia> findAllByFamigliaAndDataEvento(@Param("famiglia") AnaFamiglia famiglia,
                                                                   @Param("dataEvento") Date dataEvento,
                                                                   Sort sort)
}