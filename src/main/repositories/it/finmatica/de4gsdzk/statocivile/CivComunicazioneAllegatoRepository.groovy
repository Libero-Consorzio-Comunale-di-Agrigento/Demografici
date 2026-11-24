package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.IComunicazioneAllegatoRepository
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivComunicazioneAllegatoRepository extends JpaRepository<CivComunicazioneAllegato, Long>, IComunicazioneAllegatoRepository {

    @Query("""SELECT c 
                FROM CivComunicazioneAllegato c INNER JOIN FETCH c.archivioComunicazione 
               WHERE c.id = :id """)
    CivComunicazioneAllegato findById(@Param("id") Long id)

    @Query("""SELECT COUNT(c) AS NUM_ALLE_DA_FIRMARE 
                FROM CivComunicazioneAllegato c 
                WHERE c.daFirmare = java.lang.Boolean.TRUE
                  AND c.archivioComunicazione.id IN (:listaIdArcCom) """)
    Integer checkAllegatiDaFirmare(@Param("listaIdArcCom") List<Long> listaIdArcCom)

    @Query("""SELECT c, c.archivioComunicazione 
                FROM CivComunicazioneAllegato c INNER JOIN c.archivioComunicazione AS a
               WHERE c.principale = java.lang.Boolean.TRUE 
                 AND a.id = :idArcCom """)
    CivComunicazioneAllegato findPrincipale(@Param("idArcCom") Long idArcCom)

    @Query("""SELECT c 
              FROM CivComunicazioneAllegato c
              INNER JOIN FETCH c.archivioComunicazione
              WHERE c.archivioComunicazione.id = :idArcCom """)
    List<CivComunicazioneAllegato[]> findAllMetadatiByArchivioComunicazione(@Param("idArcCom") Long idArcCom)

    @Query("""SELECT COUNT(c) AS NUM_ALLEGATI FROM CivComunicazioneAllegato c 
               WHERE c.archivioComunicazione.id = :idArcCom 
                 AND (:id IS NULL OR c.id != :id)
                 AND c.nomeAllegato = :nomeAllegato """)
    Integer getNumAllegatiComunicazioneByNome(@Param("idArcCom") Long idArcCom,
                                              @Param("id") Long id,
                                              @Param("nomeAllegato") String nomeAllegato)

}