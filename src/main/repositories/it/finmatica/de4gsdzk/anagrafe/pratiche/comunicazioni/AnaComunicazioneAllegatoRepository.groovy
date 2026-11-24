package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.IComunicazioneAllegatoRepository
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaComunicazioneAllegatoRepository extends JpaRepository<AnaComunicazioneAllegato, Long>, IComunicazioneAllegatoRepository {

    @Query("""SELECT c 
                FROM AnaComunicazioneAllegato c INNER JOIN FETCH c.archivioComunicazione 
               WHERE c.id = :id """)
    AnaComunicazioneAllegato findById(@Param("id") Long id)

    @Query("""SELECT COUNT(c) AS NUM_ALLE_DA_FIRMARE 
                FROM AnaComunicazioneAllegato c 
                WHERE c.daFirmare = java.lang.Boolean.TRUE
                  AND c.archivioComunicazione.id IN (:listaIdArcCom) """)
    Integer checkAllegatiDaFirmare(@Param("listaIdArcCom") List<Long> listaIdArcCom)

    @Query("""SELECT c
                FROM AnaComunicazioneAllegato c
                LEFT JOIN FETCH c.archivioComunicazione
               WHERE c.principale = java.lang.Boolean.TRUE 
                 AND c.archivioComunicazione.id = :idArcCom """)
    AnaComunicazioneAllegato findPrincipale(@Param("idArcCom") Long idArcCom)

    @Query("""SELECT c
              FROM AnaComunicazioneAllegato c
              LEFT JOIN FETCH c.archivioComunicazione
              WHERE c.archivioComunicazione.id = :idArcCom """)
    List<AnaComunicazioneAllegato> findAllMetadatiByArchivioComunicazione(@Param("idArcCom") Long idArcCom)

    @Query("""SELECT COUNT(c) AS NUM_ALLEGATI FROM AnaComunicazioneAllegato c 
               WHERE c.archivioComunicazione.id = :idArcCom 
                 AND (:id IS NULL OR c.id != :id)
                 AND c.nomeAllegato = :nomeAllegato """)
    Integer getNumAllegatiComunicazioneByNome(@Param("idArcCom") Long idArcCom,
                                              @Param("id") Long id,
                                              @Param("nomeAllegato") String nomeAllegato)

}