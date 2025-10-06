package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivNumerazioneDocumentiUscita
import it.finmatica.de4gsdzk.statocivile.CivRegistroDocumentiUscita
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivNumerazioneDocumentiUscitaRepository extends JpaRepository<CivNumerazioneDocumentiUscita, Long> {

    @Query("""SELECT c FROM CivNumerazioneDocumentiUscita c WHERE c.registro.id = :idRegistro """)
    List<CivNumerazioneDocumentiUscita> findAllByIdRegistro(@Param("idRegistro") Integer idRegistro)

    //@Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("""SELECT c FROM CivNumerazioneDocumentiUscita c JOIN FETCH c.registro
                      WHERE c.registro = :registro 
                        AND c.anno = :anno """)
    CivNumerazioneDocumentiUscita findByAnnoAndRegistro(@Param("anno") Integer anno, @Param("registro") CivRegistroDocumentiUscita registro)

}