package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.IArchivioComunicazioneRepository
import it.finmatica.de4gsdzk.utils.EStatoInvioAlbo
import it.finmatica.de4gsdzk.utils.EStatoProtocollazione
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaArchivioComunicazioneRepository extends JpaRepository<AnaArchivioComunicazione, Long>, AnaArchivioComunicazioneCustomRepository, IArchivioComunicazioneRepository {

    @Query("""SELECT c FROM AnaArchivioComunicazione c JOIN FETCH c.comunicazione WHERE c.id = :id """)
    AnaArchivioComunicazione findById(@Param("id") Long id)

    @Query("SELECT c.statoProtocollazione FROM AnaArchivioComunicazione c WHERE c.id = :id ")
    EStatoProtocollazione findStatoProtocollazione(@Param("id") Long id)

    @Query("SELECT c.statoInvioAlbo FROM AnaArchivioComunicazione c WHERE c.id = :id ")
    EStatoInvioAlbo findStatoInvioAlbo(@Param("id") Long id)

    @Query("SELECT c.stampaEseguita FROM AnaArchivioComunicazione c WHERE c.id = :id ")
    Boolean findStampaEseguita(@Param("id") Long id)

    @Query("""SELECT COUNT(c) AS NUM_ALLE_PRINCIPALE 
                FROM AnaComunicazioneAllegato c 
               WHERE c.principale = java.lang.Boolean.TRUE 
                 AND c.archivioComunicazione.id = :idArcCom """)
    Integer checkAllegatoPrincipale(@Param("idArcCom") Long idArcCom)




}