package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivNascita
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivNascitaRepository extends JpaRepository<CivNascita, Long>, CivNascitaCustomRepository {

    @Query("SELECT n.codiceRecord FROM CivNascita n WHERE n.id = :id ")
    Integer findCodiceRecord(@Param("id") Long id)

    @Query("SELECT n.bloccato FROM CivNascita n WHERE n.id = :id ")
    Boolean findBloccato(@Param("id") Long id)

    @Query("SELECT n.certificabile FROM CivNascita n WHERE n.id = :id ")
    ETipoSiNo findCertificabile(@Param("id") Long id)

    @Query("SELECT n.idAttoAnsc FROM CivNascita n WHERE n.id = :id ")
    String findIdAttoAnsc(@Param("id") Long id)

    @Query("SELECT n.flagFirmatoUscAnsc FROM CivNascita n WHERE n.id = :id ")
    Boolean findFirmatoUscAnsc(@Param("id") Long id)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM AnscComunicazione c, CivFascicoloAttoAllegato fal, CivNascita n
               WHERE c.archivioRif = it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc.ALL 
                 AND c.servizio.flagFirmaCartacea = java.lang.Boolean.TRUE AND c.inviato = java.lang.Boolean.TRUE 
                 AND fal.id = c.idRif
                 AND fal.fascicoloAtto.idAtto = n.idAtto
                 AND n.id = :id """)
    Integer findFirmatoCartaceoAnsc(@Param("id") Long id)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM AnscComunicazione c, CivNascita n
               WHERE c.servizio.flagAttestazione = java.lang.Boolean.TRUE AND c.inviato = java.lang.Boolean.TRUE 
                 AND c.idRif = n.id
                 AND c.archivioRif = :archivioRif
                 AND n.id = :id """)
    Integer findConformeAnsc(@Param("id") Long id, @Param("archivioRif") ETipoArchivioAnsc archivioRif)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM AnscComunicazione c, CivFascicoloAttoAllegato fal, CivNascita n
               WHERE c.archivioRif = it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc.ALL 
                 AND c.inviato = java.lang.Boolean.TRUE 
                 AND fal.id = c.idRif
                 AND fal.fascicoloAtto.idAtto = n.idAtto
                 AND fal.flagDaAttestareAnsc = java.lang.Boolean.TRUE
                 AND n.id = :id """)
    Integer hasAllegatiInviatiAnsc(@Param("id") Long id)

    @Modifying
    @Query("UPDATE CivNascita c SET c.idAnscUseCase = :idAnscUseCase WHERE c.id = :id")
    void updateIdAnscUseCase(@Param(value = "id") Long id, @Param(value = "idAnscUseCase") Long idAnscUseCase)

    @Modifying
    @Query("UPDATE CivNascita c SET c.idAttoAnsc = :idAttoAnsc WHERE c.id = :id")
    void updateIdAttoAnsc(@Param(value = "id") Long id, @Param(value = "idAttoAnsc") String idAttoAnsc)

    @Modifying
    @Query("UPDATE CivNascita c SET c.motivoRecuperoAnsc = :motivoRecuperoAnsc WHERE c.id = :id")
    void updateMotivoRecuperoAnsc(@Param(value = "id") Long id, @Param(value = "motivoRecuperoAnsc") EMotivoRecupero motivoRecuperoAnsc)

    @Query("SELECT c.motivoRecuperoAnsc FROM CivNascita c WHERE c.id = :id ")
    EMotivoRecupero findMotivoRecuperoAnsc(@Param("id") Long id)

    long countByUfficioAndAnnoAndAttoAndParteAndSerie(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie)

    long countByIdAttoAnsc(String idAttoAnsc)

    CivNascita findByIdAttoAnsc(String idAttoAnsc)

    List<CivNascita> findAllByCognomeAndNomeAndDataNascitaAndSessoAndNatura(String cognome, String nome, Date dataNascita,
                                                                            ESesso sesso, ENaturaAtto natura)

    @Query("SELECT n FROM CivNascita n LEFT OUTER JOIN FETCH n.tipoAttoDomain t LEFT OUTER JOIN FETCH t.categoriaDomain c WHERE n.cognome = :cognome AND n.nome = :nome AND n.dataNascita = :dataNascita AND n.sesso = :sesso")
    List<CivNascita> findAllByCognomeAndNomeAndDataNascitaAndSesso(@Param("cognome") String cognome, @Param("nome") String nome, @Param("dataNascita") Date dataNascita, @Param("sesso") ESesso sesso)

    List<CivNascita> findAllByIdIn(List<Long> ids)
}