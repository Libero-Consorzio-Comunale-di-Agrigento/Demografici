package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.IComunicazioneDestinatarioRepository
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneDestinatario
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivComunicazioneDestinatarioRepository extends JpaRepository<CivComunicazioneDestinatario, Long>, IComunicazioneDestinatarioRepository {

    @Query("""SELECT c FROM CivComunicazioneDestinatario c JOIN FETCH c.archivioComunicazione WHERE c.id = :id """)
    CivComunicazioneDestinatario findById(@Param("id") Long id)

    @Query("""SELECT c FROM CivComunicazioneDestinatario c LEFT JOIN FETCH c.ente JOIN FETCH c.archivioComunicazione WHERE c.archivioComunicazione.id = :idArcCom """)
    List<CivComunicazioneDestinatario> findAllByArchivioComunicazione(@Param("idArcCom") Long idArcCom)

    @Query("""SELECT distinct c.codiceComuneDestinatario, c.codiceProvinciaDestinatario
              , CASE WHEN (c.codiceComuneDestinatario IS NULL AND c.codiceProvinciaDestinatario IS NULL) THEN c.ente.id ELSE NULL END AS ente
                FROM CivComunicazioneDestinatario c LEFT JOIN c.ente
               WHERE c.archivioComunicazione.tipoAtto = :tipoAtto
                 AND c.archivioComunicazione.stampaEseguita = :stampaEseguita """)
    List<Object[]> findAllByTipoAttoAndStampaEseguita(@Param("tipoAtto") Integer tipoAtto, @Param("stampaEseguita") Boolean stampaEseguita)
}