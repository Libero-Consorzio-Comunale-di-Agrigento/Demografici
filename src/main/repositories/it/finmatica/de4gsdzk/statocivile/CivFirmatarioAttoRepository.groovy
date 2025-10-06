package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivFirmatarioAtto
import it.finmatica.de4gsdzk.utils.ETipoFirmaAnsc
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivFirmatarioAttoRepository extends JpaRepository<CivFirmatarioAtto, Long> {

    CivFirmatarioAtto findById(Long id)

    List<CivFirmatarioAtto> findAllByIdAtto(String identificativoAtto, Sort s)

    List<CivFirmatarioAtto> findAllByIdAttoAndTipoFirma(String identificativoAtto, ETipoFirmaAnsc tipoFirma, Sort s)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM CivFirmatarioAtto c 
               WHERE c.idAtto = :identificativoAtto
                 AND (c.tipoFirma IS NULL OR
                     (c.tipoFirma = it.finmatica.de4gsdzk.utils.ETipoFirmaAnsc.EL AND c.indirizzoMail IS NULL) ) """)
    Integer existsFirmatarioNonValido(@Param("identificativoAtto") String identificativoAtto)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM CivFirmatarioAtto c 
               WHERE c.idAtto = :identificativoAtto
                 AND c.tipoFirma = it.finmatica.de4gsdzk.utils.ETipoFirmaAnsc.EL 
                 AND ( c.idAnscPresaVisione IS NULL OR COALESCE(c.statoAnscPresaVisione, 0) = 0 )""")
    Integer existsFirmatarioELNonGestito(@Param("identificativoAtto") String identificativoAtto)

    @Query("""SELECT 1 AS NON_VALIDO
                FROM CivFirmatarioAtto c 
               WHERE c.id = :id
                 AND (c.tipoFirma IS NULL OR
                      c.tipoFirma = it.finmatica.de4gsdzk.utils.ETipoFirmaAnsc.CA OR
                     (c.tipoFirma = it.finmatica.de4gsdzk.utils.ETipoFirmaAnsc.EL AND c.indirizzoMail IS NULL) ) """)
    Integer isFirmatarioELNonValido(@Param("id") Long id)

    @Query("""SELECT 1 AS NON_GESTITO
                FROM CivFirmatarioAtto c 
               WHERE c.id = :id
                 AND c.tipoFirma = it.finmatica.de4gsdzk.utils.ETipoFirmaAnsc.EL
                 AND c.idAnscPresaVisione IS NULL """)
    Integer isFirmatarioELNonGestito(@Param("id") Long id)

    @Query("""SELECT 1 AS NON_GESTITO
                FROM CivFirmatarioAtto c 
               WHERE c.id = :id
                 AND c.tipoFirma = it.finmatica.de4gsdzk.utils.ETipoFirmaAnsc.EL
                 AND c.idAnscPresaVisione IS NOT NULL 
                 AND c.statoAnscPresaVisione IS NULL""")
    Integer isFirmatarioELInGestione(@Param("id") Long id)

    @Query("""SELECT c.statoAnscPresaVisione
                FROM CivFirmatarioAtto c 
               WHERE c.id = :id 
                 AND c.tipoFirma = it.finmatica.de4gsdzk.utils.ETipoFirmaAnsc.EL """)
    Integer getFirmatarioELStatoPresaVisione(@Param("id") Long id)
}