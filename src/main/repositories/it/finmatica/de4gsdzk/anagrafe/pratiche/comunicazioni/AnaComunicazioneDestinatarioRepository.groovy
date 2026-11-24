package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.IComunicazioneDestinatarioRepository
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaComunicazioneDestinatarioRepository extends JpaRepository<AnaComunicazioneDestinatario, Long>, IComunicazioneDestinatarioRepository {

    @Query("""SELECT c FROM AnaComunicazioneDestinatario c JOIN FETCH c.archivioComunicazione WHERE c.id = :id """)
    AnaComunicazioneDestinatario findById(@Param("id") Long id)

    @Query("""SELECT c FROM AnaComunicazioneDestinatario c LEFT JOIN FETCH c.ente JOIN FETCH c.archivioComunicazione WHERE c.archivioComunicazione.id = :idArcCom """)
    List<AnaComunicazioneDestinatario> findAllByArchivioComunicazione(@Param("idArcCom") Long idArcCom)

}