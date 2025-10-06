package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivUnioneCivile
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivUnioneCivileRepository extends JpaRepository<CivUnioneCivile, Long>, CivUnioneCivileCustomRepository {

    @Query("SELECT n.codiceRecord FROM CivUnioneCivile n WHERE n.id = :id ")
    Integer findCodiceRecord(@Param("id") Long id)

    @Query("SELECT n.bloccato FROM CivUnioneCivile n WHERE n.id = :id ")
    Boolean findBloccato(@Param("id") Long id)

    @Query("SELECT n.certificabile FROM CivUnioneCivile n WHERE n.id = :id ")
    ETipoSiNo findCertificabile(@Param("id") Long id)

    @Query("SELECT n.idAttoAnsc FROM CivUnioneCivile n WHERE n.id = :id ")
    String findIdAttoAnsc(@Param("id") Long id)

    @Query("SELECT n.flagFirmatoUscAnsc FROM CivUnioneCivile n WHERE n.id = :id ")
    Boolean findFirmatoUscAnsc(@Param("id") Long id)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM AnscComunicazione c, CivFascicoloAttoAllegato fal, CivUnioneCivile n
               WHERE c.archivioRif = it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc.ALL 
                 AND c.servizio.flagFirmaCartacea = java.lang.Boolean.TRUE AND c.inviato = java.lang.Boolean.TRUE 
                 AND fal.id = c.idRif
                 AND fal.fascicoloAtto.idAtto = n.idAtto
                 AND n.id = :id """)
    Integer findFirmatoCartaceoAnsc(@Param("id") Long id)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM AnscComunicazione c, CivUnioneCivile n
               WHERE c.servizio.flagAttestazione = java.lang.Boolean.TRUE AND c.inviato = java.lang.Boolean.TRUE 
                 AND c.idRif = n.id
                 AND c.archivioRif = :archivioRif
                 AND n.id = :id """)
    Integer findConformeAnsc(@Param("id") Long id, @Param("archivioRif") ETipoArchivioAnsc archivioRif)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM AnscComunicazione c, CivFascicoloAttoAllegato fal, CivUnioneCivile n
               WHERE c.archivioRif = it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc.ALL 
                 AND c.inviato = java.lang.Boolean.TRUE 
                 AND fal.id = c.idRif
                 AND fal.fascicoloAtto.idAtto = n.idAtto
                 AND fal.flagDaAttestareAnsc = java.lang.Boolean.TRUE
                 AND n.id = :id """)
    Integer hasAllegatiInviatiAnsc(@Param("id") Long id)

    @Modifying
    @Query("UPDATE CivUnioneCivile c SET c.idAnscUseCase = :idAnscUseCase WHERE c.id = :id")
    void updateIdAnscUseCase(@Param(value = "id") Long id, @Param(value = "idAnscUseCase") Long idAnscUseCase)

    @Modifying
    @Query("UPDATE CivUnioneCivile c SET c.idAttoAnsc = :idAttoAnsc WHERE c.id = :id")
    void updateIdAttoAnsc(@Param(value = "id") Long id, @Param(value = "idAttoAnsc") String idAttoAnsc)

    @Modifying
    @Query("UPDATE CivUnioneCivile c SET c.motivoRecuperoAnsc = :motivoRecuperoAnsc WHERE c.id = :id")
    void updateMotivoRecuperoAnsc(@Param(value = "id") Long id, @Param(value = "motivoRecuperoAnsc") EMotivoRecupero motivoRecuperoAnsc)

    @Query("SELECT c.motivoRecuperoAnsc FROM CivUnioneCivile c WHERE c.id = :id ")
    EMotivoRecupero findMotivoRecuperoAnsc(@Param("id") Long id)

    @Query("""SELECT m FROM CivUnioneCivile m WHERE m.cognome1 = :cn1 AND m.nome1 = :n1 AND m.dataNascita1 = :dn1 
                                                AND m.cognome2 = :cn2 AND m.nome2 = :n2 AND m.dataNascita2 = :dn2 
                                                AND m.natura = :natura """)
    List<CivUnioneCivile> listXDatiAnagraficiSposi(@Param("cn1") String cn1, @Param("n1") String n1, @Param("dn1") Date dn1,
                                                   @Param("cn2") String cn2, @Param("n2") String n2, @Param("dn2") Date dn2,
                                                   @Param("natura") ENaturaAtto natura)

    long countByUfficioAndAnnoAndAttoAndParteAndSerieIsNull(Integer ufficio, Integer anno, Integer atto, Integer parte)

    long countByIdAttoAnsc(String idAttoAnsc)

    CivUnioneCivile findByIdAttoAnsc(String idAttoAnsc)

    @Query("SELECT n FROM CivUnioneCivile n LEFT OUTER JOIN FETCH n.tipoAttoDomain t LEFT OUTER JOIN FETCH t.categoriaDomain c WHERE n.cognome1 = :cognome AND n.nome1 = :nome AND n.dataNascita1 = :dataNascita AND n.sesso1 = :sesso")
    List<CivUnioneCivile> findAllByCognome1AndNome1AndDataNascita1AndSesso1(@Param("cognome") String cognome, @Param("nome") String nome, @Param("dataNascita") Date dataNascita, @Param("sesso") ESesso sesso)

    @Query("SELECT n FROM CivUnioneCivile n LEFT OUTER JOIN FETCH n.tipoAttoDomain t LEFT OUTER JOIN FETCH t.categoriaDomain c WHERE n.cognome2 = :cognome AND n.nome2 = :nome AND n.dataNascita2 = :dataNascita AND n.sesso2 = :sesso")
    List<CivUnioneCivile> findAllByCognome2AndNome2AndDataNascita2AndSesso2(@Param("cognome") String cognome, @Param("nome") String nome, @Param("dataNascita") Date dataNascita, @Param("sesso") ESesso sesso)

    List<CivUnioneCivile> findAllByIdIn(List<Long> ids)
}