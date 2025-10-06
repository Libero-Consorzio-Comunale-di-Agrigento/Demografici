package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivCittadinanza
import it.finmatica.de4gsdzk.utils.EMotivoRecupero
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivCittadinanzaRepository extends JpaRepository<CivCittadinanza, Long>, CivCittadinanzaCustomRepository {

    @Query("SELECT n.codiceRecord FROM CivCittadinanza n WHERE n.id = :id ")
    Integer findCodiceRecord(@Param("id") Long id)

    @Query("SELECT n.bloccato FROM CivCittadinanza n WHERE n.id = :id ")
    Boolean findBloccato(@Param("id") Long id)

    @Query("SELECT n.idAttoAnsc FROM CivCittadinanza n WHERE n.id = :id ")
    String findIdAttoAnsc(@Param("id") Long id)

    @Query("SELECT n.flagFirmatoUscAnsc FROM CivCittadinanza n WHERE n.id = :id ")
    Boolean findFirmatoUscAnsc(@Param("id") Long id)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM AnscComunicazione c, CivFascicoloAttoAllegato fal, CivCittadinanza n
               WHERE c.archivioRif = it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc.ALL 
                 AND c.servizio.flagFirmaCartacea = java.lang.Boolean.TRUE AND c.inviato = java.lang.Boolean.TRUE 
                 AND fal.id = c.idRif
                 AND fal.fascicoloAtto.idAtto = n.idAtto
                 AND n.id = :id """)
    Integer findFirmatoCartaceoAnsc(@Param("id") Long id)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM AnscComunicazione c, CivCittadinanza n
               WHERE c.servizio.flagAttestazione = java.lang.Boolean.TRUE AND c.inviato = java.lang.Boolean.TRUE 
                 AND c.idRif = n.id
                 AND c.archivioRif = :archivioRif
                 AND n.id = :id """)
    Integer findConformeAnsc(@Param("id") Long id, @Param("archivioRif") ETipoArchivioAnsc archivioRif)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM AnscComunicazione c, CivFascicoloAttoAllegato fal, CivCittadinanza n
               WHERE c.archivioRif = it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc.ALL 
                 AND c.inviato = java.lang.Boolean.TRUE 
                 AND fal.id = c.idRif
                 AND fal.fascicoloAtto.idAtto = n.idAtto
                 AND fal.flagDaAttestareAnsc = java.lang.Boolean.TRUE
                 AND n.id = :id """)
    Integer hasAllegatiInviatiAnsc(@Param("id") Long id)

    @Modifying
    @Query("UPDATE CivCittadinanza c SET c.idAnscUseCase = :idAnscUseCase WHERE c.id = :id")
    void updateIdAnscUseCase(@Param(value = "id") Long id, @Param(value = "idAnscUseCase") Long idAnscUseCase)

    @Modifying
    @Query("UPDATE CivCittadinanza c SET c.idAttoAnsc = :idAttoAnsc WHERE c.id = :id")
    void updateIdAttoAnsc(@Param(value = "id") Long id, @Param(value = "idAttoAnsc") String idAttoAnsc)

    @Modifying
    @Query("UPDATE CivCittadinanza c SET c.motivoRecuperoAnsc = :motivoRecuperoAnsc WHERE c.id = :id")
    void updateMotivoRecuperoAnsc(@Param(value = "id") Long id, @Param(value = "motivoRecuperoAnsc") EMotivoRecupero motivoRecuperoAnsc)

    @Query("SELECT c.motivoRecuperoAnsc FROM CivCittadinanza c WHERE c.id = :id ")
    EMotivoRecupero findMotivoRecuperoAnsc(@Param("id") Long id)

    long countByUfficioAndAnnoAndAttoAndParteIsNullAndSerieIsNull(Integer ufficio, Integer anno, Integer atto)
}