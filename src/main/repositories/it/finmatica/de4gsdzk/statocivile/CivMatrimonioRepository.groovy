package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivMatrimonio
import it.finmatica.de4gsdzk.utils.EMotivoRecupero
import it.finmatica.de4gsdzk.utils.ENaturaAtto
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivMatrimonioRepository extends JpaRepository<CivMatrimonio, Long>, CivMatrimonioCustomRepository {

    @Query("SELECT n.codiceRecord FROM CivMatrimonio n WHERE n.id = :id ")
    Integer findCodiceRecord(@Param("id") Long id)

    @Query("SELECT n.bloccato FROM CivMatrimonio n WHERE n.id = :id ")
    Boolean findBloccato(@Param("id") Long id)

    @Query("SELECT n.certificabile FROM CivMatrimonio n WHERE n.id = :id ")
    ETipoSiNo findCertificabile(@Param("id") Long id)

    @Query("SELECT n.idAttoAnsc FROM CivMatrimonio n WHERE n.id = :id ")
    String findIdAttoAnsc(@Param("id") Long id)

    @Query("SELECT n.flagFirmatoUscAnsc FROM CivMatrimonio n WHERE n.id = :id ")
    Boolean findFirmatoUscAnsc(@Param("id") Long id)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM AnscComunicazione c, CivFascicoloAttoAllegato fal, CivMatrimonio n
               WHERE c.archivioRif = it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc.ALL 
                 AND c.servizio.flagFirmaCartacea = java.lang.Boolean.TRUE AND c.inviato = java.lang.Boolean.TRUE 
                 AND fal.id = c.idRif
                 AND fal.fascicoloAtto.idAtto = n.idAtto
                 AND n.id = :id """)
    Integer findFirmatoCartaceoAnsc(@Param("id") Long id)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM AnscComunicazione c, CivMatrimonio n
               WHERE c.servizio.flagAttestazione = java.lang.Boolean.TRUE AND c.inviato = java.lang.Boolean.TRUE 
                 AND c.idRif = n.id
                 AND c.archivioRif = :archivioRif
                 AND n.id = :id """)
    Integer findConformeAnsc(@Param("id") Long id, @Param("archivioRif") ETipoArchivioAnsc archivioRif)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM AnscComunicazione c, CivFascicoloAttoAllegato fal, CivMatrimonio n
               WHERE c.archivioRif = it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc.ALL 
                 AND c.inviato = java.lang.Boolean.TRUE 
                 AND fal.id = c.idRif
                 AND fal.fascicoloAtto.idAtto = n.idAtto
                 AND fal.flagDaAttestareAnsc = java.lang.Boolean.TRUE
                 AND n.id = :id """)
    Integer hasAllegatiInviatiAnsc(@Param("id") Long id)

    @Modifying
    @Query("UPDATE CivMatrimonio c SET c.idAnscUseCase = :idAnscUseCase WHERE c.id = :id")
    void updateIdAnscUseCase(@Param(value = "id") Long id, @Param(value = "idAnscUseCase") Long idAnscUseCase)

    @Modifying
    @Query("UPDATE CivMatrimonio c SET c.idAttoAnsc = :idAttoAnsc WHERE c.id = :id")
    void updateIdAttoAnsc(@Param(value = "id") Long id, @Param(value = "idAttoAnsc") String idAttoAnsc)

    @Modifying
    @Query("UPDATE CivMatrimonio c SET c.motivoRecuperoAnsc = :motivoRecuperoAnsc WHERE c.id = :id")
    void updateMotivoRecuperoAnsc(@Param(value = "id") Long id, @Param(value = "motivoRecuperoAnsc") EMotivoRecupero motivoRecuperoAnsc)

    @Query("SELECT c.motivoRecuperoAnsc FROM CivMatrimonio c WHERE c.id = :id ")
    EMotivoRecupero findMotivoRecuperoAnsc(@Param("id") Long id)

    @Query("""SELECT m FROM CivMatrimonio m WHERE m.cognome1 = :cognome1 AND m.nome1 = :nome1 AND m.dataNascita1 = :dataNascita1 
                                              AND m.cognome2 = :cognome2 AND m.nome2 = :nome2 AND m.dataNascita2 = :dataNascita2 
                                              AND m.natura = :natura """)
    List<CivMatrimonio> listXDatiAnagraficiSposi(@Param("cognome1") String cognome1, @Param("nome1") String nome1, @Param("dataNascita1") Date dataNascita1,
                                                 @Param("cognome2") String cognome2, @Param("nome2") String nome2, @Param("dataNascita2") Date dataNascita2,
                                                 @Param("natura") ENaturaAtto natura)

    @Query("""SELECT m FROM CivMatrimonio m INNER JOIN m.tipoAttoDomain.categoriaDomain
               WHERE m.cognome1 = :cognome1 AND m.nome1 = :nome1 AND m.dataNascita1 = :dataNascita1 
                 AND m.cognome2 = :cognome2 AND m.nome2 = :nome2 AND m.dataNascita2 = :dataNascita2 
                 AND m.natura = :natura 
                 AND m.tipoAttoDomain.categoriaDomain.codice = :siglaCategoria """)
    List<CivMatrimonio> listAccordoXDatiAnagraficiSposi(@Param("cognome1") String cognome1, @Param("nome1") String nome1, @Param("dataNascita1") Date dataNascita1,
                                                        @Param("cognome2") String cognome2, @Param("nome2") String nome2, @Param("dataNascita2") Date dataNascita2,
                                                        @Param("natura") ENaturaAtto natura, @Param("siglaCategoria") String siglaCategoria)

    long countByUfficioAndAnnoAndAttoAndParteAndSerie(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie)

    long countByIdAttoAnsc(String idAttoAnsc)

    CivMatrimonio findByIdAttoAnsc(String idAttoAnsc)

    @Query("SELECT n FROM CivMatrimonio n LEFT OUTER JOIN FETCH n.tipoAttoDomain t LEFT OUTER JOIN FETCH t.categoriaDomain c WHERE n.cognome1 = :cognome AND n.nome1 = :nome AND n.dataNascita1 = :dataNascita")
    List<CivMatrimonio> findAllByCognome1AndNome1AndDataNascita1AndNatura(@Param("cognome") String cognome, @Param("nome") String nome, @Param("dataNascita") Date dataNascita)

    @Query("SELECT n FROM CivMatrimonio n LEFT OUTER JOIN FETCH n.tipoAttoDomain t LEFT OUTER JOIN FETCH t.categoriaDomain c WHERE n.cognome2 = :cognome AND n.nome2 = :nome AND n.dataNascita2 = :dataNascita")
    List<CivMatrimonio> findAllByCognome2AndNome2AndDataNascita2AndNatura(@Param("cognome") String cognome, @Param("nome") String nome, @Param("dataNascita") Date dataNascita)

    List<CivMatrimonio> findAllByIdIn(List<Long> ids)
}