package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivMorte
import it.finmatica.de4gsdzk.utils.EMotivoRecupero
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivMorteRepository extends JpaRepository<CivMorte, Long>, CivMorteCustomRepository {

    @Query("SELECT n FROM CivMorte n WHERE n.idAtto = :identificativoAtto ")
    CivMorte findByIdentificativoAtto(@Param("identificativoAtto") String identificativoAtto)

    @Query("SELECT n.codiceRecord FROM CivMorte n WHERE n.id = :id ")
    Integer findCodiceRecord(@Param("id") Long id)

    @Query("SELECT n.bloccato FROM CivMorte n WHERE n.id = :id ")
    Boolean findBloccato(@Param("id") Long id)

    @Query("SELECT n.certificabile FROM CivMorte n WHERE n.id = :id ")
    ETipoSiNo findCertificabile(@Param("id") Long id)

    @Query("SELECT n.idAttoAnsc FROM CivMorte n WHERE n.id = :id ")
    String findIdAttoAnsc(@Param("id") Long id)

    @Query("SELECT n.flagFirmatoUscAnsc FROM CivMorte n WHERE n.id = :id ")
    Boolean findFirmatoUscAnsc(@Param("id") Long id)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM AnscComunicazione c, CivFascicoloAttoAllegato fal, CivMorte n
               WHERE c.archivioRif = it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc.ALL 
                 AND c.servizio.flagFirmaCartacea = java.lang.Boolean.TRUE AND c.inviato = java.lang.Boolean.TRUE 
                 AND fal.id = c.idRif
                 AND fal.fascicoloAtto.idAtto = n.idAtto
                 AND n.id = :id """)
    Integer findFirmatoCartaceoAnsc(@Param("id") Long id)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM AnscComunicazione c, CivMorte n
               WHERE c.servizio.flagAttestazione = java.lang.Boolean.TRUE AND c.inviato = java.lang.Boolean.TRUE 
                 AND c.idRif = n.id
                 AND c.archivioRif = :archivioRif
                 AND n.id = :id """)
    Integer findConformeAnsc(@Param("id") Long id, @Param("archivioRif") ETipoArchivioAnsc archivioRif)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM AnscComunicazione c, CivFascicoloAttoAllegato fal, CivMorte n
               WHERE c.archivioRif = it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc.ALL 
                 AND c.inviato = java.lang.Boolean.TRUE 
                 AND fal.id = c.idRif
                 AND fal.fascicoloAtto.idAtto = n.idAtto
                 AND fal.flagDaAttestareAnsc = java.lang.Boolean.TRUE
                 AND n.id = :id """)
    Integer hasAllegatiInviatiAnsc(@Param("id") Long id)

    @Modifying
    @Query("UPDATE CivMorte c SET c.idAnscUseCase = :idAnscUseCase WHERE c.id = :id")
    void updateIdAnscUseCase(@Param(value = "id") Long id, @Param(value = "idAnscUseCase") Long idAnscUseCase)

    @Modifying
    @Query("UPDATE CivMorte c SET c.idAttoAnsc = :idAttoAnsc WHERE c.id = :id")
    void updateIdAttoAnsc(@Param(value = "id") Long id, @Param(value = "idAttoAnsc") String idAttoAnsc)

    @Modifying
    @Query("UPDATE CivMorte c SET c.motivoRecuperoAnsc = :motivoRecuperoAnsc WHERE c.id = :id")
    void updateMotivoRecuperoAnsc(@Param(value = "id") Long id, @Param(value = "motivoRecuperoAnsc") EMotivoRecupero motivoRecuperoAnsc)

    @Query("SELECT c.motivoRecuperoAnsc FROM CivMorte c WHERE c.id = :id ")
    EMotivoRecupero findMotivoRecuperoAnsc(@Param("id") Long id)

    long countByUfficioAndAnnoAndAttoAndParteAndSerie(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie)

    @Query("SELECT n FROM CivMorte n LEFT OUTER JOIN FETCH n.tipoAttoDomain t JOIN FETCH t.categoriaDomain c WHERE n.cognome = :cognome AND n.nome = :nome AND n.dataNascita = :dataNascita AND n.sesso = :sesso")
    List<CivMorte> findAllByCognomeAndNomeAndDataNascitaAndSessoAndNatura(@Param("cognome") String cognome, @Param("nome") String nome, @Param("dataNascita") Date dataNascita, @Param("sesso") ESesso sesso)

    List<CivMorte> findAllByIdIn(List<Long> ids)
}